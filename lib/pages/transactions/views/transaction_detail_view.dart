import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/key_value_pair.dart';
import 'package:nephosx/widgets/gpu_property_list.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/gpu_transaction.dart';

class TransactionDetailView extends StatefulWidget {
  const TransactionDetailView({
    super.key,
    required this.transaction,
    required this.onCancel,
  });
  final GpuTransaction transaction;
  final Function() onCancel;

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextButton.icon(
                label: Text("Back"),
                icon: Icon(Icons.arrow_back),
                onPressed: widget.onCancel,
              ),
              Text(
                "Transaction Detail",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              GpuPropertyList(
                title: "Parties",
                properties: [
                  KeyValuePair(
                    key: "Buyer",
                    value: widget.transaction.buyerCompany?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "Seller",
                    value: widget.transaction.sellerCompany?.name ?? "",
                  ),
                ],
              ),
              GpuPropertyList(
                title: "Transaction",
                properties: [
                  KeyValuePair(
                    key: "Start Date",
                    value: DateFormat(
                      'yyyy-MM-dd',
                    ).format(widget.transaction.startDate),
                  ),
                  KeyValuePair(
                    key: "End Date",
                    value: DateFormat(
                      'yyyy-MM-dd',
                    ).format(widget.transaction.endDate),
                  ),
                  KeyValuePair(
                    key: "Consideration",
                    value: widget.transaction.consideration.formatted,
                  ),
                  KeyValuePair(
                    key: "Hourly Rate",
                    value: widget.transaction.hourlyRate.formatted,
                  ),
                ],
              ),
              GpuPropertyList(
                title: "GPU Cluster",
                properties: [
                  KeyValuePair(
                    key: "GPU Model",
                    value: widget.transaction.gpuCluster?.device?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "Quantity",
                    value:
                        widget.transaction.gpuCluster?.quantity.toString() ??
                        "",
                  ),
                  KeyValuePair(
                    key: "Serial Number",
                    value: widget.transaction.gpuCluster?.serialNumber ?? "",
                  ),
                  KeyValuePair(
                    key: "Asset Tag",
                    value: widget.transaction.gpuCluster?.assetTag ?? "",
                  ),

                  KeyValuePair(
                    key: "Datacenter",
                    value: widget.transaction.datacenter?.name ?? "",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
