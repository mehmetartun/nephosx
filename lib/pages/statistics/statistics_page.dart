import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/authentication/authentication_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/statistics_cubit.dart';
import 'views/statistics_day_view.dart';
import 'views/statistics_full_view.dart';
import 'views/statistics_month_view.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    StatisticsCubit statisticsCubit = StatisticsCubit(
      user: BlocProvider.of<AuthenticationBloc>(context).user!,
      databaseRepository: RepositoryProvider.of<DatabaseRepository>(context),
    )..init();
    return BlocProvider(
      create: (context) => statisticsCubit,
      child: BlocConsumer<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state is StatisticsRecent) {
            if (state.data.length == 0) {
              context.pushNamed("splash");
            }
          }
        },
        builder: (context, state) {
          switch (state) {
            case StatisticsFull _:
              return StatisticsFullView(
                consumptionPeriod: state.consumptionPeriod,
                onTapMonth: statisticsCubit.selectMonth,
                onTapDate: statisticsCubit.selectDate,
                getDrinkingNote: statisticsCubit.getDrinkingNote,
              );
            case StatisticsForMonth _:
              return StatisticsMonthView(
                consumptionPeriod: state.consumptionPeriod,
                selectedMonth: state.selectedMonth,
                onCancel: statisticsCubit.selectAll,
                onTapDate: statisticsCubit.selectDate,
                getDrinkingNote: statisticsCubit.getDrinkingNote,
              );
            case StatisticsError _:
              return ErrorView(title: state.message);
            case StatisticsForDate _:
              return StatisticsDayView(
                date: state.selectedDate,
                drinkingNote: state.drinkingNote,
                consumptionPeriod: state.consumptionPeriod,
                onCancel: statisticsCubit.selectMonth,
                onDelete: statisticsCubit.deleteConsumption,
                onSizeChange: statisticsCubit.changeConsumptionSize,
                onSavedNote: statisticsCubit.addNote,
                onUpdatedNote: statisticsCubit.updateNote,
              );
            case StatisticsLoading _:
              return LoadingView(title: "Loading...");
            default:
              return LoadingView(title: "Loading....");
          }
        },
      ),
    );
  }
}
