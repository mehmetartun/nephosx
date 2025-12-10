import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/admin_onboarding/views/admin_onboarding_requests_view.dart';

import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/admin_onboarding_cubit.dart';
import 'views/admin_onboarding_error.dart';
import 'views/admin_onboarding_request_view.dart';

class AdminOnboardingPage extends StatelessWidget {
  const AdminOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AdminOnboardingCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<AdminOnboardingCubit, AdminOnboardingState>(
        builder: (context, state) {
          switch (state) {
            case AdminOnboardingRequestLoaded _:
              return AdminOnboardingRequestView(
                request: state.request,
                onAddCompany: cubit.onAddCompany,
                onRejectRequest: cubit.onRejectRequest,
                onCancel: cubit.onCancel,
                error: state.error,
              );
            case AdminOnboardingLoaded _:
              return AdminOnboardingRequestsView(
                requests: state.requests,
                onSelectRequest: cubit.viewRequest,
              );
            case AdminOnboardingError _:
              return AdminOnboardingErrorView(
                message: state.error,
                onCancel: cubit.onCancel,
              );
            default:
              return LoadingView(title: "Loading Requests");
          }
        },
      ),
    );
  }
}
