import 'package:coach/pages/data_entry/data_entry_page.dart';
import 'package:flutter/material.dart';

import 'profile/profile_page.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing Page')),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: Text("Profile"),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            TextButton(
              child: Text("Data"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DataEntryPage()),
                );
              },
            ),
            TextButton(
              child: Text("Drink"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DataEntryPage(itemId: "2b2SgkiGZyTloYcmW7xF"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
