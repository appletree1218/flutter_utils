import 'package:flutter/material.dart';
import 'package:object_detection/db/db_helper.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlayerPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.title});

  final String title;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool isEmpty = true;
  List<String> fileList = [];
  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Text('');
  }

}
