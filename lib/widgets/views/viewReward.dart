import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/reward.dart';
import 'package:tollo2/providers/balance_model.dart';
import 'package:tollo2/providers/rewards_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/dialog.dart';
import 'package:tollo2/widgets/forms/newReward.dart';

class ViewReward extends StatefulWidget {
  const ViewReward({Key? key, required this.reward}) : super(key: key);
  final Reward reward;

  @override
  _ViewRewardState createState() => _ViewRewardState();
}

class _ViewRewardState extends State<ViewReward> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color cardColor = Theme.of(context).cardColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(CupertinoIcons.back),
                  ),
                  IconButton(
                    onPressed: () async {
                      bool edited = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewReward(
                            reward: widget.reward,
                          ),
                        ),
                      );
                      if (edited) {
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      Provider.of<RewardModel>(context, listen: false)
                          .deleteReward(widget.reward);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.trash_fill,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            CustomCard(
                widget: Center(
                  child: Text(
                    formatFull(widget.reward.note!.createdAt),
                  ),
                ),
                color: cardColor,
                size: size),
            CustomCard(
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.reward.price.toString()),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          int aux = await Provider.of<BalanceModel>(context,
                                  listen: false)
                              .current();
                          if (aux < widget.reward.price) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  title: Text(
                                      'You don\'t have enough Balance:only ${aux.toString()}'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      // passing true
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                    question:
                                        'Are you sure You want to buy this Reward');
                              },
                            ).then((exit) {
                              if (exit == null) return;
                              if (exit) {
                                Provider.of<BalanceModel>(context,
                                        listen: false)
                                    .subBalance(widget.reward.price);
                                Provider.of<RewardModel>(context, listen: false)
                                    .deleteReward(widget.reward);
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        icon: Icon(CupertinoIcons.shopping_cart))
                  ],
                ),
                color: cardColor,
                size: size),
            CustomCard(
                widget: Row(
                  children: [
                    Text(
                      widget.reward.note!.note,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                          decorationStyle: TextDecorationStyle.solid,
                          backgroundColor:
                              Theme.of(context).backgroundColor.withAlpha(10),
                          height: size.aspectRatio * 2.8,
                          decorationThickness: size.aspectRatio * 2),
                    ),
                  ],
                ),
                color: cardColor,
                size: size)
          ],
        ),
      ),
    );
  }
}
