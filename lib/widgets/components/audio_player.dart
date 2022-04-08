import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:record/record.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/widgets/components/player.dart';
import 'package:tollo2/widgets/components/recorder.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({required this.job});

  final Job job;

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late List<String> audios;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    audios = widget.job.pathsAudios;

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color colorOfCard = Theme.of(context).cardColor;
    return Scaffold(
      body: ListView.builder(
        itemCount: audios.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return Recorder(
              job: widget.job,
              update: () {
                setState(() {});
              },
            );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Player(
              pathToAudioFile: audios[index - 1],
              job: widget.job,
              callback: () {
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
