import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/reward.dart';

class RewardModel extends ChangeNotifier {
  List<Reward> rewards = [];
  var rewardsBox = Hive.box<Reward>('rewards');

  RewardModel() {
    updateRewards();
  }

  void updateRewards() {
    rewards = rewardsBox.values.toList();
    notifyListeners();
  }

  addReward(Reward reward) async {
    await rewardsBox.add(reward);
    updateRewards();
  }

  deleteReward(Reward reward) async {
    await rewardsBox.delete(reward.key);
    updateRewards();
  }

  updateReward(Reward reward) async {
    await reward.save();
    updateRewards();
  }
}
