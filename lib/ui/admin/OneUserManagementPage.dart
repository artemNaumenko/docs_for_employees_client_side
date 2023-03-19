import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/entities/UserEntity.dart';
import 'package:docs_for_employees/ui/widgets/AddFileToUserDialog.dart';
import 'package:docs_for_employees/ui/widgets/Link.dart';
import 'package:flutter/material.dart';

import '../../core/services/ApiServices.dart';

class OneUserManagementPage extends StatefulWidget {
  UserEntity _user;
  OneUserManagementPage(this._user, {Key? key}) : super(key: key){
    print("OneUserManagementPage");
  }

  @override
  State<OneUserManagementPage> createState() => _OneUserManagementPageState();
}

class _OneUserManagementPageState extends State<OneUserManagementPage> {
  List<DocumentEntity>? _documents;
  bool _needRelogin = false;

  void _updateDocuments(){
    ApiServices.getFilesUserHasAccess(widget._user.id.toString()).then((list){
      setState(() {
        _documents = list;
      });
    });
  }

  @override
  void initState() {
    print("OneUserManagementPage --- initState");
    super.initState();
    _updateDocuments();
  }

  @override
  Widget build(BuildContext context) {
    if(_needRelogin){
      Navigator.of(context).pushReplacementNamed("/login");
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8
              ),
              child: Text(widget._user.name, style: Theme.of(context).textTheme.titleLarge,)
            ),
            (_documents == null || _documents!.isEmpty) ? Expanded(
              child: Center(
                child: Text(
                  "${widget._user.name} does not have access to any file.",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ) : Scrollbar(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _documents!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    DocumentEntity document = _documents![index];
                    return Card(
                      child: ListTile(
                        title: Link(text: document.fileName, url: Uri.parse(document.link!),),
                        subtitle: (document.wasRead!)
                            ? const Text("has already been read.")
                            : const Text("has not yet been read."),
                        trailing: IconButton(
                          onPressed: () => _confirmAccessRevokeDialog(context, document, widget._user),
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
              builder: (context) => AddFileToUserDialog(
                widget._user,
                reloadParent: () => _updateDocuments(),
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
            title: Text("Revoke ${user.name}'s access to ${document.fileName}"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  ApiServices.revokeAccessToFile(document, user).then((value){
                    _updateDocuments();
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