import 'package:coach/extensions/capitalize.dart';
import 'package:coach/pages/data_entry/cubit/data_entry_cubit.dart';
import 'package:coach/widgets/drink_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/drink.dart';
import '../../../services/image_utils.dart';
import '../../../widgets/drink_card.dart';
import '../../../widgets/edit_property.dart';

class DrinkView extends StatefulWidget {
  final Drink drink;
  final void Function<T>(T, String) onUpdate;
  final void Function() goBack;
  final Future<Map<String, dynamic>> Function(String) runRecipe;
  final Future<Map<String, dynamic>> Function(String) runDrink;
  const DrinkView({
    super.key,
    required this.drink,
    required this.onUpdate,
    required this.goBack,
    required this.runRecipe,
    required this.runDrink,
  });

  @override
  State<DrinkView> createState() => _DrinkViewState();
}

class _DrinkViewState extends State<DrinkView> {
  Map<String, dynamic>? result;
  bool isGenerating = false;
  late Widget imageWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drink.drinkType.name.toTitleCase()),
        actions: [
          IconButton(icon: Icon(Icons.arrow_back), onPressed: widget.goBack),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DrinkMainCard(
            drink: widget.drink,
            onUpdate: widget.onUpdate,
            runRecipe: widget.runRecipe,
            runDrink: widget.runDrink,
          ),
        ),
      ),
    );
  }
}
