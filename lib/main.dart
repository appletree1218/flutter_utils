import 'package:flutter/material.dart';
import 'package:object_detection/component/autio.dart';
import 'package:path_provider/path_provider.dart';

void main()async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController, children: const [
                  Icon(Icons.directions_transit),
                  Audio(),
                  Icon(Icons.directions_bike),
              ]),
            ),
            TabBar(
                controller: _tabController, tabs: const <Widget> [
                Tab(icon: Icon(Icons.directions_car), text: '目标检测',),
                Tab(icon: Icon(Icons.directions_transit), text: '音频',),
                Tab(icon: Icon(Icons.directions_bike)),
              ]
              ),
          ]
        )
      )
    );
  }
}
