import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/entities/DocumentEntity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  List<DocumentEntity>? _documents;
  bool _isNewShowed = true;
  bool _needRelogin = false;


  @override
  void initState() {
    ApiServices.getAllAvailableFiles(false).then((list){
      setState(() {
        if(list == null){
          _needRelogin = true;
        }
        _documents = list;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_needRelogin){
      Navigator.pushReplacementNamed(context, '/login');
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (_documents == null || _documents!.isEmpty) ? const LinearProgressIndicator() : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: ElevatedButton(
                          onPressed: (_isNewShowed) ? null : () {
                            setState(() {
                              _isNewShowed = true;
                              _documents = null;
                            });
                            ApiServices.getAllAvailableFiles(false).then((list){
                              setState(() {
                                if(list == null){
                                  _needRelogin = true;
                                }
                                _documents = list;
                              });
                            });
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                Size(widthForWidgets/2-20, 50)
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
                              ),
                            ),
                          ),
                          child: Text("New",style: Theme.of(context).textTheme.titleLarge,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: ElevatedButton(
                          onPressed: (!_isNewShowed)? null :(){
                            setState(() {
                              _isNewShowed = false;
                              _documents = null;
                            });
                            ApiServices.getAllAvailableFiles(true).then((list){
                              setState(() {
                                if(list == null){
                                  _needRelogin = true;
                                }
                                _documents = list;
                              });
                            });
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                Size(widthForWidgets/2-20, 50)
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
                              ),
                            ),
                          ),
                          child: Text("Old", style: Theme.of(context).textTheme.titleLarge,)
                      ),
                    )
                  ],
                ),
              ),
              (_documents == null || _documents!.isEmpty) ?
                  const Text("Nothing here") :
                  Scrollbar(
                      child: SizedBox(
                        width: widthForWidgets,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _documents!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int index) {
                              DateFormat formatter = DateFormat('yyyy-MM-dd');
                              DocumentEntity document = _documents![index];
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(
                                      context,
                                      '/document',
                                      arguments: {
                                        "document": document,
                                        "needToShowCheckbox": _isNewShowed
                                      }).then((_){
                                    ApiServices.getAllAvailableFiles(false).then((list){
                                      setState(() {
                                        if(list == null){
                                          _needRelogin = true;
                                        }
                                        _documents = list;
                                      });
                                    });
                                  });
                                },
                                child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(formatter.format(document.createdAt)),
                                          const Divider(
                                            color: Color.fromRGBO(0, 0, 0, 0),
                                            height: 2,
                                          ),
                                          Text(document.fileName, style: Theme.of(context).textTheme.titleLarge,),
                                        ],
                                      ),
                                    )
                                ),
                              );
                            }
                        ),
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
