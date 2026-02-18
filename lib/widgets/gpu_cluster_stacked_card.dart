import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephosx/widgets/descriptor.dart';

import '../model/gpu_cluster.dart';

class GpuClusterStackedCard extends StatefulWidget {
  const GpuClusterStackedCard({
    super.key,
    required this.gpuCluster,
    this.isOwner = false,
  });
  final GpuCluster gpuCluster;
  final bool isOwner;

  @override
  State<GpuClusterStackedCard> createState() => _GpuClusterStackedCardState();
}

class _GpuClusterStackedCardState extends State<GpuClusterStackedCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: MemoryImage(
                            base64Decode(
                              widget.gpuCluster.producer!.base64Image!,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                        // border: Border.all(width: 8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // SizedBox(
                    //   height: 64,
                    //   child: Container(
                    //     clipBehavior: Clip.hardEdge,
                    //     foregroundDecoration: BoxDecoration(
                    //       shape: BoxShape.rectangle,
                    //       borderRadius: BorderRadius.circular(8),
                    //       // border: Border.all(
                    //       //   color: Theme.of(context).colorScheme.outlineVariant,
                    //       //   width: 0.5,

                    //       // ),
                    //     ),
                    //     child: Image.memory(
                    //       base64Decode(widget.gpuCluster.producer!.base64Image!),
                    //       width: 48,
                    //       height: 48,
                    //       fit: BoxFit.fitWidth,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GPU Type",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          widget.gpuCluster.producer!.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.isOwner)
                  InputChip(
                    avatar: CircleAvatar(child: Icon(Icons.star, size: 12)),

                    label: Text("Owner"),
                    isEnabled: true,
                    // selected: true,
                    onPressed: () {},
                  ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Descriptor(
                        label: "Count",
                        text: widget.gpuCluster.producer!.name,
                      ),
                    ),
                    Expanded(
                      child: Descriptor(
                        label: "Location",
                        text: widget.gpuCluster.producer!.name,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Descriptor(
                        label: "TFlops",
                        text: widget.gpuCluster.teraFlops.toString(),
                      ),
                    ),
                    Expanded(
                      child: Descriptor(
                        label: "Rel %",
                        text: widget
                            .gpuCluster
                            .datacenter!
                            .tier
                            .reliabilityPercentage
                            .toString(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Descriptor(
                        label: "RAM/GPU",
                        text: widget.gpuCluster.perGpuVramInGb.toString(),
                      ),
                    ),
                    Expanded(
                      child: Descriptor(
                        label: "Start Date",
                        text: widget.gpuCluster.startDateFormatted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price per Hour",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      "\$10.0",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                widget.isOwner
                    ? Row(
                        children: [
                          OutlinedButton.icon(
                            label: Text("Edit"),
                            icon: Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          SizedBox(width: 10),
                          FilledButton.tonal(
                            child: Text("View Listing"),
                            onPressed: () {},
                          ),
                        ],
                      )
                    : FilledButton(onPressed: () {}, child: Text("Lease")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
