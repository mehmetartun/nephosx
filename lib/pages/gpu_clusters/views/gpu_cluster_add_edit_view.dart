import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/rental_price.dart';
import '../../../widgets/formfields/rental_price.dart';

class GpuClusterAddEditView extends StatefulWidget {
  final GpuCluster? gpuCluster;
  final List<Datacenter> datacenters;
  final void Function(GpuCluster) onAddGpuCluster;
  final void Function(GpuCluster) onUpdateGpuCluster;
  final void Function() onCancel;
  const GpuClusterAddEditView({
    super.key,
    this.gpuCluster,
    required this.datacenters,
    required this.onAddGpuCluster,
    required this.onUpdateGpuCluster,
    required this.onCancel,
  });

  @override
  State<GpuClusterAddEditView> createState() => _GpuClusterAddEditViewState();
}

class _GpuClusterAddEditViewState extends State<GpuClusterAddEditView> {
  GpuType? type;
  int? quantity;
  Datacenter? datacenter;
  late int numExistingRentalPrices;
  late int numToAddRentalPrices;
  late double perGpuVramInGb;
  late double teraFlops;
  final formKey = GlobalKey<FormState>();
  List<RentalPrice> rentalPricesSubmitted = [];
  @override
  void initState() {
    super.initState();
    type = widget.gpuCluster?.type;
    quantity = widget.gpuCluster?.quantity;
    datacenter = widget.gpuCluster?.datacenter;
    numExistingRentalPrices = widget.gpuCluster?.rentalPrices.length ?? 0;
    numToAddRentalPrices = 4 - numExistingRentalPrices;
    perGpuVramInGb = widget.gpuCluster?.perGpuVramInGb ?? 0;
    teraFlops = widget.gpuCluster?.teraFlops ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaxWidthBox(
        alignment: Alignment.topCenter,
        maxWidth: 500,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add GPU Cluster",
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
                  children: [
                    DropdownButtonFormField<GpuType>(
                      decoration: InputDecoration(labelText: "GPU Type"),
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                      initialValue: type,
                      validator: (value) {
                        if (value == null) {
                          return "Please select a GPU type";
                        }
                        return null;
                      },
                      items: GpuType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      autocorrect: false,
                      initialValue: quantity?.toString(),
                      decoration: InputDecoration(labelText: "Quantity"),
                      onSaved: (value) {
                        quantity = int.tryParse(value!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a quantity";
                        }
                        if (int.tryParse(value) == null) {
                          return "Please enter a valid quantity";
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<Datacenter>(
                      initialValue: datacenter,
                      onChanged: (value) {
                        setState(() {
                          datacenter = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a GPU type";
                        }
                        return null;
                      },
                      items: widget.datacenters.map((datacenter) {
                        return DropdownMenuItem(
                          value: datacenter,
                          child: Text(datacenter.name),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: perGpuVramInGb?.toString(),
                      decoration: InputDecoration(
                        labelText: "Per GPU VRAM (GB)",
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter a value";
                        }
                        if (double.tryParse(val) == null) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        perGpuVramInGb = double.tryParse(val!) ?? 0;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: teraFlops.toString(),
                      decoration: InputDecoration(labelText: "Teraflops"),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter a value";
                        }
                        if (double.tryParse(val) == null) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        teraFlops = double.tryParse(val!) ?? 0;
                      },
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Rental Prices",

                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    for (int i = 0; i < numExistingRentalPrices; i++)
                      RentalPriceFormField(
                        validator: (value) {
                          if (value != null) {
                            return null;
                          }
                          return "Please enter a rental price";
                        },
                        onSaved: (newValue) {
                          rentalPricesSubmitted.add(newValue!);
                        },
                        initialValue: widget.gpuCluster!.rentalPrices[i],
                      ),
                    for (int i = 0; i < numToAddRentalPrices; i++)
                      RentalPriceFormField(
                        validator: (value) {
                          if (value != null) {
                            return null;
                          }
                          return "Please enter a rental price";
                        },
                        onSaved: (newValue) {
                          rentalPricesSubmitted.add(newValue!);
                        },
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          formKey.currentState!.save();
                          rentalPricesSubmitted.sort(
                            (a, b) =>
                                a.numberOfMonths.compareTo(b.numberOfMonths),
                          );
                          widget.gpuCluster == null
                              ? widget.onAddGpuCluster(
                                  GpuCluster(
                                    type: type!,
                                    quantity: quantity!,
                                    datacenterId: datacenter!.id,
                                    companyId: datacenter!.companyId,
                                    id: widget.gpuCluster?.id ?? "",
                                    rentalPrices: rentalPricesSubmitted,
                                    teraFlops: teraFlops,
                                    perGpuVramInGb: perGpuVramInGb,
                                  ),
                                )
                              : widget.onUpdateGpuCluster(
                                  GpuCluster(
                                    type: type!,
                                    quantity: quantity!,
                                    datacenterId: datacenter!.id,
                                    companyId: datacenter!.companyId,
                                    id: widget.gpuCluster?.id ?? "",
                                    rentalPrices: rentalPricesSubmitted,
                                    teraFlops: teraFlops,
                                    perGpuVramInGb: perGpuVramInGb,
                                  ),
                                );
                        }
                      },
                      child: Text("Add Gpu"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
