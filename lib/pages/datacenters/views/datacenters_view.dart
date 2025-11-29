import 'package:flutter/material.dart';
import 'package:nephosx/extensions/capitalize.dart';
import 'package:nephosx/pages/datacenters/views/datacenters_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../widgets/company_list_tile.dart';
import '../../../widgets/datacenter_list_tile.dart';
import '../../../widgets/dialogs/add_company_dialog.dart';
import '../../../widgets/dialogs/add_datacenter_dialog.dart';

class DatacentersView extends StatefulWidget {
  const DatacentersView({
    super.key,
    required this.datacenters,
    required this.addDatacenter,
    required this.updateDatacenter,
    required this.getGpus,
  });
  final List<Datacenter> datacenters;
  final void Function(Map<String, dynamic>) addDatacenter;
  final void Function(Datacenter) updateDatacenter;
  final void Function(Datacenter) getGpus;

  @override
  State<DatacentersView> createState() => _DatacentersViewState();
}

enum DatacenterSort { name, tier, country, region }

class _DatacentersViewState extends State<DatacentersView> {
  List<Datacenter> datacenters = [];

  DatacenterSort sort = DatacenterSort.name;

  @override
  void initState() {
    super.initState();
    datacenters = widget.datacenters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topLeft,
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Datacenters",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  FilledButton.tonalIcon(
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AddDatacenterDialog(
                            onAddDatacenter: widget.addDatacenter,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Sort by ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  DropdownButton<DatacenterSort>(
                    value: sort,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        sort = value;
                        switch (sort) {
                          case DatacenterSort.name:
                            datacenters.sort(
                              (a, b) => a.name.compareTo(b.name),
                            );
                            break;
                          case DatacenterSort.tier:
                            datacenters.sort(
                              (a, b) => a.tier.rank.compareTo(b.tier.rank),
                            );
                            break;
                          case DatacenterSort.country:
                            datacenters.sort(
                              (a, b) => a.country.compareTo(b.country),
                            );
                            break;
                          case DatacenterSort.region:
                            datacenters.sort(
                              (a, b) => a.region.compareTo(b.region),
                            );
                            break;
                        }
                      });
                    },
                    items: DatacenterSort.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.name.toTitleCase()),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(height: 10),
                  itemCount: widget.datacenters.length,
                  itemBuilder: (context, index) {
                    final datacenter = widget.datacenters[index];
                    return DatacenterListTile(
                      onTap: () {
                        widget.getGpus(datacenter);
                      },
                      datacenter: datacenter,
                      onUpdateDatacenter: widget.updateDatacenter,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
