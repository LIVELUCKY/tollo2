import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/files_handling/save_image.dart';
import 'package:tollo2/services/permissions/camera_perm.dart';
import 'package:tollo2/widgets/components/image_viewer.dart';

class JobGallery extends StatefulWidget {
  const JobGallery({Key? key, required this.job}) : super(key: key);
  final Job job;

  @override
  _JobGalleryState createState() => _JobGalleryState();
}

class _JobGalleryState extends State<JobGallery> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.job.pathsImages.length + 2,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              child: IconButton(
                onPressed: () async {
                  bool cond = await checkPermissionsCamera();
                  if (!cond) return;
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  String file = await saveImage(pickedFile);
                  if (file != '') {
                    widget.job.pathsImages.insert(0, file);
                    Provider.of<JobModel>(context, listen: false)
                        .updateJob(widget.job);
                    setState(() {});
                  }
                },
                icon: Icon(
                  CupertinoIcons.camera_fill,
                  size: size.shortestSide / 6,
                ),
              ),
            );
          } else if (index == 1) {
            return Card(
              child: IconButton(
                onPressed: () async {
                  bool cond = await checkPermissionsCamera();
                  if (!cond) return;
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  String file = await saveImage(pickedFile);
                  if (file != '') {
                    widget.job.pathsImages.insert(0, file);
                    Provider.of<JobModel>(context, listen: false)
                        .updateJob(widget.job);
                    setState(() {});
                  }
                },
                icon: Icon(
                  Icons.image,
                  size: size.shortestSide / 6,
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () async {
                bool delete = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new ImageViewer(
                        job: widget.job,
                        pathToImage: widget.job.pathsImages[index - 2]),
                  ),
                );

                if (delete) {
                  setState(() {});
                }
              },
              child: Card(
                child: ClipRect(
                  child: Image.file(
                    File(widget.job.pathsImages[index - 2]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
