import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nephosx/widgets/transaction_table.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/transactions_data_source.dart';
import '../../../model/user.dart';

enum TransactionType { all, buy, sell }

class TransactionsView extends StatefulWidget {
  const TransactionsView({
    super.key,
    required this.transactions,
    required this.onExport,
  });
  final List<GpuTransaction> transactions;
  final void Function(List<GpuTransaction>, {String prefix}) onExport;

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late List<GpuTransaction> transactions;
  late List<GpuTransaction> buys;
  late List<GpuTransaction> sells;
  late TransactionsDataSource transactionsDataSource;

  TransactionType? selectedTransactions = null;

  late User? user;
  bool? _sortAscending;
  int? _sortColumnIndex;

  void _sort<T>(
    Comparable<T> Function(GpuTransaction d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      transactionsDataSource.sort<T>(getField, ascending);
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

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

    transactionsDataSource = TransactionsDataSource(
      transactions: transactions,
      user: user!,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 900,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Transactions List",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  DropdownMenuFormField<TransactionType>(
                    label: Text("Export"),
                    initialSelection: selectedTransactions,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: TransactionType.all,
                        label: "All",
                      ),
                      DropdownMenuEntry(
                        value: TransactionType.buy,
                        label: "Buys",
                      ),
                      DropdownMenuEntry(
                        value: TransactionType.sell,
                        label: "Sells",
                      ),
                    ],
                    onSelected: (val) {
                      switch (val) {
                        case TransactionType.all:
                          widget.onExport(
                            transactions,
                            prefix: "All_Transactions",
                          );
                          return;
                        case TransactionType.buy:
                          widget.onExport(buys, prefix: "Buy_Transactions");
                          return;
                        case TransactionType.sell:
                          widget.onExport(sells, prefix: "Sell_Transactions");
                          return;
                        default:
                          return;
                      }
                    },
                  ),
                  // OutlinedButton(
                  //   onPressed: () => widget.onExport(transactions),
                  //   child: Text("Export"),
                  // ),
                ],
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: TransactionTable(transactions: transactions),
              ),
              SizedBox(height: 20),
              Text("Buying"),
              SizedBox(
                width: double.infinity,
                child: TransactionTable(transactions: buys),
              ),
              SizedBox(height: 20),
              Text("Selling"),
              SizedBox(
                width: double.infinity,
                child: TransactionTable(transactions: sells),
              ),
              PaginatedDataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending ?? true,
                header: Text("All Transactions"),
                columns: transactionsDataSource.getColumns(
                  sortFunction:
                      <T>(
                        Comparable<T> Function(GpuTransaction d) getField,
                        int columnIndex,
                        bool ascending,
                      ) {
                        setState(() {
                          transactionsDataSource.sort<T>(getField, ascending);
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      },
                ),
                source: transactionsDataSource,
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
