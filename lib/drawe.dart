import 'package:barCodeScanner/favourite.dart';
import 'package:barCodeScanner/history.dart';
import 'package:barCodeScanner/scanImage.dart';
import 'package:barCodeScanner/myQR.dart';
import 'package:flutter/material.dart';

import 'custom-navigator.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Drawer(
          child: SingleChildScrollView(
            child: Container( height: MediaQuery.of(context).size.height,     color: Colors.black,

              child: Column(
                children: [
                  listTile(title: 'Scan', iconData: Icons.scanner,function: () {
                    Navigator.of(context).pop();
            }),
                  Divider(),
                  listTile(title: 'Scan Image', iconData: Icons.camera_alt,function: () {
                    Navigator.of(context).pop();
                    CustomNavigator.navigateTo(context, ScanImage());
                  }),
                  Divider(),
                  listTile(
                      title: 'Favourite',
                      iconData: Icons.star_border,
                      function: () {
                        Navigator.of(context).pop();
                        CustomNavigator.navigateTo(context, Favourite());
                      }),
                  Divider(),
                  listTile(
                      title: 'History',
                      iconData: Icons.history,
                      function: () {
                        Navigator.of(context).pop();
                        CustomNavigator.navigateTo(context, History());
                      }),
                  Divider(),
                  listTile(
                      title: 'My QR',
                      iconData: Icons.person_pin,
                      function: () {
                        Navigator.of(context).pop();
                        CustomNavigator.navigateTo(context, MyQR());
                      }),
                  // Divider(),
                  // listTile(title: 'Create QR', iconData: Icons.edit),
                  // Divider(),
                  // listTile(title: 'Settings', iconData: Icons.settings),
                  // Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listTile({String title, IconData iconData, Function function}) {
    return Column(
      children: [
        ListTile(
          dense: true,
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),
          ),
          leading: Icon(iconData,color: Colors.white),
          onTap: function,
        ),Divider(height: 0,color: Colors.white24,)
      ],
    );
  }
}
