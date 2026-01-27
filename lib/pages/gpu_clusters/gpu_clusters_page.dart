import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/pages/gpu_clusters/views/gpu_clusters_loading_view.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../repositories/database/database.dart';
import 'cubit/gpu_clusters_cubit.dart';
import 'views/gpu_cluster_add_edit_view.dart';
import 'views/gpu_cluster_detail_view.dart';
import 'views/gpu_cluster_view_table.dart';
import 'views/gpu_clusters_error_view.dart';

class GpuClustersPage extends StatelessWidget {
  const GpuClustersPage({Key? key, this.gpuClusterId}) : super(key: key);
  final String? gpuClusterId;

  @override
  Widget build(BuildContext context) {
    final GpuClustersCubit cubit = GpuClustersCubit(
      RepositoryProvider.of<DatabaseRepository>(context),
      user: BlocProvider.of<AuthenticationBloc>(context).user,
    )..init(gpuClusterId: gpuClusterId);
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<GpuClustersCubit, GpuClustersState>(
        builder: (context, state) {
          switch (state) {
            case GpuClustersInitial _:
            case GpuClustersLoading _:
              return GpuClustersLoadingView();
            case GpuClustersError _:
              return GpuClustersErrorView(
                title: "GPU Clusters Error",
                message: state.message,
                onRetry: cubit.init,
              );
            case GpuClustersLoaded _:
              return GpuClustersViewTable(
                gpuClusters: state.gpuClusters,
                addGpuClusterRequest: cubit.addGpuClusterRequest,
                updateGpuClusterRequest: cubit.updateGpuClusterRequest,
                gpuClusterDetailRequest: cubit.gpuClusterDetailRequest,
                duplicateGpuClusterRequest: cubit.duplicateGpuClusterRequest,
              );
            case GpuClustersAddEdit _:
              return GpuClusterAddEditView(
                gpuCluster: state.gpuCluster,
                datacenters: state.datacenters,
                onAddGpuCluster: cubit.addGpuCluster,
                onUpdateGpuCluster: cubit.updateGpuCluster,
                onCancel: cubit.cancelAddGpuCluster,
                useAsTemplate: state.useAsTemplate ?? false,
              );
            case GpuClusterDetail _:
              return GpuClusterDetailView(
                gpuCluster: state.gpuCluster,
                onBack: cubit.showGpuClusters,
                user: BlocProvider.of<AuthenticationBloc>(context).user!,
              );
          }
        },
      ),
    );
  }
}
