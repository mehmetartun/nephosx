import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/occupation_view_paint.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/datacenter.dart';
import '../../../model/device.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/listing.dart';
import '../../../model/rental_price.dart';
import '../../../model/slot.dart';
import '../../../services/platform_settings/platform_settings_service.dart';
import '../../../widgets/formfields/date_formfield.dart';
import '../../../widgets/formfields/rental_price.dart';

class ListingAddEditView extends StatefulWidget {
  final Listing? listing;
  final GpuCluster gpuCluster;
  final Slot? slot;
  final void Function({required Listing listing}) addListing;
  final void Function({required Listing listing}) updateListing;
  final void Function() onCancel;
  const ListingAddEditView({
    this.slot,
    required this.gpuCluster,
    super.key,
    this.listing,
    required this.addListing,
    required this.updateListing,
    required this.onCancel,
  });

  @override
  State<ListingAddEditView> createState() => _ListingAddEditViewState();
}

class _ListingAddEditViewState extends State<ListingAddEditView> {
  // GpuType? type;
  final formKey = GlobalKey<FormState>();
  late List<RentalPrice> rentalPrices;

  @override
  void initState() {
    super.initState();
    // type = widget.gpuCluster?.type
    //
    rentalPrices =
        widget.listing?.rentalPrices ??
        [
          RentalPrice(numberOfMonths: 1, priceInUsdPerHour: 100),
          RentalPrice(numberOfMonths: 3, priceInUsdPerHour: 200),
          RentalPrice(numberOfMonths: 6, priceInUsdPerHour: 300),
          RentalPrice(numberOfMonths: 12, priceInUsdPerHour: 400),
        ];
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.slot == null && widget.listing == null)) {
      return Scaffold(body: Center(child: Text("No data")));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          alignment: Alignment.topCenter,
          maxWidth: 900,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.listing == null ? "Add Listing" : "Edit Listing",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    FilledButton.tonalIcon(
                      icon: Icon(Icons.close),
                      label: Text("Cancel"),
                      onPressed: widget.onCancel,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.gpuCluster.device?.name ?? "ERROR"),
                      SizedBox(height: 20),
                      if (widget.slot != null)
                        Text(
                          "${DateFormat("yyyy-MM-dd").format(widget.slot!.from)} - ${DateFormat("yyyy-MM-dd").format(widget.slot!.to)}",
                        ),
                      OccupationView(
                        fromDate: widget.gpuCluster.startDate,
                        toDate: widget.gpuCluster.endDate,
                        occupiedSlots: widget.gpuCluster.occupiedSlots,
                        listedSlots: widget.gpuCluster.listedSlots,
                        unListedSlots: widget.slot == null
                            ? []
                            : [widget.slot!],
                      ),
                      Divider(height: 40),
                      Text(
                        "Rental Prices",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 20),

                      for (int i = 0; i < rentalPrices.length; i++)
                        RentalPriceFormField(
                          validator: (value) {
                            if (value != null) {
                              return null;
                            }
                            return "Please enter a rental price";
                          },
                          onSaved: (newValue) {
                            rentalPrices[i] = newValue!;
                          },
                          initialValue: rentalPrices[i],
                        ),
                      for (int i = rentalPrices.length; i < 4; i++)
                        RentalPriceFormField(
                          validator: (value) {
                            if (value != null) {
                              return null;
                            }
                            return "Please enter a rental price";
                          },
                          onSaved: (newValue) {
                            rentalPrices.add(newValue!);
                          },
                        ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              formKey.currentState!.save();

                              rentalPrices.sort(
                                (a, b) => a.numberOfMonths.compareTo(
                                  b.numberOfMonths,
                                ),
                              );

                              if (widget.listing == null) {
                                widget.addListing(
                                  listing: Listing(
                                    id: "123",
                                    startDate: widget.slot!.from,
                                    endDate: widget.slot!.to,
                                    createdAt: DateTime.now(),
                                    gpuClusterId: widget.gpuCluster!.id,
                                    status: ListingStatus.active,

                                    datacenterId:
                                        widget.gpuCluster!.datacenterId,
                                    companyId: widget.gpuCluster!.companyId,
                                    rentalPrices: rentalPrices,
                                  ),
                                );
                              } else {
                                widget.updateListing(
                                  listing: widget.listing!.copyWith(
                                    rentalPrices: rentalPrices,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("Save Listing"),
                        ),
                      ),
                    ],
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
