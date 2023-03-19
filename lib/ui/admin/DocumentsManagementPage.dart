import 'dart:typed_data';

import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/FilePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../core/services/ApiServices.dart';

class DocumentsManagementPage extends StatefulWidget {
  final PageController pageController;
  final Function(DocumentEntity) onVariableChanged;

  const DocumentsManagementPage({Key? key, required this.pageController,
                                required this.onVariableChanged}) : super(key: key);

  @override
  State<DocumentsManagementPage> createState() => _DocumentsManagementPageState();
}

class _DocumentsManagementPageState extends State<DocumentsManagementPage> {
  List<DocumentEntity>? _documents;
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');


  void _updateDocuments(){
    ApiServices.getAllFiles().then((list) {
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
    return Scaffold(
      body: (_documents == null) ?
              const Center(
                child: Text("Nothing here"),
              ) :
              Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _documents!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int index) {
                        DocumentEntity document = _documents![index];
                        return GestureDetector(
                          onTap: (){
                            widget.onVariableChanged(document);
                            widget.pageController.jumpToPage(3);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(document.fileName),
                              subtitle: Text(_formatter.format(document.createdAt)),
                              trailing: IconButton(
                                onPressed: () => _confirmDeleteFileDialog(context, document),
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          ),
                        );
                      })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Tuple2<String, Uint8List>? tuple = await FilePickerServices.pickFile();
          if(tuple != null){
            await ApiServices.postFile(tuple.item1, tuple.item2);
            _updateDocuments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteFileDialog(BuildContext context, DocumentEntity document){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Delete ${document.fileName}"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  ApiServices.deleteFile(document).then((value){
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
