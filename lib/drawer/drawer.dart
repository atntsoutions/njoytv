import 'package:flutter/material.dart';
import 'package:njoytv/utils/colors.dart';
import 'package:njoytv/utils/strings.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          child: ListPage(),
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Center(
          child: Image(
            image: AssetImage('assets/homelogo.png'),
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
        ),

        Divider(height: 1, color: Colors.grey),
        // ListTile(
        //   leading: Icon(Icons.contact_page, color: AppColor.Drawer_Icon_Color),
        //   title: Text('About Us', style: Theme.of(context).textTheme.subtitle1),
        //   onTap: () {
        //     closeDrawer(context);
        //     Navigator.pushNamed(context, ABOUTUS_ROUTE);
        //   },
        // ),
        ListTile(
          leading: Icon(Icons.contact_page, color: AppColor.Drawer_Icon_Color),
          title:
              Text('Contact Us', style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            closeDrawer(context);
            Navigator.pushNamed(context, CONTACT_ROUTE);
          },
        ),
        ListTile(
          leading: Icon(Icons.close, color: AppColor.Drawer_Icon_Color),
          title: Text('Close', style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}

closeDrawer(BuildContext context) {
  Navigator.pop(context);
}
