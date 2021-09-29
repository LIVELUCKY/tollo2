import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/models/reward.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/widgets/views/viewReward.dart';

class RewardTile extends StatelessWidget {
  const RewardTile({Key? key, required this.reward, required this.size})
      : super(key: key);
  final Reward reward;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewReward(reward: reward),
        ),
      );
    },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: Theme.of(context).cardColor,
              width: size.aspectRatio * 5,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 6.0),
              child: Column(
                children: [
                  Text(
                    formatFull(reward.note!.createdAt),
                    textScaleFactor: 0.9,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(reward.price.toString()),
                    ],
                  ),
                  Divider(),
                  Text(reward.note!.note)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
