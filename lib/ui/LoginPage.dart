import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool _isAdmin = false;

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

  void _login(){
    String? password;
    if(_controller2.text.isEmpty){
      password = null;
    } else {
      password = _controller2.text;
    }

    ApiServices.login(_controller.text, password).then((resStatusCode){
      if(resStatusCode == 201){
        if(password == null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/admin/home');
        }
      } else if(resStatusCode == 301){//ADMIN
        setState((){
          _isAdmin = true;
        });
      } else if(resStatusCode == 500){
        _showAlert(context, "Access denied.");
      } else {
        _showAlert(context, "Try soon.");
      }
    });
  }


  @override
  void initState() {
    _controller.value = const TextEditingValue(text: "+380");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: widthForWidgets,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField( // phone
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter your phone number",
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\+\d+'))],
                        style: Theme.of(context).textTheme.titleLarge,
                        readOnly: (_isAdmin) ? true : false,
                        maxLength: 13,
                        onChanged: (str){
                          if(str.length < 4){
                            _controller.value = const TextEditingValue(text: "+380");
                          } else if(str.substring(0, 4) != "+380"){
                            _controller.value = const TextEditingValue(text: "+380");
                          }
                        },
                        onFieldSubmitted: (number) {
                          ApiServices.login(number, null).then((resStatusCode){
                            if(resStatusCode == 201){ //USER
                              Navigator.pushReplacementNamed(context, '/home');
                            } else if(resStatusCode == 301){//ADMIN
                              setState((){
                                _isAdmin = true;
                              });
                            } else if(resStatusCode == 500){
                              _showAlert(context, "Access denied.");
                            } else {
                              _showAlert(context, "Try soon.");
                            }
                          });
                        },
                      ),
                    ),

                  ],
                ),
                const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0),
                ),
                (!_isAdmin) ? Container() :
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField( // password
                                controller: _controller2,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Enter your password",
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                                readOnly: false,
                                maxLength: 16,
                                onFieldSubmitted: (password) {
                                  ApiServices.login(_controller.text, password).then((resStatusCode){
                                    if(resStatusCode == 201){ //USER
                                      Navigator.pushReplacementNamed(context, '/admin/home');
                                    } else if(resStatusCode == 301){//need password
                                      setState((){
                                        _isAdmin = true;
                                      });
                                    } else if(resStatusCode == 500){
                                      _showAlert(context, "Access denied.");
                                    } else {
                                      _showAlert(context, "Try soon.");
                                    }
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                        const Divider(
                          color: Color.fromRGBO(0, 0, 0, 0),
                        ),
                      ],
                    ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                          child: Text("Login", style: Theme.of(context).textTheme.titleMedium),
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}