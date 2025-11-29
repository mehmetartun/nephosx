import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../widgets/company_list_tile.dart';
import '../../../widgets/dialogs/add_company_dialog.dart';

class CompaniesView extends StatelessWidget {
  const CompaniesView({
    super.key,
    required this.companies,
    required this.addCompany,
  });
  final List<Company> companies;
  final void Function(Map<String, dynamic>) addCompany;

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
                    "All Companies",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  FilledButton.tonalIcon(
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AddCompanyDialog(onAddCompany: addCompany);
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(height: 20),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return CompanyListTile(company: companies[index]);
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
