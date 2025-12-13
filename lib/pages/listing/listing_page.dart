import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/blocs/authentication/authentication_bloc.dart';
import 'package:nephosx/repositories/database/database.dart';

import '../../model/user.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/listing_cubit.dart';
import 'views/add_edit_listing_view.dart';
import 'views/listing_error_view.dart';
import 'views/listing_view.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = BlocProvider.of<AuthenticationBloc>(context).user;
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    ListingCubit cubit = ListingCubit(user, databaseRepository)..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<ListingCubit, ListingState>(
        builder: (context, state) {
          switch (state) {
            case ListingError _:
              return ListingErrorView(
                message: state.error,
                onCancel: () {
                  cubit.onCancel();
                },
              );
            case ListingInitial _:
              return LoadingView(title: "Loading");
            case ListingAddEdit _:
              return ListingAddEditView(
                listing: state.listing,
                gpuCluster: state.gpuCluster,
                slot: state.slot,
                addListing: cubit.addListing,
                updateListing: cubit.updateListing,
                onCancel: () {
                  cubit.onCancel();
                },
              );
            case ListingLoaded _:
              return ListingView(
                listings: state.listings,
                gpuClusters: state.gpuClusters,
                transactions: state.transactions,

                onCancel: () {
                  cubit.onCancel();
                },
                requestAddListing: cubit.requestAddListing,
              );
          }
        },
      ),
    );
  }
}
