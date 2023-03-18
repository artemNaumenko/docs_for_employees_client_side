import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:docs_for_employees/ui/widgets/Link.dart';
import 'package:flutter/material.dart';

import '../../core/entities/UserEntity.dart';
import '../widgets/AddUserToFileDialog.dart';

class OneDocumentManagementPage extends StatefulWidget {
  DocumentEntity _document;
  OneDocumentManagementPage(this._document, {Key? key}) : super(key: key);

  @override
  State<OneDocumentManagementPage> createState() => _OneDocumentManagementPageState();
}

class _OneDocumentManagementPageState extends State<OneDocumentManagementPage> {
  List<UserEntity>? _users;
  Uri? _uri;
  bool _needRelogin = false;

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
      body: (_uri == null) ? Container() : Column(
        children: [
          Link(
              url: _uri!,
              text: widget._document.fileName
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(widget._document.createdAt.toString()),
          ),
          (_users == null || _users!.isEmpty) ? Center(child: Text("Empty"),) : Scrollbar(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _users!.length,
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  UserEntity user = _users![index];
                  return Card(
                    child: ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.roleName),
                      trailing: const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.person_remove),
                      ),
                    ),
                  );
                }),
          ),
        ],
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
}
