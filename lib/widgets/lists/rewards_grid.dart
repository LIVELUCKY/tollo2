import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/reward.dart';
import 'package:tollo2/providers/rewards_model.dart';
import 'package:tollo2/widgets/lists/rewards_tile.dart';

class RewardsGrid extends StatefulWidget {
  const RewardsGrid({Key? key}) : super(key: key);

  @override
  _RewardsGridState createState() => _RewardsGridState();
}

class _RewardsGridState extends State<RewardsGrid> {
  late List<Reward> rewards;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    rewards = Provider.of<RewardModel>(context).rewards;
    return GridView.builder(
      itemCount: rewards.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return RewardTile(reward: rewards[index], size: size);
      },
    );
  }
}
