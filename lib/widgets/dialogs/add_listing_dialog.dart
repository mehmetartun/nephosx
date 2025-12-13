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

class AddListingDialog extends StatefulWidget {
  const AddListingDialog({
    Key? key,
    required this.onAddListing,
    required this.gpuCluster,
    required this.datacenter,
    required this.validator,
    required this.priceCalculator,
  }) : super(key: key);
  final void Function(GpuCluster) onAddListing;
  final Datacenter datacenter;
  final GpuCluster gpuCluster;
  final String? Function(GpuCluster, DateTime, DateTime) validator;
  final double Function(GpuCluster, DateTime, DateTime) priceCalculator;

  @override
  State<AddListingDialog> createState() => _AddListingDialogState();
}

class _AddListingDialogState extends State<AddListingDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late DateTime startDate;
  late DateTime endDate;
  // Company? buyer;
  String? overlapErrorText;
  late DateTime maxDate;
  late DateTime minDate;

  late Consideration consideration;
  @override
  void initState() {
    super.initState();
    // if (widget.buyers.length == 1) {
    //   buyer = widget.buyers.first;
    // }
    minDate = DateTime.now();
    maxDate = DateTime(minDate.year + 3, 12, 31);
    startDate = widget.gpuCluster.startDate!;
    endDate = widget.gpuCluster.endDate!;
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
                  occupiedSlots: widget.gpuCluster.occupiedSlots,
                  listedSlots: widget.gpuCluster.listedSlots,
                  unListedSlots: widget.gpuCluster.unListedSlots,
                  fromDate: widget.gpuCluster.startDate,
                  toDate: widget.gpuCluster.endDate,
                ),
                // if (overlapErrorText != null) ...[
                //   SizedBox(height: 10),
                //   LightLabel(text: "Proposed Transaction"),
                //   OccupationView(
                //     transactions: [
                //       GpuTransaction(
                //         id: '',
                //         gpuClusterId: widget.gpuCluster.id,
                //         startDate: startDate!,
                //         endDate: endDate!,
                //         consideration: consideration!,
                //         buyerCompanyId: widget.user!.companyId,
                //         sellerCompanyId: widget.gpuCluster.companyId,
                //         createdAt: DateTime.now(),
                //         datacenterId: widget.datacenter.id,
                //       ),
                //     ],
                //     fromDate: DateTime.now(),
                //     toDate: DateTime.now().add(Duration(days: 3 * 365)),
                //   ),
                //   Container(
                //     width: double.infinity,
                //     margin: const EdgeInsets.only(top: 10),
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.errorContainer,
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     child: Text(
                //       overlapErrorText!,
                //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         color: Theme.of(context).colorScheme.error,
                //       ),
                //     ),
                //   ),
                // ],
                Divider(height: 20),

                Text("Price"),
                SizedBox(height: 10),
                Text(consideration.formatted),
                Text("Enter dates"),
                SizedBox(height: 10),
                DateTimeFormField(
                  firstDate: minDate,
                  lastDate: maxDate,
                  initialValue: widget.gpuCluster.startDate,
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

                SizedBox(height: 10),
                DateTimeFormField(
                  firstDate: widget.gpuCluster.startDate,
                  lastDate: widget.gpuCluster.endDate!.add(Duration(days: 730)),
                  initialValue: widget.gpuCluster.startDate!.add(
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
                SizedBox(height: 10),
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
                        // widget.onAddTransaction(
                        //   GpuTransaction(
                        //     id: '',
                        //     gpuClusterId: widget.gpuCluster.id,
                        //     startDate: startDate!,
                        //     endDate: endDate!,
                        //     consideration: consideration!,
                        //     buyerCompanyId: ,
                        //     sellerCompanyId: widget.gpuCluster.companyId,
                        //     createdAt: DateTime.now(),
                        //     datacenterId: widget.datacenter.id,
                        //   ),
                        // );

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
