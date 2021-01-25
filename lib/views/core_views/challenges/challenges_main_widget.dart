import 'package:azkar/views/core_views/challenges/create_challenge/create_challenge_widget.dart';
import 'package:azkar/views/core_views/home_page.dart';
import 'package:flutter/material.dart';

class ChallengesMainWidget extends StatefulWidget {
  @override
  _ChallengesMainWidgetState createState() => _ChallengesMainWidgetState();
}

class _ChallengesMainWidgetState extends State<ChallengesMainWidget> {
  @override
  Widget build(BuildContext context) {
    HomePage.setAppBarTitle('Challenges');

    return Scaffold(
      body: Text('This is show challenges widget.'),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Challenge'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateChallengeWidget()));
          }),
    );
  }
}
