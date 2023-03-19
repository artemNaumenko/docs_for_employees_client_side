import 'package:docs_for_employees/core/entities/DocumentEntity.dart';
import 'package:docs_for_employees/core/entities/UserEntity.dart';
import 'package:docs_for_employees/ui/admin/DocumentsManagementPage.dart';
import 'package:docs_for_employees/ui/admin/OneDocumemtManagementPage.dart';
import 'package:docs_for_employees/ui/admin/OneUserManagementPage.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UsersManagementPage.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final SideMenuController _sideMenuController = SideMenuController();
  final PageController _pageController = PageController();

  DocumentEntity? _document;
  UserEntity? _user;

  late List<SideMenuItem> items;
  int pageNumber = 0;

  @override
  void initState() {
    items = [
      SideMenuItem(
        priority: 0,
        title: 'User management',
        onTap: (number, controller) {
          controller.changePage(0);
          _pageController.jumpToPage(0);
        },
        icon: const Icon(Icons.supervisor_account),
      ),
      SideMenuItem(
        priority: 1,
        title: 'Document management',
        onTap: (number, controller) {
          controller.changePage(1);
          _pageController.jumpToPage(1);
          },
        icon: const Icon(Icons.file_copy),
      ),
      SideMenuItem(
        priority: 2,
        title: 'Log out',
        onTap: (number, controller){
          SharedPreferences.getInstance().then((prefs){
            prefs.clear();
            Navigator.pushReplacementNamed(context, '/login');
          });
        },
        icon: const Icon(Icons.exit_to_app),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: _sideMenuController,
            title: const Text('Admin'),
            onDisplayModeChanged: (mode) {
              print(mode);
            },
            // List of SideMenuItem to show them on SideMenu
            items: items,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                UsersManagementPage(
                  pageController: _pageController,
                  onVariableChanged: (userEntity){
                    setState(() {
                      _user = userEntity;
                    });
                  },
                ),
                DocumentsManagementPage(
                  pageController: _pageController,
                  onVariableChanged: (documentEntity){
                    setState(() {
                      _document = documentEntity;
                    });
                  },
                ),
                (_document == null) ? Container() : OneDocumentManagementPage(_document!),
                (_user == null) ? Container() : OneUserManagementPage(_user!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
