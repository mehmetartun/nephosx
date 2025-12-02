import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/companies/views/company_assign_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/companies_cubit.dart';
import 'views/companies_view.dart';
import 'views/edit_company_view.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompaniesCubit cubit = CompaniesCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      BlocProvider.of<AuthenticationBloc>(context).user,
    )..init();

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<CompaniesCubit, CompaniesState>(
        builder: (context, state) {
          switch (state) {
            case CompaniesError _:
              return ErrorView(
                title: "Companies Error",
                message: state.message,
              );
            case CompaniesInitial _:
              return LoadingView(title: "Loading companies");
            case CompaniesLoaded _:
              return CompaniesView(
                companies: state.companies,
                addCompany: cubit.addCompany,
              );

            case CompaniesEditCompany _:
              return EditCompanyView(
                company: state.company,
                onAddressAdd: cubit.addressAdd,
                onAddressUpdate: cubit.addressUpdate,
                onUpdateCompany: cubit.updateCompany,
                users: state.users,
                setPrimaryContact: cubit.setPrimaryContact,
              );
            case CompaniesAssign _:
              return CompanyAssignView(
                user: state.user,
                onRequestCompany: cubit.onRequestCompany,
                companies: state.companies,
              );
            default:
              return LoadingView(title: "Loading Companies...");
          }
        },
      ),
    );
  }
}
