import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:community_connect/post.dart';

import '../data.dart';
import '../util.dart';


class PictureModeScreen extends StatefulWidget {
  PictureModeScreen({Key? key, required this.returnSurfing}) : super(key: key);

  Function returnSurfing;

  @override
  State<PictureModeScreen> createState() => _PictureModeScreenState();
}

class _PictureModeScreenState extends State<PictureModeScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  File? imageFile;

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      widget.returnSurfing();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      _getFromCamera();
    }
    MultiselectDropDown subjectDropdown = MultiselectDropDown(optionsList: subjectList, title: "Select Tags.");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          imageFile != null ?
          Image.file(imageFile!) :
          const Icon(Icons.camera_enhance_rounded),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Description",
                  ),
                  /* If we want to add a validator:
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description.";
                    }
                    return null;
                  },
                  */
                ),
                subjectDropdown,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 35.0),
            child: ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Post",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Future.delayed(Duration.zero, () async
                  {
                    Data.uploadPost('', _descriptionController.text, imageFile!, subjectDropdown.selectedItems).then((_) {
                      widget.returnSurfing();
                    });
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MultiselectDropDown extends StatefulWidget {
  final List<String> optionsList;
  final String title;
  List<String> selectedItems = [];

  MultiselectDropDown({Key? key, required this.optionsList, required this.title}) : super(key: key);

  @override
  State<MultiselectDropDown> createState() => _MultiselectDropDownState();
}

class _MultiselectDropDownState extends State<MultiselectDropDown> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: (Maybe) figure out how to hide keyboard when tapping outside of text field because this doesn't work.
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            if (value) {
              Future.delayed(const Duration(milliseconds: 220), () {
                Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 150));
              });
            }
          },
          // iconColor:
          title: Text(
            widget.selectedItems.isEmpty ? "Select" : widget.selectedItems.join(", "),
          ),
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.optionsList.length,
              itemBuilder: (BuildContext context, int index) {
                String item = widget.optionsList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Checkbox(
                          value: widget.selectedItems.contains(item),
                          onChanged: (value) {
                            if (widget.selectedItems.contains(item)) {
                              widget.selectedItems.remove(item);
                            } else {
                              widget.selectedItems.add(item);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Text(item),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
