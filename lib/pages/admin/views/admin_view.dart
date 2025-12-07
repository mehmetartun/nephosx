import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/enums.dart';
import '../../../model/platform_settings.dart';

class AdminView extends StatefulWidget {
  final PlatformSettings platformSettings;
  final void Function(Set<Country>) updateCountries;
  const AdminView({
    super.key,
    required this.platformSettings,
    required this.updateCountries,
  });

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late List<Country> _allowedCountries;
  late List<Country> allCountries;
  late bool _isDirty;
  late bool _edit;
  @override
  void initState() {
    super.initState();
    _isDirty = false;
    _edit = false;
    _allowedCountries = widget.platformSettings.datacenterAllowedCountries
        .toList();
    allCountries = Country.values.toList();
    allCountries.sort((a, b) => a.description.compareTo(b.description));
  }

  void _onChanged(Country country, bool value) {
    _isDirty = true;
    setState(() {
      if (value) {
        _allowedCountries.add(country);
      } else {
        _allowedCountries.remove(country);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Admin'),
      // ),
      body: Center(
        child: MaxWidthBox(
          maxWidth: 600,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...[
                SizedBox(height: 10),
                if (_edit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Allowed Countries"),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton(
                            onPressed: _isDirty
                                ? () {
                                    widget.updateCountries(
                                      _allowedCountries.toSet(),
                                    );
                                  }
                                : null,
                            child: Text("Save"),
                          ),
                          SizedBox(width: 20),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                _edit = false;
                                _isDirty = false;
                                _allowedCountries = widget
                                    .platformSettings
                                    .datacenterAllowedCountries
                                    .toList();
                              });
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
              if (_edit) ...[
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...allCountries.map((country) {
                          return CheckboxListTile(
                            title: Text(
                              "${country.flagUnicode} ${country.description}",
                            ),
                            value: _allowedCountries.contains(country),
                            onChanged: (value) => _onChanged(country, value!),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
              if (!_edit) ...[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Allowed Countries"),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _edit = true;
                        });
                      },
                      child: Text("Change"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...allCountries
                            .where((country) {
                              return _allowedCountries.contains(country);
                            })
                            .map((country) {
                              return ListTile(
                                title: Text(
                                  "${country.flagUnicode} ${country.description}",
                                ),
                                // value: _allowedCountries.contains(country),
                                // onChanged: (value) => _onChanged(country, value!),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
