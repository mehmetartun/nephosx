import 'package:nephosx/repositories/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/consumption/consumption_bloc.dart';
import '../../model/drink.dart';
import '../../model/enums.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/consumption_entry_cubit.dart';
import 'views/consumption_entry_amount_view.dart';
import 'views/consumption_entry_view.dart';
import 'views/selection_view.dart';

class ConsumptionPage extends StatelessWidget {
  const ConsumptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ConsumptionBloc consumptionBloc = BlocProvider.of<ConsumptionBloc>(context);
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return BlocProvider(
      create: (context) => ConsumptionEntryCubit(
        databaseRepository,
        user: BlocProvider.of<AuthenticationBloc>(context).user,
      )..init(),
      child: BlocBuilder<ConsumptionEntryCubit, ConsumptionEntryState>(
        buildWhen: (previous, current) {
          if (previous is ConsumptionEntrySelect &&
              current is ConsumptionEntrySelect) {
            return false;
          }
          if (previous is ConsumptionEntryForDrinkType &&
              current is ConsumptionEntryForDrinkType) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          switch (state) {
            case ConsumptionEntrySelect _:
              return SelectionView(
                onDrinkTypeSelected: context
                    .read<ConsumptionEntryCubit>()
                    .onDrinkTypeSelected,
                onDrinkTypeConfirmed: context
                    .read<ConsumptionEntryCubit>()
                    .onDrinkTypeConfirmed,
              );
            case ConsumptionEntryForDrinkType _:
              return ConsumptionEntryView(
                drinkType: state.drinkType,
                drinks: state.drinks,
                onDrinkSelected: (Drink drink) {
                  context.read<ConsumptionEntryCubit>().onDrinkSelected(drink);
                },
                onDrinkConfirmed: (Drink drink) {
                  context.read<ConsumptionEntryCubit>().onDrinkConfirmed(drink);
                },
                onCancel: context.read<ConsumptionEntryCubit>().onCancel,
              );
            case ConsumptionEntryForDrink _:
              return ConsumptionEntryAmountView(
                drink: state.drink,
                onAmountSelected: context
                    .read<ConsumptionEntryCubit>()
                    .onAmountSelected,
                onCancel: context.read<ConsumptionEntryCubit>().onCancel,
              );
            case ConsumptionEntryInitial _:
            case ConsumptionEntryLoading _:
              return LoadingView(title: "Loading...");
          }
        },
      ),
    );
  }
}
