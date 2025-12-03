import 'package:flutter/material.dart';
import 'package:nephosx/model/datacenter.dart';

import 'dialogs/edit_datacenter_dialog.dart';
import 'property_badge.dart';
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
      // leading: TierWidget(tier: datacenter.tier),
      leading: PropertyBadge(text: datacenter.tier.roman),
      title: Text(datacenter.name),
      subtitle: Row(
        children: [
          Text("${datacenter.address.country.flagUnicode} "),
          Text("${datacenter.address.country.description}"),
        ],
      ),
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
