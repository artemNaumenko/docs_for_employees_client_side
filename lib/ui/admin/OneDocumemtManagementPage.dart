import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:docs_for_employees/ui/widgets/Link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/entities/UserEntity.dart';
import '../widgets/AddUserToFileDialog.dart';

class OneDocumentManagementPage extends StatefulWidget {
  DocumentEntity _document;
  OneDocumentManagementPage(this._document, {Key? key}) : super(key: key){
    print("OneDocumentManagementPage");
  }

  @override
  State<OneDocumentManagementPage> createState() => _OneDocumentManagementPageState();
}

class _OneDocumentManagementPageState extends State<OneDocumentManagementPage> {
  List<UserEntity>? _users;
  Uri? _uri;
  bool _needRelogin = false;
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  void _updateUsers(){
    ApiServices.getUsersHaveAccessToFile(widget._document.id.toString()).then((list){
      setState(() {
        _users = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    ApiServices.getLinkOfFile(widget._document.fileName).then((url){
      setState(() {
        if(url == null){
          _needRelogin = true;
        } else {
          _uri = Uri.parse(url);
        }
      });
    });

    _updateUsers();
  }

  @override
  Widget build(BuildContext context) {
    if(_needRelogin){
      Navigator.of(context).pushReplacementNamed("/login");
    }

    return Scaffold(
      body: (_uri == null) ? Container() : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8
              ),
              child: Link(
                  url: _uri!,
                  text: widget._document.fileName
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(_formatter.format(widget._document.createdAt)),
            ),
            (_users == null || _users!.isEmpty) ? Expanded(
              child: Center(
                child: Text(
                    "None of the users have access",
                    style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ) : Scrollbar(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _users!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    UserEntity user = _users![index];
                    return Card(
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: (user.hasAlreadyBeenRead!)
                            ? const Text("has already read.")
                            : Text("has not read yet."),
                        trailing: IconButton(
                          onPressed: () => _confirmAccessRevokeDialog(context, widget._document, user),
                          icon: const Icon(Icons.person_remove),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AddUserToFileDialog(
                widget._document,
                reloadParent: () => _updateUsers(),
              )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmAccessRevokeDialog(BuildContext context, DocumentEntity document,UserEntity user){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Revoke ${user.name} access"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  ApiServices.revokeAccessToFile(document, user).then((value){
                    _updateUsers();
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("Confirm"),
              )
            ],
          );
        }
    );
  }
}
