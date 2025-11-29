import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephosx/model/enums.dart';
import 'package:nephosx/repositories/database/database.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/consumption.dart';
import '../../../model/consumption_period.dart';
import '../../../model/drink.dart';
import '../../../model/drinking_note.dart';
import '../../../model/month_summary.dart';
import '../../../model/stats.dart';
import '../../../model/user.dart';

part 'statistics_state.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DisplayPeriod { weekly, monthly, yearly }

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required this.user, required this.databaseRepository})
    : super(StatisticsInitial());

  // final ConsumptionBloc consumptionBloc;
  Set<DateTime> dates = {};
  Set<DateTime> months = {};

  late Stream<List<Consumption>> consumptionStream;
  late Stream<List<DrinkingNote>> notesStream;
  late Stream<List<Drink>> drinksStream;
  late StreamSubscription streamSubscription;

  List<DrinkingNote> notes = [];

  final User user;
  final DatabaseRepository databaseRepository;

  List<Consumption> consumptions = [];
  List<Drink> drinks = [];
  DateTime? selectedMonth;
  DateTime? selectedDate;
  StatisticsState previousState = StatisticsInitial();

  DateTime monthOf(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  void updateConsumptions() {
    consumptions.forEach((cons) {
      Drink? dr = drinks.firstWhereOrNull((drink) => drink.id == cons.drinkId);
      if (dr != null) {
        cons.drink = dr;
      }
    });
    consumptions.sort((a, b) => b.consumptionDate.compareTo(a.consumptionDate));
  }

  void startSubscriptions() {
    consumptionStream = databaseRepository.getConsumptionStream(user.uid);
    notesStream = databaseRepository.getDrinkingNoteStream(user.uid);
    drinksStream = databaseRepository.getDrinkStream();
    streamSubscription =
        Rx.combineLatest3(consumptionStream, notesStream, drinksStream, (
          List<Consumption> consumptionsRaw,
          List<DrinkingNote> notesRaw,
          List<Drink> drinksRaw,
        ) {
          return Stats(
            consumptions: consumptionsRaw,
            notes: notesRaw,
            drinks: drinksRaw,
          );
        }).listen((stats) {
          consumptions = stats.consumptions;
          notes = stats.notes;
          drinks = stats.drinks;
          updateConsumptions();
          switch (state) {
            case StatisticsFull _:
              selectAll();
              break;
            case StatisticsForMonth _:
              selectMonth((state as StatisticsForMonth).selectedMonth);
              break;
            case StatisticsForDate _:
              selectDate((state as StatisticsForDate).selectedDate);
              break;
            default:
              if (previousState is StatisticsInitial) {
                selectAll();
                break;
              }
              if (previousState is StatisticsForDate) {
                selectDate((previousState as StatisticsForDate).selectedDate);
                break;
              }
              if (previousState is StatisticsForMonth) {
                selectMonth(
                  (previousState as StatisticsForMonth).selectedMonth,
                );
                break;
              }
              if (previousState is StatisticsFull) {
                selectAll();
                break;
              }
              emit(previousState);
          }
        });
  }

  void addNote(DrinkingNote note) async {
    emit(StatisticsLoading());
    var ref = await databaseRepository.addDocument(
      collectionPath: 'users/${note.uid}/notes',
      data: note.toJson(),
    );
    await databaseRepository.updateDocument(
      docPath: ref['path'],
      data: {'id': ref['id']},
    );
    selectDate(note.date);
  }

  void updateNote(DrinkingNote note) async {
    emit(StatisticsLoading());
    await databaseRepository.updateDocument(
      docPath: 'users/${note.uid}/notes/${note.id}',
      data: note.toJson(),
    );
    selectDate(note.date);
  }

  void changeConsumptionSize({
    required Consumption cons,
    required DrinkSize size,
  }) async {
    previousState = state;
    emit(StatisticsLoading());
    // await FirebaseFirestore.instance
    //     .doc('users/${cons.uid}/diary/${cons.id}')
    //     .update(
    //       cons.copyWith(drinkSize: size, amountInMl: size.volumeInML).toJson(),
    //     );

    await databaseRepository.updateDocument(
      docPath: 'users/${cons.uid}/diary/${cons.id}',
      data: cons
          .copyWith(drinkSize: size, amountInMl: size.volumeInML)
          .toJson(),
    );
  }

  void deleteConsumption(Consumption consumption) async {
    previousState = state;
    emit(StatisticsLoading());
    await databaseRepository.delete(
      path: 'users/${consumption.uid}/diary/${consumption.id}',
    );
    // .doc('users/${consumption.uid}/diary/${consumption.id}')
    // .delete();
  }

  void selectAll() {
    emit(
      StatisticsFull(
        consumptionPeriod: ConsumptionPeriod(consumptions: consumptions),
      ),
    );
  }

  void selectMonth(DateTime theMonth) {
    selectedMonth = theMonth;
    emit(
      StatisticsForMonth(
        onCancel: selectAll,
        onTapDate: selectDate,
        selectedMonth: theMonth,
        consumptionPeriod: ConsumptionPeriod(
          consumptions: ConsumptionPeriod(consumptions: consumptions)
              .consumptionsForMonth(
                month: theMonth,
                sortOrder: SortOrder.descending,
              ),
        ),
      ),
    );
  }

  DrinkingNote? getDrinkingNote(DateTime date) {
    return DrinkingNote.getNoteForDate(date, notes);
  }

  void selectDate(DateTime theDate) {
    selectedDate = theDate;
    emit(
      StatisticsForDate(
        onCancel: (DateTime month) {
          selectMonth(month);
        },
        selectedDate: theDate,
        drinkingNote: DrinkingNote.getNoteForDate(theDate, notes),
        consumptionPeriod: ConsumptionPeriod(
          consumptions: ConsumptionPeriod(
            consumptions: consumptions,
          ).consumptionsForDate(date: theDate, sortOrder: SortOrder.descending),
        ),
      ),
    );
  }

  void init() {
    startSubscriptions();
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
