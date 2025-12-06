import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/market/views/market_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import 'cubit/market_cubit.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MarketCubit marketCubit = MarketCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      BlocProvider.of<AuthenticationBloc>(context).user,
    )..init();
    return BlocProvider(
      create: (context) => marketCubit,
      child: BlocBuilder<MarketCubit, MarketState>(
        builder: (context, state) {
          switch (state) {
            case MarketInitial():
              return const Center(child: CircularProgressIndicator());
            case MarketLoading():
              return const Center(child: CircularProgressIndicator());
            case MarketLoaded():
              return MarketView(
                gpuClusters: state.gpuClusters,
                ownCompanyId: state.ownCompanyId,
                priceCalculator: marketCubit.priceCalculator,
                validator: marketCubit.transactionValidator,
                onAddTransaction: marketCubit.addTransaction,
              );
            case MarketError():
              return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
