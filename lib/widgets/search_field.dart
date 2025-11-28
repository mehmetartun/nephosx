import 'package:flutter/material.dart';

import '../model/search_result_item.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.onSearch});
  final Future<List<SearchResultItem>> Function(String query) onSearch;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  List<SearchResultItem> _results = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          onChanged: (val) {
            widget.onSearch(val).then((results) {
              setState(() {
                _results = results;
              });
            });
          },
        ),
        ..._results.map((res) {
          return ListTile(
            title: Text(res.title),
            subtitle: Text(res.subtitle ?? "-"),
            onTap: res.onTap,
          );
        }),
      ],
    );
  }
}
