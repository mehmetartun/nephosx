import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/admin_cubit.dart';
import 'views/admin_view.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AdminCubit(RepositoryProvider.of<DatabaseRepository>(context))
      ..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          switch (state) {
            case AdminSettingsLoaded _:
              return AdminView(
                platformSettings: state.platformSettings,
                updateCountries: cubit.updateAllowedCountries,
              );
            case AdminInitial _:
              return LoadingView(title: "Loading");
          }
        },
      ),
    );
  }
}
