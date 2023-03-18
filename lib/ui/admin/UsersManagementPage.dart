import 'package:docs_for_employees/core/services/ApiServices.dart';
import 'package:docs_for_employees/ui/widgets/AddUserDialog.dart';
import 'package:flutter/material.dart';

import '../../core/entities/UserEntity.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({Key? key}) : super(key: key);

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  List<UserEntity>? _users;

  @override
  void initState() {
    super.initState();
    ApiServices.getAllUsersExceptMe().then((list) {
      setState(() {
        _users = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_users == null)
          ? const Center(
              child: Text("UserManagement"),
            )
          : Scrollbar(
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
                        trailing: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.person_remove),
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
          return const AddUserDialog();
        });
  }
}
