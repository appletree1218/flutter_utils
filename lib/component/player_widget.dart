import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key, required this.player});

  final AudioPlayer player;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _position;
  Duration? _duration;

  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _positionChangedSubscription;
  StreamSubscription? _playerStateChangedSubscription;
  StreamSubscription? _durationSubscription;

  String get _positionText => _position?.toString()??'';
  String get _durationText => _duration?.toString()??'';

  AudioPlayer get player => widget.player;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('')
          ],
        ),
        Slider(
            value: _position!=null && _duration!=null && _position!.inMicroseconds>0 &&
                _position!.inMicroseconds < _duration!.inMicroseconds ?
                _position!.inMicroseconds / _duration!.inMicroseconds:0.0,
            onChanged: (value){
              final duration = _duration;
              if(_duration==null){
                return;
              }
              final position = value * duration!.inMilliseconds;
              player.seek(Duration(microseconds: position.round()));
            }
        ),
        Text(
          _position!=null ? '$_positionText / $_durationText':
              _duration!=null? _durationText :  '',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _playerState==PlayerState.playing?
            IconButton(onPressed:()=>pause(), icon: const Icon(Icons.pause)):
            IconButton(onPressed: ()=>play(), icon: const Icon(Icons.play_arrow)),
            IconButton(onPressed: ()=>reset(), icon: const Icon(Icons.restart_alt)),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    player.getDuration().then(
          (value) => setState(() {
        _duration = value;
      }),
    );
    player.getCurrentPosition().then(
          (value) => setState(() {
        _position = value;
      }),
    );

    _initPlayer();

    _playerState = player.state;
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  void _initPlayer(){
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _playerCompleteSubscription = player.onPlayerStateChanged.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _positionChangedSubscription = player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });

    });

    _playerStateChangedSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> play()async{
    await player.resume();
    setState(() {
      _playerState = PlayerState.playing;
    });
  }

  Future<void> pause()async{
    await player.pause();
    setState(() {
      _playerState = PlayerState.paused;
    });
  }

  Future<void> reset()async{
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
