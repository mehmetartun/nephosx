import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/enums.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/company.dart';
import '../../model/consideration.dart';
import '../../model/datacenter.dart';
import '../../model/gpu_cluster.dart';
import '../../model/gpu_transaction.dart';
import '../../model/light_label.dart';
import '../formfields/consideration_form_field.dart';
import '../formfields/date_formfield.dart';
import '../occupation_view_paint.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({
    Key? key,
    required this.onAddTransaction,
    required this.gpuCluster,
    required this.buyers,
    required this.datacenter,
    required this.validator,
    required this.priceCalculator,
  }) : super(key: key);
  final void Function(GpuTransaction) onAddTransaction;
  final Datacenter datacenter;
  final GpuCluster gpuCluster;
  final List<Company> buyers;
  final String? Function(GpuCluster, DateTime, DateTime) validator;
  final double Function(GpuCluster, DateTime, DateTime) priceCalculator;

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late DateTime startDate;
  late DateTime endDate;
  Company? buyer;
  String? overlapErrorText;
  late DateTime maxDate;
  late DateTime minDate;

  late Consideration consideration;
  @override
  void initState() {
    super.initState();
    if (widget.buyers.length == 1) {
      buyer = widget.buyers.first;
    }
    minDate = DateTime.now();
    maxDate = DateTime(minDate.year + 3, 12, 31);
    startDate = widget.gpuCluster.availabilityDate!;
    endDate = widget.gpuCluster.availabilityDate!.add(Duration(days: 30));
    consideration = Consideration(
      amount: widget.priceCalculator(widget.gpuCluster, startDate, endDate),
      currency: Currency.usd,
    );
  }

  void adjustPricing() {
    setState(() {
      consideration = Consideration(
        amount: widget.priceCalculator(widget.gpuCluster, startDate, endDate),
        currency: Currency.usd,
      );
    });
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.datacenter.name}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "${widget.datacenter.address.country.flagUnicode} ${widget.datacenter.address.country.description}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "${widget.gpuCluster.device?.name ?? 'ERROR'} ${widget.gpuCluster.quantity}x",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i in widget.gpuCluster.rentalPrices)
                          Text(
                            "${i.numberOfMonths} months: \$${i.priceInUsdPerHour}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                      ],
                    ),
                  ],
                ),
                LightLabel(text: "Current Availability"),
                OccupationView(
                  transactions: widget.gpuCluster.transactions ?? [],
                  fromDate: DateTime.now(),
                  toDate: DateTime.now().add(Duration(days: 3 * 365)),
                ),
                if (overlapErrorText != null) ...[
                  SizedBox(height: 10),
                  LightLabel(text: "Proposed Transaction"),
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
                if (widget.buyers.length > 1) ...[
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
                ],
                Text("Price"),
                SizedBox(height: 10),
                Text(consideration.formatted),
                Text("Enter dates"),
                SizedBox(height: 10),
                DateTimeFormField(
                  firstDate: minDate,
                  lastDate: maxDate,
                  initialValue: widget.gpuCluster.availabilityDate,
                  readOnly: true,
                  onChanged: (val) {
                    endDate = val;
                    adjustPricing();
                  },
                  onSaved: (value) {
                    startDate = value!;
                  },
                  labelText: 'Start Date',
                ),
                // TextFormField(
                //   readOnly: true,
                //   decoration: InputDecoration(labelText: "Start Date"),
                //   initialValue: DateFormat(
                //     'dd MMM yyyy',
                //   ).format(widget.gpuCluster.availabilityDate!),
                // ),
                // InputDatePickerFormField(
                //   fieldLabelText: "Start Date",
                //   firstDate: minDate,
                //   lastDate: maxDate,
                //   initialDate: minDate.add(Duration(days: 200)),
                //   onDateSaved: (value) {
                //     startDate = value;
                //   },
                //   onDateSubmitted: (value) {
                //     startDate = value;
                //   },
                // ),
                SizedBox(height: 10),
                DateTimeFormField(
                  firstDate: widget.gpuCluster.availabilityDate,
                  lastDate: widget.gpuCluster.availabilityDate!.add(
                    Duration(days: 730),
                  ),
                  initialValue: widget.gpuCluster.availabilityDate!.add(
                    Duration(days: 30),
                  ),
                  // readOnly: true,
                  onSaved: (value) {
                    endDate = value!;
                  },
                  onChanged: (value) {
                    endDate = value!;
                    adjustPricing();
                  },
                  labelText: 'End Date',
                ),
                // InputDatePickerFormField(
                //   fieldLabelText: "End Date",
                //   initialDate: minDate.add(Duration(days: 360)),
                //   firstDate: minDate,
                //   lastDate: maxDate,
                //   onDateSaved: (value) {
                //     endDate = value;
                //   },
                // ),
                SizedBox(height: 10),
                // ConsiderationFormField(
                //   validator: (value) {
                //     if (value == null) {
                //       return "Please enter a consideration";
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     consideration = value;
                //   },
                // ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState?.save();
                        double? price = widget.priceCalculator(
                          widget.gpuCluster,
                          startDate!,
                          endDate!,
                        );

                        consideration = Consideration(
                          amount: price,
                          currency: Currency.usd,
                        );
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

                        Navigator.of(context).pop();
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
