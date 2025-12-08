import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/gpu_cluster.dart';
import '../model/gpu_transaction.dart';

class TransactionTable extends StatelessWidget {
  const TransactionTable({
    Key? key,
    required this.transactions,
    required this.gpuClusters,
    required this.companies,
  }) : super(key: key);
  final List<GpuTransaction> transactions;
  final List<GpuCluster> gpuClusters;
  final List<Company> companies;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      horizontalMargin: 10,
      columnSpacing: 10,
      columns: [
        DataColumn(
          label: Text(
            'Transaction\nDate',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        DataColumn(
          label: Text(
            'GPU & Qty',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        DataColumn(
          label: Text('Buyer', style: Theme.of(context).textTheme.labelMedium),
        ),
        DataColumn(
          label: Text('Seller', style: Theme.of(context).textTheme.labelMedium),
        ),
        DataColumn(
          label: Text('Start', style: Theme.of(context).textTheme.labelMedium),
        ),
        DataColumn(
          label: Text('End', style: Theme.of(context).textTheme.labelMedium),
        ),
        DataColumn(
          label: Text('Amount', style: Theme.of(context).textTheme.labelMedium),
        ),
        DataColumn(
          label: Text(
            'Hourly Rate',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
      // rows: [],
      rows: transactions.map((tx) {
        return DataRow(
          cells: [
            DataCell(Text(DateFormat("dd MMM yy").format(tx.createdAt))),
            // DataCell(Text("Hello")),
            DataCell(
              Text(
                GpuCluster.getGpuClusterById(
                      gpuClusters,
                      tx.gpuClusterId,
                    )?.device?.name ??
                    'ERROR',
                // " ${GpuCluster.getGpuClusterById(gpuClusters, tx.gpuClusterId).quantity}x",
              ),
            ),
            DataCell(
              Text(Company.getCompanyFromId(companies, tx.buyerCompanyId).name),
            ),
            DataCell(
              Text(
                Company.getCompanyFromId(companies, tx.sellerCompanyId).name,
              ),
            ),
            DataCell(Text(DateFormat('dd MMM yy').format(tx.startDate))),
            DataCell(Text(DateFormat('dd MMM yy').format(tx.endDate))),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(tx.consideration.formatted),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  tx.consideration.hourlyRate(
                    startDate: tx.startDate,
                    endDate: tx.endDate,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
