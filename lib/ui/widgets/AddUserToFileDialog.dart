import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:flutter/material.dart';

import '../../core/entities/UserEntity.dart';

class AddUserToFileDialog extends StatefulWidget {
  DocumentEntity document;
  final Function() reloadParent;

  AddUserToFileDialog(this.document, {required this.reloadParent, Key? key}) : super(key: key);

  @override
  AddUserToFileDialogState createState() => AddUserToFileDialogState();
}

class AddUserToFileDialogState extends State<AddUserToFileDialog> {
  final _usernameKey = GlobalKey<FormState>();
  List<UserEntity>? _users;
  bool _needRelogin = false;
  UserEntity? _selectedUser;

  @override
  void initState() {
    super.initState();
    ApiServices.getUsersDoNotHaveAccessToFile(widget.document.id.toString()).then((list){
      setState(() {
        if(list == null){
          _needRelogin = true;
        } else {
          _users = list;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_needRelogin){
      Navigator.of(context).pushReplacementNamed("/login");
    }



    return Container(
      child: AlertDialog(
        title: Text("Add user:"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              (_users == null || _users!.isEmpty) ? Container() : Form(
                  key: _usernameKey,
                  child: DropdownButton(
                    hint: const Text("Select users"),
                    value: _selectedUser,
                    items: _users!.map((UserEntity user) {
                      return DropdownMenuItem<UserEntity>(
                        value: user,
                        child: Text(user.name),
                      );
                    }).toList(),
                    onChanged: (UserEntity? value) {
                      setState(() {
                        _selectedUser = value;
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
            onPressed: (_selectedUser == null) ? null :() {
              ApiServices.addAccessToFile(_selectedUser!, widget.document).then((result){
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
      ),
    );
  }
}
