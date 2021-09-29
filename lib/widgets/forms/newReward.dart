import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/models/reward.dart';
import 'package:tollo2/providers/rewards_model.dart';
import 'package:tollo2/widgets/fields/description_form_field.dart';
import 'package:tollo2/widgets/fields/points_form_field.dart';

class NewReward extends StatefulWidget {
  const NewReward({Key? key, this.reward}) : super(key: key);
  final Reward? reward;

  @override
  _NewRewardState createState() => _NewRewardState();
}

class _NewRewardState extends State<NewReward> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerDescription;
  late TextEditingController _controllerPoints;
  late Reward reward;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.reward != null) {
      reward = widget.reward!;
    } else {
      reward = Reward();
      reward.note = new Note();
    }
    _controllerDescription = new TextEditingController(text: reward.note!.note);
    _controllerPoints = new TextEditingController(
      text: reward.price == 0 ? '' : reward.price.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.gift,
                  size: size.shortestSide / 4,
                ),
              ),
              DescriptionFormField(controllerDescription: _controllerDescription),
              PointsFormField(controllerPoints: _controllerPoints),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      reward.note!.note = _controllerDescription.text;
                      reward.price = int.parse(_controllerPoints.text);
                      if (widget.reward != null) {
                        Provider.of<RewardModel>(context,listen: false).updateReward(reward);
                      } else {
                        Provider.of<RewardModel>(context,listen: false).addReward(reward);
                      }
                      Navigator.pop(context, true);
                    }
                  },
                  child: Icon(Icons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
