import 'package:flutter/material.dart';

import '../../extensions/capitalize.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class DrinkCompanyFormField extends FormField<DrinkCompany> {
  DrinkCompanyFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    EdgeInsets? padding,
  }) : super(
         builder: (state) {
           return _DrinkCompanyFormField(
             state: state,
             companyList: DrinkCompany.values,
             padding: padding ?? EdgeInsets.all(16),
           );
         },
       );
}

class _DrinkCompanyFormField extends StatefulWidget {
  const _DrinkCompanyFormField({
    required this.state,
    required this.companyList,
    required this.padding,
  });
  final FormFieldState<DrinkCompany> state;
  final List<DrinkCompany> companyList;
  final EdgeInsets padding;

  @override
  State<_DrinkCompanyFormField> createState() => _DrinkCompanyFormFieldState();
}

class _DrinkCompanyFormFieldState extends State<_DrinkCompanyFormField> {
  DrinkCompany? selectedValue;
  DrinkCompany? initialValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.state.value;
    initialValue = widget.state.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.state.hasError) ...[
          Text(
            widget.state.errorText ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 10),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: widget.padding,
          // Use the crossAxisCount to configure the grid delegate
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenUtils.getGridCount(context),
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
            childAspectRatio: 2, // This is the key to making them square
          ),
          itemCount: widget.companyList.length,
          itemBuilder: (context, index) {
            // Your button widget goes here
            return GestureDetector(
              onTap: () {
                // widget.onAmountSelected(widget.drink, sizes[index]);
                setState(() {
                  selectedValue = widget.companyList[index];
                  widget.state.didChange(selectedValue);
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),

                decoration: ShapeDecoration(
                  color: selectedValue == widget.companyList[index]
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.companyList[index].title.toTitleCase(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: selectedValue == widget.companyList[index]
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         NumberFormat(
                    //           '0 mL',
                    //         ).format(widget.locations[index].volumeInML),
                    //         style: Theme.of(context).textTheme.titleMedium
                    //             ?.copyWith(
                    //               color: selectedSize == widget.sizes[index]
                    //                   ? Theme.of(context).colorScheme.onPrimary
                    //                   : Theme.of(context).colorScheme.primary,
                    //             ),
                    //       ),
                    //       Text(
                    //         NumberFormat(
                    //           '0.0 oz',
                    //         ).format((widget.sizes[index].volumeInML.mLtoOz())),
                    //         style: Theme.of(context).textTheme.titleMedium
                    //             ?.copyWith(
                    //               color: selectedSize == widget.sizes[index]
                    //                   ? Theme.of(context).colorScheme.onPrimary
                    //                   : Theme.of(context).colorScheme.primary,
                    //             ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
