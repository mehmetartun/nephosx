import 'package:coach/extensions/capitalize.dart';
import 'package:coach/model/drink.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/enums.dart';
import '../../../services/responsive_utils.dart';
import '../../../widgets/calendar_date.dart';
import '../../../widgets/selection_button.dart';

class SelectionView extends StatefulWidget {
  const SelectionView({
    super.key,
    required this.onDrinkTypeSelected,
    required this.onDrinkTypeConfirmed,
  });
  final void Function(DrinkType drinkType) onDrinkTypeSelected;
  final void Function(DrinkType drinkType) onDrinkTypeConfirmed;

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  DrinkType? _drinkType;

  @override
  Widget build(BuildContext context) {
    final List<String> _items = DrinkType.values.map((e) => e.name).toList();
    return Scaffold(
      // appBar: AppBar(title: Text("Select Drink Type")),
      floatingActionButton: _drinkType == null
          ? null
          : FloatingActionButton.extended(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                widget.onDrinkTypeConfirmed(_drinkType!);
              },
              label: Text("Continue"),
              icon: Icon(Icons.arrow_forward),
              disabledElevation: 10,
              isExtended: true,
            ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black45,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Category",
                style: Theme.of(
                  context,
                ).textTheme?.headlineSmall?.copyWith(color: Colors.white),
              ),

              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black54,
                    ],
                    stops: [0.0, 0.2, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Image.asset(
                  'assets/images/BarImage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                    shrinkWrap: true,
                    // Use the crossAxisCount to configure the grid delegate
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ScreenUtils.getGridCount(context),
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      childAspectRatio:
                          1.0, // This is the key to making them square
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      // Your button widget goes here
                      return SelectionButton(
                        onDrinkTypeSelected: (type, se) {
                          setState(() {
                            if (se) {
                              _drinkType = type;
                            } else {
                              _drinkType = null;
                            }
                          });
                          widget.onDrinkTypeSelected(type);
                        },

                        drinkType: DrinkType.values[index],
                        selected: false,
                      );
                    },
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: FilledButton(
                  //     onPressed: _drinkType == null
                  //         ? null
                  //         : () {
                  //             widget.onDrinkTypeConfirmed(_drinkType!);
                  //           },
                  //     child: Text("Continue"),
                  //   ),
                  // ),
                ],
              ),
              //  Wrap(
              //   children: [
              //     ...DrinkType.values.map((val) {
              //       return FilledButton(child: Text(val.name), onPressed: () {});
              //     }),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
