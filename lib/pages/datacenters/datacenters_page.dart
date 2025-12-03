import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../model/user.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/error_view.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/datacenters_cubit.dart';
import 'views/datacenter_add_edit_view.dart';
import 'views/datacenters_gpu_clusters_view.dart';
import 'views/datacenters_view.dart';

class DatacentersPage extends StatelessWidget {
  const DatacentersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = BlocProvider.of<AuthenticationBloc>(context).user;

    final DatacentersCubit cubit = DatacentersCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
    )..init(user: user);

    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<DatacentersCubit, DatacentersState>(
        builder: (context, state) {
          switch (state) {
            case DatacenterAddEdit _:
              return DatacenterAddEditView(
                companyId: state.companyId,
                addDatacenter: cubit.addDatacenter,
                updateDatacenter: cubit.updateDatacenter,
                backToDatacenters: cubit.backToDatacenters,
                datacenter: state.datacenter,
              );
            case DatacentersGpuClusters _:
              return DatacentersGpuClustersView(
                gpuClusters: state.gpuClusters,
                addGpuCluster: cubit.addGpuCluster,
                updateGpuCluster: cubit.updateGpuCluster,
                datacenter: state.datacenter,
                backToDatacenters: cubit.backToDatacenters,
                addTransaction: cubit.addTransaction,
                buyers: state.companies,
                validator: cubit.transactionValidator,
              );
            case DatacentersErrorState _:
              return ErrorView(
                title: "Datacenters Error",
                message: state.message,
              );
            case DatacentersInitial _:
              return LoadingView(title: "Loading datacenters");
            case DatacentersLoaded _:
              return DatacentersView(
                updateDatacenter: cubit.updateDatacenter,
                datacenters: state.datacenters,
                addDatacenterRequest: cubit.addDatacenterRequest,
                editDatacenterRequest: cubit.editDatacenterRequest,
                getGpuClusters: cubit.getGpuClusters,
                companyId: state.companyId,
              );
          }
        },
      ),
    );
  }
}
