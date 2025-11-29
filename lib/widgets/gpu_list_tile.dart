import 'package:flutter/material.dart';
import 'package:nephosx/model/gpu.dart';

import 'dialogs/edit_gpu_dialog.dart';
import 'tier_widget.dart';

class GpuListTile extends StatelessWidget {
  const GpuListTile({super.key, required this.gpu, required this.onUpdateGpu});
  final Gpu gpu;
  final void Function(Gpu) onUpdateGpu;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.computer),
      title: Text(gpu.type.name),
      subtitle: Text("${gpu.quantity}x"),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return EditGpuDialog(gpu: gpu, onUpdateGpu: onUpdateGpu);
            },
          );
        },
      ),
    );
  }
}
