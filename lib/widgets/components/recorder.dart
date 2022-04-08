import 'dart:async';

import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/files_handling/audio_save.dart';

class Recorder extends StatefulWidget {
  const Recorder({Key? key, required this.job, required this.update})
      : super(key: key);
  final Job job;
  final Function() update;

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;
  List<Color> rainbow = [
    Colors.purple,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
    Colors.yellow,
    Colors.deepOrange,
    Colors.red
  ];

  Color getColor(double height2, double max) {
    if (height2 > max * 0.9) {
      return Colors.purple;
    } else if (height2 > max * 0.8) {
      return Colors.indigo;
    } else if (height2 > max * 0.7) {
      return Colors.cyan;
    } else if (height2 > max * 0.6) {
      return Colors.green;
    } else if (height2 > max * 0.5) {
      return Colors.yellow;
    } else if (height2 > max * 0.4) {
      return Colors.deepOrange;
    } else if (height2 > max * 0.3) {
      return Colors.cyan;
    } else {
      return Colors.pink;
    }
  }

  // final buffer = CircularBuffer<AudioWaveBar>(40);
  List<AudioWaveBar> fixedLengthList = List<AudioWaveBar>.filled(
      40, AudioWaveBar(height: 1.0, color: Colors.blue),
      growable: true);

  @override
  Widget build(BuildContext context) {
    var size2 = MediaQuery.of(context).size;
    var height3 = size2.shortestSide * 0.25;
    var d = height3 * 0.95;
    if (_isRecording) {
      fixedLengthList.removeAt(0);
      var height2 = (_amplitude!.max - _amplitude!.current).abs();

      fixedLengthList.add(AudioWaveBar(
          height: height2 > d ? d : height2, color: getColor(height2, d)));
    }

    //
    // var height2 = (_amplitude!.max -_amplitude!.current).abs();
    // buffer.add(AudioWaveBar( height: height2 > 150 ? 150 : height2, color: Colors.blue));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRecordStopControl(),
            const SizedBox(width: 20),
            _buildText(),
          ],
        ),
        if (_isRecording)
          FittedBox(
            fit: BoxFit.contain,
            child: AudioWave(
                width: size2.shortestSide * 0.9,
                height: height3,
                beatRate: Duration(seconds: 1),
                alignment: 'top',
                bars: fixedLengthList),
          ),
      ],
    );
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return Text("Waiting to record");
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        String path = await saveSound();

        await _audioRecorder.start(path: path, encoder: AudioEncoder.AAC);

        bool isRecording = await _audioRecorder.isRecording();
        widget.job.pathsAudios.insert(0, path);
        Provider.of<JobModel>(context, listen: false).updateJob(widget.job);
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.stop();

    setState(() => _isRecording = false);
    widget.update();
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

// List<AudioWaveBar> getAudioWaveBars(CircularBuffer<double> buffer) {
//   List<AudioWaveBar> aux = [];
//   buffer.forEach((element) {
//     var height2 = (_amplitude!.max - element).abs();
//     aux.add(AudioWaveBar( height: height2 > 150 ? 150 : height2, color: Colors.blue));
//   });
//   return aux;
// }
}
