import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/data/data_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/transactions_cubit.dart';
import 'views/transactions_view.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBloc dataBloc = BlocProvider.of<DataBloc>(context);
    final cubit = TransactionsCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      BlocProvider.of<AuthenticationBloc>(context).user,
    );
    if (dataBloc.state is DataLoaded) {
      cubit.dataRefresh(
        (dataBloc.state as DataLoaded).transactions,
        (dataBloc.state as DataLoaded).gpuClusters,
        (dataBloc.state as DataLoaded).companies,
      );
    }
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) {
        if (state is DataLoaded) {
          cubit.dataRefresh(
            state.transactions,
            state.gpuClusters,
            state.companies,
          );
        }
      },
      child: BlocProvider(
        create: (context) => cubit,
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            switch (state) {
              case TransactionsInitial _:
                return LoadingView(title: "Transactions");
              case TransactionErrorState _:
                return ErrorView(title: "Error", message: state.message);
              case TransactionsLoaded _:
                return TransactionsView(
                  transactions: state.transactions,
                  onExport: cubit.onExport,
                );
            }
          },
        ),
      ),
    );
  }
}
