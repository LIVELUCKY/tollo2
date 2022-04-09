import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/pathWithNote.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/files_handling/delete_file.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/formatters/file_name_builder.dart';
import 'package:tollo2/services/permissions/storage_perm.dart';
import 'package:tollo2/widgets/components/dialog.dart';

import '../../services/textDirection.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, required this.job, required this.index})
      : super(key: key);
  final Job job;
  final int index;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late TextEditingController _controller;
  bool r = false;
  late PathWNote pathToImage;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    pathToImage = widget.job.pathsImages[currentIndex];
    _controller = new TextEditingController(text: pathToImage.note);
    r = isRTL(_controller.text);
    _controller.addListener(() {
      setState(() {
        r = isRTL(_controller.text);
        pathToImage.note = _controller.text;
        pathToImage.createdAt = DateTime.now();

        Provider.of<JobModel>(context, listen: false).updateJob(widget.job);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  swipe(-1);
                } else if (details.delta.dx < -sensitivity) {
                  swipe(1);
                }
              },
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            CupertinoIcons.chevron_back,
                          ),
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
                                          'Are you sure You want to delete this Image?');
                                },
                              ).then((exit) async {
                                if (exit == null) return;

                                if (exit) {
                                  // user pressed Yes button
                                  await deleteFile(pathToImage.path).then(
                                    (callBack) {
                                      if (callBack) {
                                        widget.job.pathsImages
                                            .remove(pathToImage);
                                        Provider.of<JobModel>(context,
                                                listen: false)
                                            .updateJob(widget.job);
                                        if (widget.job.pathsImages
                                            .asMap()
                                            .containsKey(currentIndex - 1)) {
                                          setState(() {
                                            goTo(-1);
                                          });
                                        } else {
                                          Navigator.pop(context, true);
                                        }
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
                            CupertinoIcons.trash_fill,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                    Image.file(
                      File(pathToImage.path),
                      fit: BoxFit.contain,
                    ),
                    Text(
                      buildParsePath(pathToImage.path),
                      textScaleFactor: size.aspectRatio * 3.7,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          backgroundColor: Colors.grey.withOpacity(0.1)),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        Row(children: [
                          Text('last edited at: ' +
                              formatFull(pathToImage.createdAt))
                        ]),
                        TextField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          controller: _controller,
                          textAlign: r ? TextAlign.right : TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void swipe(int x) {
    if (widget.job.pathsImages.asMap().containsKey(currentIndex + x)) {
      setState(() {
        goTo(x);
      });
    }
  }

  void goTo(int x) {
    currentIndex += x;
    pathToImage = widget.job.pathsImages[currentIndex];
    _controller = TextEditingController(text: pathToImage.note);
  }
}
