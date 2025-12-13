import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:nephosx/pages/market/cubit/market_cubit.dart';

import '../model/company.dart';
import '../model/datacenter.dart';
import '../model/gpu_transaction.dart';
import 'dialogs/add_transaction_dialog.dart';
import 'dialogs/edit_gpu_cluster_dialog.dart';

import 'occupation_view_paint.dart';
import 'tier_widget.dart';

class GpuClusterListTile extends StatelessWidget {
  const GpuClusterListTile({
    super.key,
    required this.gpuCluster,
    required this.onUpdateGpuCluster,
    required this.buyers,
    required this.addTransaction,
    required this.datacenter,
    required this.validator,
  });
  final GpuCluster gpuCluster;
  final void Function(GpuCluster) onUpdateGpuCluster;
  final List<Company> buyers;
  final void Function(GpuTransaction) addTransaction;
  final Datacenter datacenter;
  final String? Function(GpuCluster, DateTime, DateTime) validator;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddTransactionDialog(
                    gpuCluster: gpuCluster,
                    onAddTransaction: addTransaction,
                    buyers: buyers,
                    validator: validator,
                    priceCalculator: (gpuCluster, fromDate, toDate) {
                      return BlocProvider.of<MarketCubit>(
                        context,
                      ).priceCalculator(gpuCluster, fromDate, toDate);
                    },
                    datacenter: datacenter,
                  );
                },
              );
            },
            leading: Icon(Icons.computer),
            title: Text(gpuCluster.device?.name ?? "ERROR"),
            subtitle: Text("${gpuCluster.quantity}x"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return EditGpuClusterDialog(
                      gpuCluster: gpuCluster,
                      onUpdateGpuCluster: onUpdateGpuCluster,
                    );
                  },
                );
              },
            ),
          ),
          OccupationView(
            occupiedSlots: gpuCluster.occupiedSlots,
            listedSlots: gpuCluster.listedSlots,
            unListedSlots: gpuCluster.unListedSlots,
            fromDate: gpuCluster.startDate,
            toDate: gpuCluster.endDate,
          ),
        ],
      ),
    );
  }
}
