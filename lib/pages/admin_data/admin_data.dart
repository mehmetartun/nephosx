import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/admin_data_cubit.dart';
import 'views/admin_data_country_view.dart';
import 'views/admin_data_view.dart';

class AdminDataPage extends StatelessWidget {
  const AdminDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AdminDataCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<AdminDataCubit, AdminDataState>(
        builder: (context, state) {
          switch (state) {
            case AdminDataAllowedCountriesEdit _:
              return AdminDataCountryView(
                selectedCountries: state.countries,
                updateCountries: cubit.updateAllowedCountries,
                title: "Allowed Countries",
                onCancel: () {
                  cubit.mainScreen();
                },
              );
            case AdminDataFavoriteCountriesEdit _:
              return AdminDataCountryView(
                selectedCountries: state.countries,
                updateCountries: cubit.updateFavoriteCountries,
                title: "Favorite Countries",
                onCancel: () {
                  cubit.mainScreen();
                },
              );
            case AdminDataSettingsLoaded _:
              return AdminDataView(
                platformSettings: state.platformSettings,
                updateAllowedCountries: cubit.allowedCountryUpdateRequest,
                updateFavoriteCountries: cubit.favoriteCountryUpdateRequest,
              );
            case AdminDataInitial _:
              return LoadingView(title: "Loading");
          }
        },
      ),
    );
  }
}
