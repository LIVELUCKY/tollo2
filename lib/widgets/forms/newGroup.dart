import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/services/textDirection.dart';
import 'package:tollo2/widgets/fields/color_picker_field.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({Key? key}) : super(key: key);

  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerDescription;
  late Color color = Theme.of(context).primaryColor;
  late Groups group;
  bool jobdesdir = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    group = new Groups();
    group.note = new Note();
    _controllerDescription = new TextEditingController(text: group.note!.note);
    _controllerDescription.addListener(() {
      setState(() {
        jobdesdir = isRTL(_controllerDescription.text);
      });
    });
  }

  void setColor(Color c) {
    color = c;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(CupertinoIcons.chevron_down),
                    )
                  ],
                ),
                TextFormField(
                  controller: _controllerDescription,
                  minLines: 2,
                  maxLines: null,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter a Group Description',
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  textAlign: jobdesdir ? TextAlign.right : TextAlign.left,
                ),
                ColorPickerFormField(
                    size: size, color: color, callback: setColor),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        group.categoryColor = color.value;
                        group.note!.note = _controllerDescription.text;
                        Provider.of<GroupModel>(context, listen: false)
                            .addGroup(group);
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(Icons.save),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
