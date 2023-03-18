import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    ApiServices.getAllFiles().then((list) {
      setState(() {
        _documents = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_documents == null) ?
            const Center(
              child: Text("Nothing here"),
            ) :
            Container(
              child: Scrollbar(
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
                              subtitle: Text(document.createdAt.toString()),
                              trailing: IconButton(
                                onPressed: (){
                                  print("remove");
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          ),
                        );
                      })),
            );
  }
}
