import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/transactions_cubit.dart';
import 'views/transactions_view.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = TransactionsCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      BlocProvider.of<AuthenticationBloc>(context).user,
    )..init();
    return BlocProvider(
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
                companies: state.companies,
                gpuClusters: state.gpuClusters,
              );
          }
        },
      ),
    );
  }
}
