import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/data/audio_data.dart';
import 'package:object_detection/db/db_helper.dart';

class Audio extends StatelessWidget {
  const Audio({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AudioPage extends StatefulWidget {
  const AudioPage({super.key, required this.title});

  final String title;

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool isEmpty = true;
  List<AudioData> fileList = [];
  final DBHelper _dbHelper = DBHelper();
  TextEditingController _searchController = TextEditingController();

  Future<void> _openFileExplorer(BuildContext buildContext)async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
        String filePath = result.files.single.path!;
        // Do something with the selected file path
        String fileName = result.files.single.name;
        AudioData audioData = AudioData(fileName: fileName, path: filePath);
        _dbHelper.insertData(audioData);
    }
  }

  Future<void> _syncDb()async {
    _dbHelper.getFiles().then((value) => {
      setState(() {
        fileList = value;
        isEmpty = value.isEmpty;
      }),
    });
  }

  @override
  initState() {
    super.initState();
    _dbHelper.getFiles().then((value) => {
      setState(() {
        isEmpty = value.isEmpty;
        fileList = value;
      })
    });
    _searchController.addListener(() {
      String keyword = _searchController.text.toLowerCase();
      if (keyword.isNotEmpty){
        setState(() {
          fileList = fileList.where((item) => item.fileName.contains(keyword)).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isEmpty);
    if (isEmpty) {
      return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: ()=>{_openFileExplorer(context)},
            child: const Text('导入本地文件'),
          ),
          ElevatedButton(
              onPressed: ()=>_syncDb(),
              child: const Icon(Icons.refresh)
          )
        ],
      ),
    );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          body:ListView.builder(
                itemCount: fileList.length,
                itemBuilder: (BuildContext context, int index){
                  AudioData item = fileList[index];
                  return Dismissible(
                    key: Key(index.toString()),
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction){
                      fileList.removeAt(index);
                      _dbHelper.delData(item.fileName);
                      setState(() {
                        fileList = fileList;
                        isEmpty = fileList.isEmpty;
                      });
                    },
                    child: ListTile(
                      title: Text(item.fileName),
                    ),
                  );
                },
              )
        );
    }
  }

  @override
  void didUpdateWidget(AudioPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDb();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
