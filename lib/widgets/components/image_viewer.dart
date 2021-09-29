import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/files_handling/delete_file.dart';
import 'package:tollo2/services/formatters/file_name_builder.dart';
import 'package:tollo2/services/permissions/storage_perm.dart';
import 'package:tollo2/widgets/components/dialog.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.job, required this.pathToImage})
      : super(key: key);
  final Job job;
  final String pathToImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(
            child: Image.file(
              File(pathToImage),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: size.shortestSide / 14,
            top: 0,
            child: IconButton(
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
                      await deleteFile(pathToImage).then(
                        (callBack) {
                          if (callBack) {
                            job.pathsImages.remove(pathToImage);
                            Provider.of<JobModel>(context, listen: false)
                                .updateJob(job);
                            Navigator.pop(context, true);
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
                size: size.shortestSide / 5,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: Icon(
                CupertinoIcons.chevron_back,
                size: size.shortestSide / 8,
              ),
            ),
          ),
          Positioned(
            bottom: size.shortestSide / 20,
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              child: Text(
                buildParsePath(pathToImage),
                textScaleFactor: size.aspectRatio * 3.7,
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
