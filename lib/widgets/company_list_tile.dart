import 'package:flutter/material.dart';
import 'package:nephosx/model/company.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({super.key, required this.company});
  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(company.name));
  }
}
