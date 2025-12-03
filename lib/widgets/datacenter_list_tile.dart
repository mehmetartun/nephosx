import 'package:flutter/material.dart';
import 'package:nephosx/model/datacenter.dart';

import 'dialogs/edit_datacenter_dialog.dart';
import 'tier_widget.dart';

class DatacenterListTile extends StatelessWidget {
  const DatacenterListTile({
    super.key,
    required this.datacenter,
    this.onUpdateDatacenter,
    this.onTap,
  });
  final Datacenter datacenter;
  final void Function()? onTap;
  final void Function(Datacenter)? onUpdateDatacenter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: TierWidget(tier: datacenter.tier),
      title: Text(datacenter.name),
      subtitle: Text("${datacenter.address.country.description}"),
      trailing: onUpdateDatacenter == null
          ? null
          : IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                onUpdateDatacenter!(datacenter);
              },
            ),
    );
  }
}
