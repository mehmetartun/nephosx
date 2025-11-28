import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach/repositories/database/database.dart';
import 'package:meta/meta.dart';

import '../../../model/consumption.dart';
import '../../../model/drink.dart';
import '../../../model/enums.dart';
import '../../../model/user.dart';

part 'consumption_entry_state.dart';

class ConsumptionEntryCubit extends Cubit<ConsumptionEntryState> {
  ConsumptionEntryCubit(this.databaseRepository, {this.user})
    : super(ConsumptionEntryInitial());
  late List<Drink> drinks;
  final DatabaseRepository databaseRepository;
  final User? user;

  void init() async {
    drinks = await databaseRepository.getDrinks();
    drinks.sort((a, b) {
      if (a.drinkType.name.compareTo(b.drinkType.name) == 0) {
        return a.name.compareTo(b.name);
      } else {
        return a.drinkType.name.compareTo(b.drinkType.name);
      }
    });
    emit(ConsumptionEntrySelect());
    // emit(
    //   ConsumptionEntryForDrinkType(
    //     drinkType: DrinkType.cocktail,
    //     drinks: drinks
    //         .where((drink) => drink.drinkType == DrinkType.cocktail)
    //         .toList(),
    //   ),
    // );
  }

  void onDrinkTypeSelected(DrinkType drinkType) {
    // emit(
    //   ConsumptionEntryForDrinkType(
    //     drinkType: drinkType,
    //     drinks: drinks.where((drink) => drink.drinkType == drinkType).toList(),
    //   ),
    // );
    emit(ConsumptionEntrySelect(drinkType: drinkType));
  }

  void onDrinkTypeConfirmed(DrinkType drinkType) {
    emit(
      ConsumptionEntryForDrinkType(
        drinkType: drinkType,
        drinks: drinks.where((drink) => drink.drinkType == drinkType).toList(),
      ),
    );
    // emit(ConsumptionEntrySelect(drinkType: drinkType));
  }

  Future<void> onAmountSelected(
    Drink drink,
    DrinkSize drinkSize,
    DateTime date,
  ) async {
    if (user != null) {
      emit(ConsumptionEntryLoading());
      var res = await databaseRepository.addDocument(
        collectionPath: 'users/${user!.uid}/diary',
        data: Consumption(
          id: "dummy",
          uid: user!.uid,
          drinkId: drink.id,
          drinkSize: drinkSize,
          amountInMl: drinkSize.volumeInML,
          consumptionDate: date,
          creationDate: DateTime.now(),
          updateDate: DateTime.now(),
        ).toJson(),
      );

      emit(ConsumptionEntrySelect());
    }
  }

  void onCancel() {
    emit(ConsumptionEntrySelect());
  }

  void onDrinkSelected(Drink dr) {
    // emit(ConsumptionEntryForDrink(drink: drink));
    emit(
      ConsumptionEntryForDrinkType(
        drinkType: dr.drinkType,
        drinks: drinks
            .where((drink) => drink.drinkType == drink.drinkType)
            .toList(),
        selectedDrink: dr,
      ),
    );
  }

  void onDrinkConfirmed(Drink drink) {
    emit(ConsumptionEntryForDrink(drink: drink));
  }
}
