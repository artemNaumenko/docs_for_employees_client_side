import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/entities/UserEntity.dart';
import 'package:docs_for_employees/ui/widgets/Link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/ApiServices.dart';

class OneUserManagementPage extends StatefulWidget {
  UserEntity _user;
  OneUserManagementPage(this._user, {Key? key}) : super(key: key);

  @override
  State<OneUserManagementPage> createState() => _OneDocumentManagementPageState();
}

class _OneDocumentManagementPageState extends State<OneUserManagementPage> {
  List<DocumentEntity>? _documents;
  bool _needRelogin = false;
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  void _updateDocuments(){
    ApiServices.getFilesUserHaveAccess(widget._user.id.toString()).then((list){
      setState(() {
        _documents = list;
      });
    });
  }

  @override
  void initState() {
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
              child: Text(widget._user.name)
            ),
            (_documents == null || _documents!.isEmpty) ? Expanded(
              child: Center(
                child: Text(
                  "qwe",
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
                        // subtitle: (user.hasAlreadyBeenRead!)
                        //     ? const Text("has already read.")
                        //     : Text("has not read yet."),
                        trailing: IconButton(
                            onPressed: () => null,
                          // onPressed: () => _confirmAccessRevokeDialog(context, widget._document, user),
                          icon: const Icon(Icons.person_remove),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (context) => AddUserToFileDialog(
      //           widget._document,
      //           reloadParent: () => _updateDocuments(),
      //         )
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
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