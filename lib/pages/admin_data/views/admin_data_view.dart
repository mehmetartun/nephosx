import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/enums.dart';
import '../../../model/platform_settings.dart';

class AdminDataView extends StatefulWidget {
  const AdminDataView({
    super.key,
    required this.platformSettings,
    required this.updateAllowedCountries,
    required this.updateFavoriteCountries,
  });
  final PlatformSettings platformSettings;
  final void Function() updateAllowedCountries;
  final void Function() updateFavoriteCountries;

  @override
  State<AdminDataView> createState() => _AdminDataViewState();
}

class _AdminDataViewState extends State<AdminDataView> {
  List<Country> dataCenterAllowedCountries = [];
  List<Country> favoriteCountries = [];
  @override
  void initState() {
    super.initState();
    dataCenterAllowedCountries = widget
        .platformSettings
        .datacenterAllowedCountries
        .toList();
    dataCenterAllowedCountries.sort(
      (a, b) => a.description.compareTo(b.description),
    );
    favoriteCountries = widget.platformSettings.favoriteCountries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          alignment: Alignment.topLeft,
          maxWidth: 800,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Static Data",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: 20),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Datacenter Countries",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: widget.updateAllowedCountries,
                      child: Text("Edit"),
                    ),
                  ],
                ),
                Text(
                  "These are the only countries allowed in the list when creating datacenters.",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: dataCenterAllowedCountries.map((country) {
                    return ConstrainedBox(
                      // padding: EdgeInsets.fromLTRB(),
                      constraints: BoxConstraints(maxWidth: 140),
                      child: Text(
                        "${country.flagUnicode} ${country.description}",
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Favorite Countries",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: widget.updateFavoriteCountries,
                      child: Text("Edit"),
                    ),
                  ],
                ),
                Text(
                  "These are the countries that are marked as favorite in the country list of an"
                  " address entry. They will appear on the top of the list.",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: favoriteCountries.map((country) {
                    return ConstrainedBox(
                      // padding: EdgeInsets.fromLTRB(),
                      constraints: BoxConstraints(maxWidth: 140),
                      child: Text(
                        "${country.flagUnicode} ${country.description}",
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Producers",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(onPressed: null, child: Text("Edit")),
                  ],
                ),

                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: widget.platformSettings.producers.map((producer) {
                    return ConstrainedBox(
                      // padding: EdgeInsets.fromLTRB(),
                      constraints: BoxConstraints(maxWidth: 140),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.memory(
                            base64Decode(producer.base64Image!),
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              producer.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GPU Devices",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(onPressed: null, child: Text("Edit")),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: widget.platformSettings.devices.map((device) {
                    return ConstrainedBox(
                      // padding: EdgeInsets.fromLTRB(),
                      constraints: BoxConstraints(maxWidth: 140),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.memory),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              device.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CPUs",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(onPressed: null, child: Text("Edit")),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: widget.platformSettings.cpus.map((cpu) {
                    return ConstrainedBox(
                      // padding: EdgeInsets.fromLTRB(),
                      constraints: BoxConstraints(maxWidth: 140),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.memory),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              cpu.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
