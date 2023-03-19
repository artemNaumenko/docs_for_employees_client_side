import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:flutter/material.dart';

import '../../core/entities/UserEntity.dart';

class AddFileToUserDialog extends StatefulWidget {
  UserEntity user;
  final Function() reloadParent;

  AddFileToUserDialog(this.user, {required this.reloadParent, Key? key}) : super(key: key);

  @override
  AddFileToUserDialogState createState() => AddFileToUserDialogState();
}

class AddFileToUserDialogState extends State<AddFileToUserDialog> {
  final _usernameKey = GlobalKey<FormState>();
  List<DocumentEntity>? _documents;
  bool _needRelogin = false;
  DocumentEntity? _selectedFile;

  @override
  void initState() {
    super.initState();
    ApiServices.getFilesUserDoesNotHaveAccess(widget.user.id.toString()).then((list){
      setState(() {
        if(list == null){
          _needRelogin = true;
        } else {
          _documents = list;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_needRelogin){
      Navigator.of(context).pushReplacementNamed("/login");
    }

    return AlertDialog(
      title: const Text("Add access to file:"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            (_documents == null || _documents!.isEmpty) ? Container() : Form(
                key: _usernameKey,
                child: DropdownButton(
                  hint: const Text("Select file"),
                  value: _selectedFile,
                  items: _documents!.map((DocumentEntity document) {
                    return DropdownMenuItem<DocumentEntity>(
                      value: document,
                      child: Text(document.fileName),
                    );
                  }).toList(),
                  onChanged: (DocumentEntity? value) {
                    setState(() {
                      _selectedFile = value;
                    });
                  },
                )
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: (_selectedFile == null) ? null :() {
            ApiServices.addAccessToFile(widget.user, _selectedFile!).then((result){
              if(result == null || !result){
                setState(() {
                  _needRelogin = true;
                });
              } else {
                widget.reloadParent();
                Navigator.of(context).pop();
              }
            });
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
