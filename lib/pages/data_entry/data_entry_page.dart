import 'package:nephosx/pages/data_entry/views/data_entry_main.dart';
import 'package:nephosx/pages/data_entry/views/drink_edit_view.dart';
import 'package:nephosx/pages/data_entry/views/drinks_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/data_entry_cubit.dart';
import 'views/data_list_view.dart';
import 'views/drink_view.dart';
import 'views/drink_view2.dart';

class DataEntryPage extends StatelessWidget {
  DataEntryPage({super.key, this.itemId});
  final String? itemId;

  @override
  Widget build(BuildContext context) {
    DataEntryCubit dataEntryCubit = DataEntryCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init(itemId: itemId);
    return BlocProvider(
      create: (context) => dataEntryCubit,
      child: BlocBuilder<DataEntryCubit, DataEntryState>(
        builder: (context, state) {
          switch (state) {
            case DataEntryItem _:
              return DrinkEditView(
                drinkImage: dataEntryCubit.drinkImage!,
                onSave: dataEntryCubit.saveDrink,
                onCancel: dataEntryCubit.cancelDrinkEntry,
              );
            case DataEntryLoaded _:
              return DataListView(
                selectItem: dataEntryCubit.selectItem,
                refresh: dataEntryCubit.refresh,
                drinksList: dataEntryCubit.listItems,
                images: dataEntryCubit.images,
              );
            case DrinksLoaded _:
              return DrinksListView(
                drinks: dataEntryCubit.drinks,
                refresh: dataEntryCubit.refresh,
                exportCSV: dataEntryCubit.exportDrinksToCsv,
                drinkSelected: dataEntryCubit.drinkSelected,
              );
            case DrinkLoaded _:
              return DrinkView(
                drink: state.drink,
                onUpdate: dataEntryCubit.updateDocument,
                goBack: dataEntryCubit.showMainView,
                runRecipe: dataEntryCubit.runRecipe,
                runDrink: dataEntryCubit.runDrink,
              );
            // return DrinkView2(drink: state.drink);
            case DrinksMain _:
              return DataEntryMain(
                addNewDrink: dataEntryCubit.init,
                listDrinks: dataEntryCubit.listItems,
                onSearch: dataEntryCubit.onSearch,
              );
            case DataEntryLoading _:
            case DataEntryInitial _:
              return LoadingView(
                title: 'Data Entry',
                message: 'Preparing data entry...',
              );
          }
        },
      ),
    );
  }
}
