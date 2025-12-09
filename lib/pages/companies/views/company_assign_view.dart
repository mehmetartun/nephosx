import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/company_info_card.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/light_label.dart';
import '../../../model/request.dart';
import '../../../model/user.dart';

class CompanyAssignView extends StatefulWidget {
  final User user;
  final void Function(Company company) onRequestCompany;
  final Request? request;
  final void Function(Request request) onWithdrawRequest;

  final List<Company> companies;
  const CompanyAssignView({
    super.key,
    required this.user,

    required this.companies,
    required this.onRequestCompany,
    this.request,
    required this.onWithdrawRequest,
  });

  @override
  _CompanyAssignViewState createState() => _CompanyAssignViewState();
}

class _CompanyAssignViewState extends State<CompanyAssignView> {
  String? companyName;
  String? companyWebsite;
  String? phoneNumber;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(title: const Text("Edit Company")),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child: MaxWidthBox(
                alignment: Alignment.topCenter,
                maxWidth: 500,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.request == null) ...[
                        Text(
                          "Become a Corporate User",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "My company is already on the platform",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please ask your company administrator to enter"
                          " your email address on the admin panel and once"
                          " you have verified your email you will be assigned to your company.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "I represent the company and wish to register our company on the platform.",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Once you verify your email address, you will be able to "
                          "create a request for your company to be added to the platform.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: !widget.user.emailVerified,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Company Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a company name";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            companyName = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          readOnly: !widget.user.emailVerified,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Company Website",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a company website";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            companyWebsite = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          readOnly: !widget.user.emailVerified,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Contact Phone Number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a phone number";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value;
                          },
                        ),
                        SizedBox(height: 20),
                        FilledButton(
                          onPressed: widget.user.emailVerified
                              ? () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                  }
                                }
                              : null,
                          child: const Text("Request"),
                        ),
                      ],
                      if (widget.request != null) ...[
                        Text(
                          "Authorization Request Pending",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 20),
                        LightLabel(text: "Request Date"),
                        Text(
                          DateFormat(
                            "dd MMM yyyy",
                          ).format(widget.request!.requestDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        LightLabel(text: "Request Summary"),
                        Text(
                          widget.request!.summary ?? "--",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        LightLabel(text: "Request Status"),
                        Text(
                          widget.request!.status.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        FilledButton(
                          child: Text("Withdraw Request"),
                          onPressed: () {
                            widget.onWithdrawRequest(widget.request!);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
