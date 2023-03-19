import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:docs_for_employees/ui/widgets/AddUserDialog.dart';
import 'package:flutter/material.dart';

import '../../core/entities/UserEntity.dart';

class UsersManagementPage extends StatefulWidget {
  final PageController pageController;
  final Function(UserEntity) onVariableChanged;

  const UsersManagementPage({Key? key, required this.pageController,
                              required this.onVariableChanged}) : super(key: key);

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  List<UserEntity>? _users;

  void _updateUsers(){
    ApiServices.getAllUsersExceptMe().then((list) {
      setState(() {
        _users = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_users == null || _users!.isEmpty)
          ? Center(
              child: Text("No user exists yet.", style: Theme.of(context).textTheme.titleLarge,),
            )
          : Scrollbar(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _users!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    UserEntity user = _users![index];
                    return GestureDetector(
                      onTap: (){
                        widget.onVariableChanged(user);
                        widget.pageController.jumpToPage(2);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.roleName),
                          trailing: IconButton(
                            onPressed: () => _confirmDeleteUserDialog(context, user),
                            icon: const Icon(Icons.person_remove),
                          ),
                        ),
                      ),
                    );
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addUserDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addUserDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AddUserDialog(
            updateParent: () => _updateUsers(),
          );
        });
  }

  void _confirmDeleteUserDialog(BuildContext context, UserEntity user){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Delete ${user.name}"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  ApiServices.deleteUser(user).then((value){
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
