import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nephosx/model/cocktail_recipe.dart';
import 'package:nephosx/model/search_result_item.dart';
import 'package:nephosx/repositories/database/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/drink.dart';
import '../../../model/drink_image.dart';
import '../../../services/csv/csv_service_io.dart';

part 'data_entry_state.dart';

class DataEntryCubit extends Cubit<DataEntryState> {
  DataEntryCubit(this.databaseRepository) : super(DataEntryInitial());

  final DatabaseRepository databaseRepository;
  List<DrinkImage> images = [];
  DrinkImage? drinkImage;
  List<Drink> drinks = [];
  Drink? drink;

  HttpsCallable getRecipeNew = FirebaseFunctions.instance.httpsCallable(
    'getRecipeNew',
  );

  HttpsCallable hello = FirebaseFunctions.instance.httpsCallable('hello');

  Map<String, dynamic> drinkSchema = {
    'type': 'OBJECT',
    'properties': {
      'name': {'type': 'STRING'},
      'description': {'type': 'STRING'},
      'serving_size_in_mL': {'type': 'NUMBER'},
      'calories_per_serving_in_kCal': {'type': 'NUMBER'},
      'history': {'type': 'STRING'},
      'alcohol_by_volume_%': {'type': 'NUMBER'},
      'serving_format': {'type': 'STRING'},
      'total_carbohydrates_in_g': {'type': 'NUMBER'},
      'total_protein_in_g': {'type': 'NUMBER'},
      'total_fat_in_g': {'type': 'NUMBER'},
      'ingredients_used_in_production': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'name': {'type': 'STRING'},
            'description': {'type': 'STRING'},
          },
        },
      },
    },
    'required': [
      'name',
      'description',
      'serving_size_in_mL',
      'calories_per_serving_in_kCal',
      'history',
      'alcohol_by_volume_%',
      'serving_format',
      'total_carbohydrates_in_g',
      'total_protein_in_g',
      'total_fat_in_g',
      'ingredients_used_in_production',
    ],
  };

  Map<String, dynamic> schema = {
    'type': 'OBJECT',
    'properties': {
      'cocktail_name': {'type': 'STRING'},
      'description': {'type': 'STRING'},
      'total_calories_in_kCal': {'type': 'NUMBER'},
      'total_volume_in_mL': {'type': 'NUMBER'},
      'history': {'type': 'STRING'},
      'alcohol_by_volume_%': {'type': 'NUMBER'},
      'serving_format': {'type': 'STRING'},
      'total_carbohydrates_in_g': {'type': 'NUMBER'},
      'total_protein_in_g': {'type': 'NUMBER'},
      'total_fat_in_g': {'type': 'NUMBER'},
      'ingredients': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'name': {'type': 'STRING'},
            'quantity_in_mL': {'type': 'NUMBER'},
            'carbohydrates_in_g': {'type': 'NUMBER'},
            'protein_in_g': {'type': 'NUMBER'},
            'fat_in_g': {'type': 'NUMBER'},
            'calories_in_kCal': {'type': 'NUMBER'},
            'alcohol_by_volume_%': {'type': 'NUMBER'},
          },
        },
      },
      'instructions': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'step': {'type': 'NUMBER'},
            'description': {'type': 'STRING'},
          },
        },
      },
    },
    'required': [
      'cocktail_name',
      'ingredients',
      'instructions',
      'description',
      'total_calories_in_kCal',
      'total_volume_in_mL',
      'history',
    ],
  };

  Map<String, dynamic> _castMap(Map<Object?, Object?> map) {
    return map.map((key, value) {
      if (value is Map<Object?, Object?>) {
        return MapEntry(key as String, _castMap(value));
      }
      if (value is List) {
        return MapEntry(
          key as String,
          value
              .map(
                (item) => item is Map<Object?, Object?> ? _castMap(item) : item,
              )
              .toList(),
        );
      }
      return MapEntry(key as String, value);
    });
  }

  Future<Map<String, dynamic>> runRecipe(String description) async {
    HttpsCallableResult res = await getRecipeNew.call({
      'schema': schema,
      'prompt': 'Get me the recipe of $description cocktail.',
      'languageModel': 'gemini-2.5-flash',
    });

    CocktailRecipe recipe = CocktailRecipe.fromJson(_castMap(res.data));

    await databaseRepository.updateDocument(
      docPath: 'drinks/${drink!.id}',
      data: {'recipe': recipe.toJson()},
    );
    return res.data;
  }

  Future<Map<String, dynamic>> runDrink(String name) async {
    HttpsCallableResult res = await getRecipeNew.call({
      'schema': drinkSchema,
      'prompt': 'Get me the information on $name.',
      'languageModel': 'gemini-2.5-flash',
    });

    await databaseRepository.updateDocument(
      docPath: 'drinks/${drink!.id}',
      data: {'info': _castMap(res.data)},
    );

    return res.data;
  }

  void init({String? itemId}) async {
    emit(DataEntryLoading());

    // emit(DrinksMain());
    // return;
    var db = FirebaseFirestore.instance;

    // var qss = await db.collection('drinks').get();
    // List<Future> futs = [];
    // for (var dr in qss.docs) {
    //   futs.add(
    //     dr.reference.update({
    //       // 'createdAt': Timestamp.fromDate(DateTime.now()),
    //       'lastUpdateAt': Timestamp.fromDate(DateTime.now()),
    //       'name': dr.data()['description'],
    //     }),
    //   );
    // }
    // await Future.wait(futs);

    if (itemId != null) {
      getItem(itemId);
      return;
    } else {
      // listItems();
    }
    // Simulate data fetching or processing

    // Drink.parseServingFormats(["glass", "bottle"]); // Example usage

    images = await databaseRepository.getDrinkImages();
    emit(DataEntryLoaded());
  }

  void refresh() {
    init();
  }

  void getItem(String itemId) async {
    emit(DataEntryLoading());

    drink = await databaseRepository.getDrink(itemId);

    if (drink != null) {
      emit(DrinkLoaded(drink!));
    } else {}
  }

  void cancelDrinkEntry() {
    drinkImage = null;
    emit(DataEntryLoaded());
  }

  void drinkSelected(Drink drink) {
    this.drink = drink;
    emit(DrinkLoaded(drink));
  }

  void deleteDrink(Drink drink) async {
    emit(DataEntryLoading());
    await databaseRepository.delete(path: 'drinks/${drink.id}');
    drinks.removeWhere((dr) => dr.id == drink.id);
    emit(DrinksLoaded());
  }

  //

  Future<List<SearchResultItem>> onSearch(String query) async {
    List<SearchResultItem> results = [];
    if (drinks.isEmpty) {
      drinks = await databaseRepository.getDrinks();
    }

    if (query.isEmpty || query.length < 3) {
      return results;
    } else {
      return drinks
          .where((drink) {
            return drink.name.toLowerCase().contains(query.toLowerCase());
          })
          .toList()
          .map((drink) {
            return SearchResultItem(
              title: drink.name,
              // subtitle: drink.servingFormatString,
              onTap: () {
                drinkSelected(drink);
              },
            );
          })
          .toList();
    }
  }

  void showMainView() {
    emit(DrinksMain());
  }

  Future<void> updateDocument<T>(T val, String fieldName) async {
    await databaseRepository.updateDocument(
      docPath: 'drinks/${drink!.id}',
      data: {fieldName: val},
    );
    drink = Drink.fromJson({...drink!.toJson(), fieldName: val});

    int i = drinks.indexWhere((e) => e.id == drink!.id);

    if (i >= 0) {
      drinks[i] = drink!;
    }
    emit(DrinkLoaded(drink!));
    return;
  }

  Future<void> listItems() async {
    emit(DataEntryLoading());

    drinks = await databaseRepository.getDrinks();
    drinks.sort((a, b) {
      if (a.drinkType.name.compareTo(b.drinkType.name) == 0) {
        return a.name.compareTo(b.name);
      } else {
        return a.drinkType.name.compareTo(b.drinkType.name);
      }
    });
    emit(DrinksLoaded());
  }

  void selectItem(DrinkImage drinkImage) {
    this.drinkImage = drinkImage;
    emit(DataEntryItem());
  }

  Future<void> saveDrink(Drink drink) async {
    // Save the drink to Firestore or any other storage
    await FirebaseFirestore.instance.collection("drinks").add(drink.toJson());
    await FirebaseFirestore.instance.doc('images/${drinkImage!.id}').update({
      'used': true,
    });
    // After saving, you might want to go back to the list view

    images.removeWhere((img) => img.id == drinkImage!.id);
    drinkImage = null;
    emit(DataEntryLoaded());
  }

  /// Exports the current list of drinks to a CSV file using the CsvService.
  Future<void> exportDrinksToCsv() async {
    final CsvService csvService = CsvService();
    await csvService.exportDrinks(drinks);
  }
}
