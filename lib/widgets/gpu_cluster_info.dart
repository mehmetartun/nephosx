import 'package:flutter/material.dart';

import '../model/gpu_cluster.dart';
import 'labeled_text.dart';

class GpuClusterInfo extends StatelessWidget {
  final GpuCluster gpuCluster;
  const GpuClusterInfo({super.key, required this.gpuCluster});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GPU Cluster Details",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Divider(height: 20),
        Wrap(
          direction: Axis.horizontal,
          // alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 20,
          runSpacing: 20,
          children: [
            LabeledText(label: "GPUType", value: gpuCluster.type.name),
            LabeledText(label: "Quantity", value: "${gpuCluster.quantity}x"),
            LabeledText(
              label: "Datacenter",
              value: gpuCluster.datacenter?.name ?? "",
            ),
            LabeledText(
              label: "Per GPU\nVRAM in GB",
              value: gpuCluster.perGpuVramInGb,
              format: "0.00 GB",
            ),
            LabeledText(
              label: "Deep Learning\nPerformance Score",
              value: gpuCluster.deepLearningPerformanceScore,
              format: "0.00",
            ),
            LabeledText(
              label: "Pcie\nGeneration",
              value: gpuCluster.pcieGeneration?.description ?? "",
            ),
            LabeledText(
              label: "PCIe Lanes",
              value: gpuCluster.pcieLanes,
              format: "0",
            ),
            LabeledText(
              label: "PCIe Bandwidth",
              value: gpuCluster.perGpuPcieBandwidthInGbPerSec,
              format: "0.00 GB/s",
            ),
            LabeledText(
              label: "Max. CUDA\nVer. Supported",
              value: gpuCluster.maximumCudaVersionSupported,
            ),
            LabeledText(
              label: "Memory\nBandwidth",
              value: gpuCluster.perGpuMemoryBandwidthInGbPerSec,
              format: "0.00 GB/s",
            ),
            LabeledText(
              label: "NvLink\nBandwidth",
              value: gpuCluster.perGpuNvLinkBandwidthInGbPerSec,
              format: "0.00 GB/s",
            ),
            LabeledText(
              label: "Effective\nRAM",
              value: gpuCluster.effectiveRam,
              format: "0.00 GB",
            ),
            LabeledText(
              label: "Total\nRAM",
              value: gpuCluster.totalRam,
              format: "0.00 GB",
            ),
            LabeledText(
              label: "Total CPU\nCore Count",
              value: gpuCluster.totalCpuCoreCount,
              format: "0",
            ),
            LabeledText(
              label: "Effective CPU\nCore Count",
              value: gpuCluster.effectiveCpuCoreCount,
              format: "0",
            ),
            LabeledText(
              label: "Internet Upload\nSpeed",
              value: gpuCluster.internetUploadSpeedInMbps,
              format: "0.00 Mbps",
            ),
            LabeledText(
              label: "Internet Download\nSpeed",
              value: gpuCluster.internetDownloadSpeedInMbps,
              format: "0.00 Mbps",
            ),
            LabeledText(
              label: "# of Open\nPorts",
              value: gpuCluster.numberOfOpenPorts,
              format: "0",
            ),
            LabeledText(
              label: "Disk\nBandwidth",
              value: gpuCluster.diskBandwidthInMbPerSec,
              format: "0.00 MB/s",
            ),
            LabeledText(
              label: "Disk Storage\nAvailable",
              value: gpuCluster.diskStorageAvailableInGb,
              format: "0.00 GB",
            ),
          ],
        ),
      ],
    );
  }
}
