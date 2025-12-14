import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/enums.dart';
import 'package:nephosx/model/slot.dart';
import 'package:nephosx/widgets/labeled_text.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/company.dart';
import '../../model/consideration.dart';
import '../../model/datacenter.dart';
import '../../model/gpu_cluster.dart';
import '../../model/gpu_transaction.dart';
import '../../model/light_label.dart';
import '../../model/listing.dart';
import '../../model/rental_price.dart';
import '../formfields/consideration_form_field.dart';
import '../formfields/date_formfield.dart';
import '../occupation_view_paint.dart';

class AddTransactionDialogNew extends StatefulWidget {
  const AddTransactionDialogNew({
    Key? key,
    required this.onAddTransaction,

    required this.buyer,
    required this.listing,
  }) : super(key: key);
  final void Function(GpuTransaction) onAddTransaction;
  final Company buyer;
  final Listing listing;

  @override
  State<AddTransactionDialogNew> createState() =>
      _AddTransactionDialogNewState();
}

class _AddTransactionDialogNewState extends State<AddTransactionDialogNew> {
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
    buyer = widget.buyer;
    minDate = widget.listing.startDate;
    maxDate = widget.listing.endDate;
    startDate = widget.listing.startDate;
    endDate = widget.listing.startDate.add(Duration(days: 30));
    if (endDate.isAfter(widget.listing.endDate)) {
      endDate = widget.listing.endDate;
    }
    consideration = Consideration(
      amount: RentalPrice.calculatePrice(
        widget.listing.rentalPrices,
        startDate,
        endDate,
      ),
      currency: Currency.usd,
    );
  }

  void adjustPricing() {
    setState(() {
      consideration = Consideration(
        amount: RentalPrice.calculatePrice(
          widget.listing.rentalPrices,
          startDate,
          endDate,
        ),
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
                Row(
                  children: [
                    Text(
                      "New Transaction",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.listing.datacenter?.name ?? 'X'}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "${widget.listing.datacenter?.address.country.flagUnicode} ${widget.listing.datacenter?.address.country.description}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "${widget.listing.gpuCluster?.device?.name ?? 'ERROR'} ${widget.listing.gpuCluster?.quantity}x",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i in widget.listing.rentalPrices)
                          Text(
                            i.priceInUsdPerHourFormattedWithMonths,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                      ],
                    ),
                  ],
                ),
                LightLabel(text: "Current Availability"),
                // OccupationView(
                //   occupiedSlots: widget.listing.occupiedSlots,
                //   listedSlots: widget.listing.listedSlots,
                //   unListedSlots: widget.listing.unListedSlots,
                //   fromDate: widget.listing.startDate,
                //   toDate: widget.listing.endDate,
                // ),
                // if (overlapErrorText != null) ...[
                //   SizedBox(height: 10),
                //   LightLabel(text: "Proposed Transaction"),
                //   OccupationView(
                //     occupiedSlots: [Slot(from: startDate!, to: endDate!)],
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
                LabeledText(value: consideration.formatted, label: "Price"),
                Text("Enter dates"),
                SizedBox(height: 10),
                DateTimeFormField(
                  firstDate: minDate,
                  lastDate: maxDate,
                  initialValue: widget.listing.startDate,
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
                  firstDate: widget.listing.startDate,
                  lastDate: widget.listing.endDate,
                  initialValue: widget.listing.startDate.add(
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
                        // double? price = widget.priceCalculator(
                        //   widget.gpuCluster,
                        //   startDate!,
                        //   endDate!,
                        // );

                        // consideration = Consideration(
                        //   amount: price,
                        //   currency: Currency.usd,
                        // );
                        // String? res = widget.validator(
                        //   widget.gpuCluster,
                        //   startDate!,
                        //   endDate!,
                        // );

                        // if (res != null) {
                        //   setState(() {
                        //     overlapErrorText = res;
                        //   });
                        //   return;
                        // }
                        widget.onAddTransaction(
                          GpuTransaction(
                            id: '',
                            counterpartyIds: [
                              buyer!.id,
                              widget.listing.companyId,
                            ],
                            gpuClusterId: widget.listing.id,
                            startDate: startDate,
                            endDate: endDate,
                            consideration: consideration,
                            buyerCompanyId: buyer!.id,
                            sellerCompanyId: widget.listing.companyId,
                            createdAt: DateTime.now(),
                            datacenterId: widget.listing.datacenterId,
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
