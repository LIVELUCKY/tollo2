import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/widgets/views/viewJob.dart';

class BreadCrumbs extends StatelessWidget {
  const BreadCrumbs({Key? key, required this.jobs, required this.size})
      : super(key: key);
  final List<Job> jobs;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.longestSide / 20,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: jobs.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                width: size.shortestSide,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                        width: size.aspectRatio * 5,
                        color: Theme.of(context).primaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Fathers'),
                      Icon(Icons.arrow_back),
                    ],
                  ),
                ),
              );
            }

            final Job job = jobs[index - 1];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewJob(job: job),
                  ),
                );
              },
              child: SizedBox(
                width: size.shortestSide / 4,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: Color(job.categoryColor),
                      width: size.aspectRatio * 5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        job.note!.note,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
