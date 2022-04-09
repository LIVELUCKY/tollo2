import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/pathWithNote.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/files_handling/delete_file.dart';
import 'package:tollo2/services/formatters/file_name_builder.dart';
import 'package:tollo2/services/permissions/storage_perm.dart';
import 'package:tollo2/widgets/components/audio_player.dart';
import 'package:tollo2/widgets/components/dialog.dart';

class Player extends StatefulWidget {
  const Player(
      {Key? key,
      required this.pathToAudioFile,
      required this.job,
      required this.callback})
      : super(key: key);
  final PathWNote pathToAudioFile;
  final Job job;
  final Function() callback;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    var _labelLocation = TimeLabelLocation.below;
    var _labelType = TimeLabelType.totalTime;
    AudioPlayer _audioPlayer = AudioPlayer();
    late Stream<DurationState> _durationState =
        Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
            _audioPlayer.positionStream,
            _audioPlayer.playbackEventStream,
            (position, playbackEvent) => DurationState(
                  progress: position,
                  buffered: playbackEvent.bufferedPosition,
                  total: playbackEvent.duration,
                ));
    _audioPlayer.setFilePath(widget.pathToAudioFile.path);

    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                buildParsePath(widget.pathToAudioFile.path),
              ),
              IconButton(
                onPressed: () async {
                  bool canDelete = await checkPermissionsStorage();
                  if (canDelete) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            question:
                                'Are you sure You want to delete this audio Record?');
                      },
                    ).then((exit) async {
                      if (exit == null) return;

                      if (exit) {
                        // user pressed Yes button
                        await deleteFile(widget.pathToAudioFile.path).then(
                          (callBack) {
                            if (callBack) {
                              widget.job.pathsAudios
                                  .remove(widget.pathToAudioFile);
                              Provider.of<JobModel>(context, listen: false)
                                  .updateJob(widget.job);
                              widget.callback();
                            }
                          },
                        );
                      } else {
                        // user pressed No button
                      }
                    });
                  }
                },
                icon: Icon(
                  CupertinoIcons.trash,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  width: 32.0,
                  height: 32.0,
                  child: CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 32.0,
                  onPressed: _audioPlayer.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: Icon(Icons.pause),
                  iconSize: 32.0,
                  onPressed: _audioPlayer.pause,
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.replay),
                  iconSize: 32.0,
                  onPressed: () => _audioPlayer.seek(Duration.zero),
                );
              }
            },
          ),
          StreamBuilder<DurationState>(
            stream: _durationState,
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final progress = durationState?.progress ?? Duration.zero;
              final buffered = durationState?.buffered ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;
              return ProgressBar(
                progress: progress,
                buffered: buffered,
                total: total,
                onSeek: (duration) {
                  _audioPlayer.seek(duration);
                },
                timeLabelLocation: _labelLocation,
                timeLabelType: _labelType,
              );
            },
          )
        ],
      ),
    );
  }
}
