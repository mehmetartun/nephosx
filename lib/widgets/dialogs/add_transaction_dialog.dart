import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/company.dart';
import '../../model/consideration.dart';
import '../../model/datacenter.dart';
import '../../model/gpu_cluster.dart';
import '../../model/gpu_transaction.dart';
import '../formfields/consideration_form_field.dart';
import '../occupation_view_paint.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({
    Key? key,
    required this.onAddTransaction,
    required this.gpuCluster,
    required this.buyers,
    required this.datacenter,
    required this.validator,
  }) : super(key: key);
  final void Function(GpuTransaction) onAddTransaction;
  final Datacenter datacenter;
  final GpuCluster gpuCluster;
  final List<Company> buyers;
  final String? Function(GpuCluster, DateTime, DateTime) validator;

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Consideration? consideration;
  DateTime? startDate;
  DateTime? endDate;
  Company? buyer;
  String? overlapErrorText;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MaxWidthBox(
        maxWidth: 600,
        child: Dialog(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction Entry",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.datacenter.name}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "${widget.datacenter.address.country.description}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "${widget.gpuCluster.type.name} ${widget.gpuCluster.quantity}x",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Current Availability",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                OccupationView(
                  transactions: widget.gpuCluster.transactions ?? [],
                  fromDate: DateTime.now(),
                  toDate: DateTime.now().add(Duration(days: 3 * 365)),
                ),
                if (overlapErrorText != null) ...[
                  SizedBox(height: 10),
                  Text(
                    "Proposed Transaction",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  OccupationView(
                    transactions: [
                      GpuTransaction(
                        id: '',
                        gpuClusterId: widget.gpuCluster.id,
                        startDate: startDate!,
                        endDate: endDate!,
                        consideration: consideration!,
                        buyerCompanyId: buyer!.id,
                        sellerCompanyId: widget.gpuCluster.companyId,
                        createdAt: DateTime.now(),
                        datacenterId: widget.datacenter.id,
                      ),
                    ],
                    fromDate: DateTime.now(),
                    toDate: DateTime.now().add(Duration(days: 3 * 365)),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      overlapErrorText!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
                Divider(height: 20),
                Text("Select a buyer"),
                SizedBox(height: 10),
                DropdownButtonFormField<Company>(
                  items: widget.buyers
                      .where((buyer) {
                        return buyer.id != widget.gpuCluster.companyId;
                      })
                      .map((buyer) {
                        return DropdownMenuItem(
                          value: buyer,
                          child: Text(buyer.name),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    buyer = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a buyer";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text("Enter a date between now and 10 years from now"),
                SizedBox(height: 10),
                InputDatePickerFormField(
                  fieldLabelText: "Start Date",
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 3650)),
                  initialDate: DateTime(2026, 1, 1),
                  onDateSaved: (value) {
                    startDate = value;
                  },
                ),
                SizedBox(height: 10),
                InputDatePickerFormField(
                  fieldLabelText: "End Date",
                  initialDate: DateTime(2026, 2, 1),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 3650)),
                  onDateSaved: (value) {
                    endDate = value;
                  },
                ),
                SizedBox(height: 10),
                ConsiderationFormField(
                  validator: (value) {
                    print(value?.currency.title);
                    print(value?.amount);
                    if (value == null) {
                      return "Please enter a consideration";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    consideration = value;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() ?? false) {
                        formKey.currentState!.save();
                        String? res = widget.validator(
                          widget.gpuCluster,
                          startDate!,
                          endDate!,
                        );
                        if (res != null) {
                          setState(() {
                            overlapErrorText = res;
                          });
                          return;
                        }
                        widget.onAddTransaction(
                          GpuTransaction(
                            id: '',
                            gpuClusterId: widget.gpuCluster.id,
                            startDate: startDate!,
                            endDate: endDate!,
                            consideration: consideration!,
                            buyerCompanyId: buyer!.id,
                            sellerCompanyId: widget.gpuCluster.companyId,
                            createdAt: DateTime.now(),
                            datacenterId: widget.datacenter.id,
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: Text("Add Transaction"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
