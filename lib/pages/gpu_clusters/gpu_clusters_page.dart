import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/gpu_clusters/views/gpu_clusters_loading_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import '../../widgets/views/loading_view.dart';
import 'cubit/gpu_clusters_cubit.dart';
import 'views/gpu_cluster_add_edit_view.dart';
import 'views/gpu_clusters_view.dart';

class GpuClustersPage extends StatelessWidget {
  const GpuClustersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GpuClustersCubit cubit = GpuClustersCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      user: BlocProvider.of<AuthenticationBloc>(context).user,
    )..init();
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<GpuClustersCubit, GpuClustersState>(
        builder: (context, state) {
          switch (state) {
            case GpuClustersInitial _:
            case GpuClustersLoading _:
              return GpuClustersLoadingView();
            case GpuClustersLoaded _:
              return GpuClustersView(
                gpuClusters: state.gpuClusters,
                addGpuClusterRequest: cubit.addGpuClusterRequest,
                updateGpuClusterRequest: cubit.updateGpuClusterRequest,
              );
            case GpuClustersAddEdit _:
              return GpuClusterAddEditView(
                gpuCluster: state.gpuCluster,
                datacenters: state.datacenters,
                onAddGpuCluster: cubit.addGpuCluster,
                onUpdateGpuCluster: cubit.updateGpuCluster,
                onCancel: cubit.cancelAddGpuCluster,
              );
            default:
              return Container(child: null);
          }
        },
      ),
    );
  }
}
