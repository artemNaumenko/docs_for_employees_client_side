import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddUserDialog extends StatefulWidget {
  final Function() updateParent;

  const AddUserDialog({required this.updateParent, Key? key}) : super(key: key);

  @override
  AddUserDialogState createState() => AddUserDialogState();
}

class AddUserDialogState extends State<AddUserDialog> {
  final _usernameKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  final _phoneFocusNode = FocusNode();

  AddUserDialogState() {
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _phoneController.text.isEmpty) {
        print("object");
        _phoneController.value = const TextEditingValue(text: "+380");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text("Add user:"),
        content: Column(
          children: [
            Form(
                key: _usernameKey,
                child: TextFormField(
                  controller: _usernameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: "Enter username",
                  ),
                  validator: (username) {
                    if (username == null || username.isEmpty) {
                      return "Username field can't be empty.";
                    }
                  },
                  onFieldSubmitted: (_) {
                    if (_usernameKey.currentState!.validate()) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    }
                  },
                )),
            Form(
              key: _phoneKey,
              child: TextFormField(
                focusNode: _phoneFocusNode,
                controller: _phoneController,
                maxLength: 13,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\+\d+'))],
                decoration: const InputDecoration(
                  labelText: "Enter user's phone number",
                ),
                validator: (phone) {
                  if (phone == null || phone.isEmpty) {
                    return "Phone field can't be empty.";
                  } else if (phone.length != 13) {
                    return "Phone number is very short.";
                  }
                },
                onFieldSubmitted: (_) {
                  if (_phoneKey.currentState!.validate() && _usernameKey.currentState!.validate()) {
                    ApiServices.addUserToSystem(_usernameController.text, _phoneController.text)
                        .then((statusCode) {
                      if (statusCode == 201) {
                        widget.updateParent();
                        Navigator.of(context).pop();
                      } else if (statusCode == 422) {
                        Navigator.of(context).pop();
                        _showAlert(context, "User already exists.");
                      } else if (statusCode == 401) {
                        Navigator.pushReplacementNamed(context, "/login");
                      } else {
                        Navigator.of(context).pop();
                        _showAlert(context, "Error.");
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_phoneKey.currentState!.validate() && _usernameKey.currentState!.validate()) {
                ApiServices.addUserToSystem(_usernameController.text, _phoneController.text)
                    .then((statusCode) {
                  if (statusCode == 201) {
                    widget.updateParent();
                    Navigator.of(context).pop();
                  } else if (statusCode == 422) {
                    Navigator.of(context).pop();
                    _showAlert(context, "User already exists.");
                  } else if (statusCode == 401) {
                    Navigator.pushReplacementNamed(context, "/login");
                  } else {
                    Navigator.of(context).pop();
                    _showAlert(context, "Error.");
                  }
                });
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }
}
