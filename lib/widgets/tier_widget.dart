import 'package:flutter/material.dart';

import '../model/datacenter.dart';

class TierWidget extends StatelessWidget {
  const TierWidget({Key? key, required this.tier}) : super(key: key);
  final DatacenterTier tier;

  @override
  Widget build(BuildContext context) {
    final fS = Icon(Icons.star, color: Theme.of(context).colorScheme.primary);
    final eS = Icon(
      Icons.star_border,
      color: Theme.of(context).colorScheme.primary,
    );
    switch (tier) {
      case DatacenterTier.tier1:
        return Row(mainAxisSize: MainAxisSize.min, children: [fS, fS, fS, fS]);
      case DatacenterTier.tier2:
        return Row(mainAxisSize: MainAxisSize.min, children: [fS, fS, fS, eS]);
      case DatacenterTier.tier3:
        return Row(mainAxisSize: MainAxisSize.min, children: [fS, fS, eS, eS]);
      case DatacenterTier.tier4:
        return Row(mainAxisSize: MainAxisSize.min, children: [fS, eS, eS, eS]);
    }
  }
}
