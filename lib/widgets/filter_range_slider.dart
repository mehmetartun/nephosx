import 'package:flutter/material.dart';

class FilterRangeSlider extends StatefulWidget {
  const FilterRangeSlider({
    Key? key,
    required this.title,
    required this.initialRangeValues,
  }) : super(key: key);
  final String title;
  final RangeValues initialRangeValues;

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  late RangeValues _rangeValues;
  @override
  void initState() {
    super.initState();
    _rangeValues = widget.initialRangeValues;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.title}: ${_rangeValues.start.floor().toString()} - ${_rangeValues.end.floor().toString()}',
          ),
          RangeSlider(
            values: _rangeValues,
            min: 0,
            max: 100,
            onChanged: (RangeValues values) {
              setState(() {
                _rangeValues = values;
              });
            },
          ),
        ],
      ),
    );
  }
}
