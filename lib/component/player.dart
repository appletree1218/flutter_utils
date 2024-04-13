import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/component/player_widget.dart';
import 'package:object_detection/data/audio_data.dart';
import 'package:path/path.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.file});

  final AudioData file;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayer player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlayerWidget(player: player),
    );
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    player.setPlayerMode(PlayerMode.mediaPlayer);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(DeviceFileSource(widget.file.path));
      await player.resume();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

}
