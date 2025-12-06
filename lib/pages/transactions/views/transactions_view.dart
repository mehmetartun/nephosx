import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nephosx/widgets/transaction_table.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/company.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/user.dart';

enum TransactionSort {
  startDateAscending("Start Date ascending"),
  startDateDescending("Start Date descending"),
  durationAscending("Duration Ascending"),
  durationDescending("Duration Descending"),
  transactionDateAscending("Transaction Date Ascending"),
  transactionDateDescending("Transaction Date Descending");

  final String title;

  const TransactionSort(this.title);
}

enum TransactionFilter {
  all("All"),
  today("Today"),
  yesterday("Yesterday"),
  thisWeek("This Week"),
  thisMonth("This Month"),
  thisYear("This Year");

  final String title;
  const TransactionFilter(this.title);
}

class TransactionsView extends StatefulWidget {
  const TransactionsView({
    super.key,
    required this.transactions,
    required this.companies,
    required this.gpuClusters,
  });
  final List<GpuTransaction> transactions;
  final List<Company> companies;
  final List<GpuCluster> gpuClusters;

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late TransactionSort sort;
  late TransactionFilter filter;
  late List<GpuTransaction> transactions;
  late List<GpuTransaction> buys;
  late List<GpuTransaction> sells;

  late User? user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    transactions = widget.transactions.toList();
    buys = widget.transactions.where((e) {
      return user!.companyId == e.buyerCompanyId;
    }).toList();
    sells = widget.transactions.where((e) {
      return user!.companyId == e.sellerCompanyId;
    }).toList();
    sort = TransactionSort.transactionDateDescending;
    filter = TransactionFilter.all;
    filterTransactions();
    sortTransactions();
  }

  void filterTransactions() {
    switch (filter) {
      case TransactionFilter.all:
        transactions = widget.transactions.toList();
        break;
      case TransactionFilter.thisYear:
        transactions = widget.transactions.where((tx) {
          return tx.createdAt.year == DateTime.now().year;
        }).toList();
        break;
      case TransactionFilter.thisMonth:
        transactions = widget.transactions.where((tx) {
          return (tx.createdAt.year == DateTime.now().year &&
              tx.createdAt.month == DateTime.now().month);
        }).toList();
        break;
      case TransactionFilter.today:
        transactions = widget.transactions.where((tx) {
          return (tx.createdAt.year == DateTime.now().year &&
              tx.createdAt.month == DateTime.now().month &&
              tx.createdAt.day == DateTime.now().day);
        }).toList();
        break;
      case TransactionFilter.yesterday:
        transactions = widget.transactions.where((tx) {
          return (tx.createdAt.subtract(Duration(days: 1)).year ==
                  DateTime.now().subtract(Duration(days: 1)).year &&
              tx.createdAt.subtract(Duration(days: 1)).month ==
                  DateTime.now().subtract(Duration(days: 1)).month &&
              tx.createdAt.subtract(Duration(days: 1)).day ==
                  DateTime.now().subtract(Duration(days: 1)).day);
        }).toList();
        break;
      case TransactionFilter.thisWeek:
        DateTime now = DateTime.now();
        int wkd = now.weekday;
        DateTime weekStart = now.subtract(Duration(days: wkd - 1));
        weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
        transactions = widget.transactions.where((tx) {
          return (tx.createdAt.isAfter(weekStart));
        }).toList();
        break;
    }
  }

  void sortTransactions() {
    switch (sort) {
      case TransactionSort.startDateAscending:
        transactions.sort((a, b) {
          return a.startDate.compareTo(b.startDate);
        });
      case TransactionSort.startDateDescending:
        transactions.sort((b, a) {
          return a.startDate.compareTo(b.startDate);
        });

      case TransactionSort.durationAscending:
        transactions.sort((a, b) {
          return a.endDate
              .difference(a.startDate)
              .compareTo(b.endDate.difference(b.startDate));
        });

      case TransactionSort.durationDescending:
        transactions.sort((b, a) {
          return a.endDate
              .difference(a.startDate)
              .compareTo(b.endDate.difference(b.startDate));
        });
      case TransactionSort.transactionDateAscending:
        transactions.sort((a, b) {
          return a.createdAt.compareTo(b.createdAt);
        });
      case TransactionSort.transactionDateDescending:
        transactions.sort((b, a) {
          return a.createdAt.compareTo(b.createdAt);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 900,
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<TransactionSort>(
                    value: sort,
                    items: TransactionSort.values.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e.title));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        val != null ? sort = val : null;
                        sortTransactions();
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  DropdownButton<TransactionFilter>(
                    value: filter,
                    items: TransactionFilter.values.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e.title));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        val != null ? filter = val : null;
                        filterTransactions();
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: TransactionTable(
                  transactions: transactions,
                  gpuClusters: widget.gpuClusters,
                  companies: widget.companies,
                ),
              ),
              SizedBox(height: 20),
              Text("Buying"),
              Container(
                width: double.infinity,
                child: TransactionTable(
                  transactions: buys,
                  gpuClusters: widget.gpuClusters,
                  companies: widget.companies,
                ),
              ),
              SizedBox(height: 20),
              Text("Selling"),
              Container(
                width: double.infinity,
                child: TransactionTable(
                  transactions: sells,
                  gpuClusters: widget.gpuClusters,
                  companies: widget.companies,
                ),
              ),
            ],
          ),

          // ListView.builder(
          //   itemCount: transactions.length,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       margin: const EdgeInsets.all(10),
          //       child: Wrap(
          //         runSpacing: 10,
          //         spacing: 10,
          //         direction: Axis.horizontal,
          //         children: [
          //           LabeledText(
          //             value: transactions[index].id,
          //             label: "ID",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: transactions[index].createdAt,
          //             label: "Transaction Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //           LabeledText(
          //             value: transactions[index].createdAt,
          //             label: "Transaction Time",
          //             position: LabelPosition.left,
          //             format: "HH:mm:ss",
          //           ),
          //           LabeledText(
          //             value: Company.getCompanyFromId(
          //               companies,
          //               transactions[index].buyerCompanyId,
          //             ).name,
          //             label: "Buyer",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: Company.getCompanyFromId(
          //               companies,
          //               transactions[index].sellerCompanyId,
          //             ).name,
          //             label: "Seller",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: transactions[index].gpuClusterId,
          //             label: "GPU Cluster",
          //           ),
          //           LabeledText(
          //             value: transactions[index].startDate,
          //             label: "Start Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //           LabeledText(
          //             value: transactions[index].endDate,
          //             label: "End Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
