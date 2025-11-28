import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach/repositories/database/database.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../model/consumption.dart';
import '../../model/drink.dart';
import '../../model/user.dart';

part 'consumption_event.dart';
part 'consumption_state.dart';

class ConsumptionBloc extends Bloc<ConsumptionEvent, ConsumptionState> {
  ConsumptionBloc(this.databaseRepository) : super(ConsumptionInitial()) {
    on<ConsumptionEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ConsumptionEventAddDrink>((event, emit) async {
      await _handleAddDrink(event);
    });
    on<ConsumptionInitializationCompleteEvent>((event, emit) {
      _handleInitComplete(event, emit);
    });
  }

  StreamSubscription<List<Consumption>>? _subscription;
  late final StreamSubscription<List<Drink>> _drinksSubscription;
  final DatabaseRepository databaseRepository;
  List<Consumption> consumptions = [];
  List<Drink> drinks = [];

  void _handleInitComplete(ConsumptionInitializationCompleteEvent event, emit) {
    emit(ConsumptionBlocInitialized());
  }

  Future<void> _handleAddDrink(ConsumptionEventAddDrink event) async {
    databaseRepository.addDocument(
      collectionPath: "users/${event.user.uid}/consumption",
      data: {
        'drinkId': event.drink.id,
        'drink': event.drink.toJson(),
        'drinkName': event.drink.name,
        'drinkType': event.drink.drinkType.name,
        'uid': event.user.uid,
        'amountInMl': event.amountInMl,
        'consumptionDate': Timestamp.fromDate(event.consumptionDate),
      },
    );
  }

  Future<void> init() async {
    _drinksSubscription = databaseRepository.getDrinkStream().listen((qs) {
      drinks = qs;
      startConsumptionSubscription();
    });
  }

  void startConsumptionSubscription() {
    if (_subscription != null) {
      return;
    }
    // _subscription = FirebaseFirestore.instance
    //     .collection('/users/wXueF68uq8UWE6sECZTR8f969Ei2/diary')
    //     .snapshots()
    //     .listen((qs) {
    //       consumptions = [];
    //       for (var doc in qs.docs) {
    //         consumptions.add(
    //           // Consumption.fromJson({...doc.data(), 'id': doc.id}),
    //           Consumption.fromQueryDocmentSnapshot(doc),
    //         );
    //       }
    //       add(ConsumptionInitializationCompleteEvent());
    //     });
  }

  void updateConsumptions() {
    consumptions.forEach((cons) {
      Drink? dr = drinks.firstWhereOrNull((drink) => drink.id == cons.drinkId);
      if (dr != null) {
        cons.drink = dr;
      }
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _subscription?.cancel();
    _drinksSubscription.cancel();
    return super.close();
  }
}
