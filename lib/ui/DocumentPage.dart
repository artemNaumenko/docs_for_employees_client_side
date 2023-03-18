import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:docs_for_employees/ui/widgets/Link.dart';
import 'package:flutter/material.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  DocumentEntity? _document;
  Uri? _url;
  bool _confirmation = false;
  bool _wasResponseSent = false;
  bool? _needToShowCheckbox;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _document =  args["document"] as DocumentEntity?;
    _needToShowCheckbox = args["needToShowCheckbox"] as bool?;

    if(_url == null && _document != null){
      ApiServices.getLinkOfFile(_document!.fileName).then((link){
        if(link ==  null){
          Navigator.pushReplacementNamed(context, '/login');
        } else if(link.isEmpty){
          _showAlert(context, "Error, please try soon.");
        } else {
          setState(() {
            _url = Uri.tryParse(link);
          });
        }
      });
    }

    final double width = MediaQuery.of(context).size.width;
    final double screenDensity = MediaQuery.of(context).devicePixelRatio;
    double widthForWidgets;

    if(screenDensity > 1.8){ //mobile ratio
      widthForWidgets = width;
    } else { // monitor
      widthForWidgets = width/2;
    }


    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: (_url == null) ? const LinearProgressIndicator() : Container(),
            ),
            Expanded(
              child: Center(
                child: (_url == null) ? Container() :
                      SizedBox(
                        width: widthForWidgets,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Link(
                                url: _url!,
                                text: _document!.fileName
                            ),
                            const Divider(
                              color: Color.fromRGBO(0, 0, 0, 0),
                            ),
                            (!_needToShowCheckbox!) ? Container() : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _confirmation,
                                        onChanged: (_wasResponseSent) ? null : (value){
                                          setState(() {
                                            _confirmation = !_confirmation;
                                          });
                                        },
                                    ),
                                    GestureDetector(
                                        onTap: (_wasResponseSent) ? null : (){
                                          setState((){
                                            _confirmation = !_confirmation;
                                          });
                                        },
                                        child: Text(
                                          "I read this document.",
                                          style: Theme.of(context).textTheme.titleMedium,
                                        )
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: (!_confirmation || _wasResponseSent) ? null : (){
                                      ApiServices.markFileAsRead(_document!.fileName).then((value){
                                        if(value == null){
                                          Navigator.pushReplacementNamed(context, '/login');
                                        } else if(value){
                                          setState(() {
                                            _wasResponseSent = true;
                                          });
                                        }
                                      });
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Send response",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String msg){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Failure"),
            content: Text(msg),
            actions: [
              ElevatedButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text("Close"),
              )
            ],
          );
        });
  }
}
