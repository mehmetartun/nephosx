import 'package:nephosx/widgets/search_field.dart';
import 'package:flutter/material.dart';

import '../../../model/search_result_item.dart';

class DataEntryMain extends StatelessWidget {
  final void Function() addNewDrink;
  final void Function() listDrinks;
  final Future<List<SearchResultItem>> Function(String) onSearch;
  const DataEntryMain({
    super.key,
    required this.addNewDrink,
    required this.listDrinks,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Entry')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              FilledButton(onPressed: addNewDrink, child: Text("New Drink")),
              FilledButton(onPressed: listDrinks, child: Text("List Drinks")),

              SearchField(onSearch: onSearch),
            ],
          ),
        ),
      ),
    );
  }
}
