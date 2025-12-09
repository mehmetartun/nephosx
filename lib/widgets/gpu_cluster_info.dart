import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/gpu_property_list.dart';

import '../model/gpu_cluster.dart';
import '../model/key_value_pair.dart';
import 'labeled_text.dart';

class GpuClusterInfo extends StatelessWidget {
  final GpuCluster gpuCluster;
  const GpuClusterInfo({super.key, required this.gpuCluster});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GPU Cluster Details",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Divider(height: 20),
          // Wrap(
          //   direction: Axis.horizontal,
          //   // alignment: WrapAlignment.end,
          //   crossAxisAlignment: WrapCrossAlignment.end,
          //   spacing: 20,
          //   runSpacing: 20,
          //   children: [
          //     LabeledText(
          //       label: "GPU Model",
          //       value: gpuCluster.device?.name ?? 'ERROR',
          //     ),
          //     LabeledText(label: "Quantity", value: "${gpuCluster.quantity}x"),
          //     LabeledText(
          //       label: "Datacenter",
          //       value: gpuCluster.datacenter?.name ?? "",
          //     ),
          //     LabeledText(
          //       label: "Per GPU\nVRAM in GB",
          //       value: gpuCluster.perGpuVramInGb,
          //       format: "0.00 GB",
          //     ),
          //     LabeledText(
          //       label: "Deep Learning\nPerformance Score",
          //       value: gpuCluster.deepLearningPerformanceScore,
          //       format: "0.00",
          //     ),
          //     LabeledText(
          //       label: "Pcie\nGeneration",
          //       value: gpuCluster.pcieGeneration?.description ?? "",
          //     ),
          //     LabeledText(
          //       label: "PCIe Lanes",
          //       value: gpuCluster.pcieLanes,
          //       format: "0",
          //     ),
          //     LabeledText(
          //       label: "PCIe Bandwidth",
          //       value: gpuCluster.perGpuPcieBandwidthInGbPerSec,
          //       format: "0.00 GB/s",
          //     ),
          //     LabeledText(
          //       label: "Max. CUDA\nVer. Supported",
          //       value: gpuCluster.maximumCudaVersionSupported,
          //     ),
          //     LabeledText(
          //       label: "Memory\nBandwidth",
          //       value: gpuCluster.perGpuMemoryBandwidthInGbPerSec,
          //       format: "0.00 GB/s",
          //     ),
          //     LabeledText(
          //       label: "NvLink\nBandwidth",
          //       value: gpuCluster.perGpuNvLinkBandwidthInGbPerSec,
          //       format: "0.00 GB/s",
          //     ),
          //     LabeledText(
          //       label: "Effective\nRAM",
          //       value: gpuCluster.effectiveRam,
          //       format: "0.00 GB",
          //     ),
          //     LabeledText(
          //       label: "Total\nRAM",
          //       value: gpuCluster.totalRam,
          //       format: "0.00 GB",
          //     ),
          //     LabeledText(
          //       label: "Total CPU\nCore Count",
          //       value: gpuCluster.totalCpuCoreCount,
          //       format: "0",
          //     ),
          //     LabeledText(
          //       label: "Effective CPU\nCore Count",
          //       value: gpuCluster.effectiveCpuCoreCount,
          //       format: "0",
          //     ),
          //     LabeledText(
          //       label: "Internet Upload\nSpeed",
          //       value: gpuCluster.internetUploadSpeedInMbps,
          //       format: "0.00 Mbps",
          //     ),
          //     LabeledText(
          //       label: "Internet Download\nSpeed",
          //       value: gpuCluster.internetDownloadSpeedInMbps,
          //       format: "0.00 Mbps",
          //     ),
          //     LabeledText(
          //       label: "# of Open\nPorts",
          //       value: gpuCluster.numberOfOpenPorts,
          //       format: "0",
          //     ),
          //     LabeledText(
          //       label: "Disk\nBandwidth",
          //       value: gpuCluster.diskBandwidthInMbPerSec,
          //       format: "0.00 MB/s",
          //     ),
          //     LabeledText(
          //       label: "Disk Storage\nAvailable",
          //       value: gpuCluster.diskStorageAvailableInGb,
          //       format: "0.00 GB",
          //     ),
          //   ],
          // ),
          // Divider(height: 20),
          Wrap(
            direction: Axis.horizontal,
            // alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 20,
            runSpacing: 20,

            children: [
              GpuPropertyList(
                title: "Provider & Location",
                properties: [
                  KeyValuePair(
                    key: "Provider",
                    value: gpuCluster.company?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "Data Center",
                    value: gpuCluster.datacenter?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "City",
                    value: gpuCluster.datacenter?.address.city ?? "",
                  ),
                  KeyValuePair(
                    key: "Country/State",
                    value:
                        (gpuCluster.datacenter?.address.country.hasStates ??
                            false)
                        ? "${gpuCluster.datacenter?.address.state?.description ?? ""}, ${gpuCluster.datacenter?.address.country.description ?? ""}"
                        : (gpuCluster.datacenter?.address.country.description ??
                              ""),
                  ),
                  KeyValuePair(
                    key: "Region",
                    value:
                        gpuCluster
                            .datacenter
                            ?.address
                            .country
                            .region
                            .description ??
                        "",
                  ),
                ],
              ),
              GpuPropertyList(
                title: "GPU Specifications",
                properties: [
                  KeyValuePair(
                    key: "GPU Model",
                    value: gpuCluster.device?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "Manufacturer",
                    value: gpuCluster.producer?.name ?? "",
                  ),
                  KeyValuePair(
                    key: "Architecture",
                    value: gpuCluster.device?.architecture ?? "",
                  ),
                  KeyValuePair(
                    key: "Manufacture Date",
                    value: DateFormat(
                      "yyyy-MM",
                    ).format(gpuCluster.manufactureDate ?? DateTime.now()),
                  ),
                  KeyValuePair(
                    key: "Number of GPUs",
                    value: gpuCluster.quantity.toString(),
                  ),
                  KeyValuePair(
                    key: "GPU age (months)",
                    value: gpuCluster.ageInMonths.toString(),
                  ),
                ],
              ),
              GpuPropertyList(
                title: "Performance",
                properties: [
                  KeyValuePair(
                    key: "Total Teraflops",
                    value: gpuCluster.teraFlops?.toString() ?? "",
                  ),
                  KeyValuePair(
                    key: "Per-GPU RAM (GB)",
                    value: gpuCluster.perGpuVramInGb?.toString() ?? "",
                  ),
                  KeyValuePair(
                    key: "Memory Bandwidth (GB/s)",
                    value:
                        gpuCluster.perGpuMemoryBandwidthInGbPerSec
                            ?.toString() ??
                        "",
                  ),
                  KeyValuePair(
                    key: "NVLink Bandwidth (GB/s)",
                    value:
                        gpuCluster.perGpuNvLinkBandwidthInGbPerSec
                            ?.toString() ??
                        "",
                  ),
                  KeyValuePair(
                    key: "PCIe Lanes",
                    value: gpuCluster.pcieLanes?.toString() ?? "",
                  ),
                  KeyValuePair(
                    key: "Deep Learning Score",
                    value:
                        gpuCluster.deepLearningPerformanceScore?.toString() ??
                        "",
                  ),
                ],
              ),
              GpuPropertyList(
                title: "System Specifications",
                properties: [
                  KeyValuePair(
                    key: "CPU Model",
                    value: gpuCluster.cpu?.name ?? "",
                  ),
                  KeyValuePair(key: "System RAM (GB)", value: "2048..."),
                  KeyValuePair(key: "Internal Network (Gbps)", value: "100..."),
                  KeyValuePair(key: "External Network (Gbps)", value: "100..."),
                  KeyValuePair(key: "Storage Type", value: "NVMe SSD ..."),
                  KeyValuePair(
                    key: "Storage Capacity (GB)",
                    value: gpuCluster.diskStorageAvailableInGb.toString(),
                  ),
                ],
              ),
              GpuPropertyList(
                title: "Software",
                properties: [
                  KeyValuePair(
                    key: "CUDA Version",
                    value:
                        gpuCluster.maximumCudaVersionSupported?.toString() ??
                        "",
                  ),
                  KeyValuePair(key: "Driver Version", value: "123.123.123"),
                ],
              ),

              GpuPropertyList(
                title: "Availability & Pricing",
                properties: [
                  KeyValuePair(
                    key: "Earliest Start",
                    value: gpuCluster.availabilityDate == null
                        ? ""
                        : DateFormat(
                            "yyyy-MM-dd",
                          ).format(gpuCluster.availabilityDate!),
                  ),
                  KeyValuePair(
                    key: "Latest End",
                    value: gpuCluster.availabilityDate == null
                        ? ""
                        : DateFormat(
                            "yyyy-MM-dd",
                          ).format(gpuCluster.availabilityDate!),
                  ),
                  KeyValuePair(
                    key: "Reliability (%)",
                    value: gpuCluster.datacenter == null
                        ? ""
                        : NumberFormat("0.000").format(
                            gpuCluster.datacenter!.tier.reliabilityPercentage,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
