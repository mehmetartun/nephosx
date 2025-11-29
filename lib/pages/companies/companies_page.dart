import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/companies_cubit.dart';
import 'views/companies_view.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompaniesCubit cubit = CompaniesCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init();

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<CompaniesCubit, CompaniesState>(
        builder: (context, state) {
          switch (state) {
            case CompaniesInitial _:
              return LoadingView(title: "Loading companies");
            case CompaniesLoaded _:
              return CompaniesView(
                companies: state.companies,
                addCompany: cubit.addCompany,
              );
          }
        },
      ),
    );
  }
}
