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
                alignment: Alignment.topLeft,
                maxWidth: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.request == null) ...[
                      Text(
                        "Assign Company",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "You are currently not assigned to a company."
                        "\nPlease select a company from the list "
                        "below and create a request.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.companies.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.companies[index].name),
                            trailing: TextButton(
                              child: Text("Assign"),
                              onPressed: () {
                                widget.onRequestCompany(
                                  widget.companies[index],
                                );
                              },
                            ),
                          );
                        },
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
        ],
      ),
    );
  }
}
