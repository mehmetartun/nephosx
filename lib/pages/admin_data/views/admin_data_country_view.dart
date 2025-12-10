import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/enums.dart';
import '../../../model/platform_settings.dart';

class AdminDataCountryView extends StatefulWidget {
  final Set<Country> selectedCountries;
  final void Function(Set<Country>) updateCountries;
  final void Function() onCancel;
  final String title;
  const AdminDataCountryView({
    super.key,
    required this.selectedCountries,
    required this.title,
    required this.updateCountries,
    required this.onCancel,
  });

  @override
  State<AdminDataCountryView> createState() => _AdminDataCountryViewState();
}

class _AdminDataCountryViewState extends State<AdminDataCountryView> {
  late List<Country> _selectedCountries;
  late List<Country> allCountries;
  late bool _isDirty;
  late bool _edit;
  @override
  void initState() {
    super.initState();
    _isDirty = false;
    _edit = true;
    _selectedCountries = widget.selectedCountries.toList();
    _selectedCountries.sort((a, b) => a.description.compareTo(b.description));
    allCountries = Country.values.toList();
    allCountries.sort((a, b) => a.description.compareTo(b.description));
  }

  void _onChanged(Country country, bool value) {
    _isDirty = true;
    setState(() {
      if (value) {
        _selectedCountries.add(country);
      } else {
        _selectedCountries.remove(country);
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
                      Text(widget.title),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton(
                            onPressed: _isDirty
                                ? () {
                                    widget.updateCountries(
                                      _selectedCountries.toSet(),
                                    );
                                  }
                                : null,
                            child: Text("Save"),
                          ),
                          SizedBox(width: 20),
                          FilledButton(
                            onPressed: () {
                              widget.onCancel();
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
                            value: _selectedCountries.contains(country),
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
                    Text(widget.title),
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
                              return _selectedCountries.contains(country);
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
