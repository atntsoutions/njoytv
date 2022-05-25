import 'package:flutter/material.dart';
import 'package:njoytv/utils/functions.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact Us',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: getMainList());
  }

  getMainList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage("assets/homelogo.png"),
          fit: BoxFit.contain,
          width: 100,
          height: 80,
        ),
        SizedBox(height: 1),
        Text(
          'Time Channel Communications Pvt Ltd',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Neelima Building, 2nd Floor, 61/2574 A10',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          'Alapatt Cross Road,Kochi, Pin-682016',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          'Kerala, India',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: GestureDetector(
            onTap: () {
              launch_tel('tel:+914842406240');
            },
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('+91 484 2406240'),
              tileColor: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: GestureDetector(
            onTap: () {
              launch_tel('tel:+919778702654');
            },
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('+91 9778702654'),
              tileColor: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: GestureDetector(
            onTap: () {
              launch_email('mailto:info@timetv.in');
            },
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('info@tiemtv.in'),
              tileColor: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: GestureDetector(
            onTap: () {
              launch_site('https://www.timeiptv.in');
            },
            child: ListTile(
              leading: Icon(Icons.web),
              title: Text('www.timeiptv.in'),
              tileColor: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Feel Free To Contact Us',
            style: TextStyle(
              color: Colors.green[900],
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  getList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image(
            image: AssetImage("assets/homelogo.png"),
            fit: BoxFit.fill,
            height: 100,
            width: 80,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Goodness Media Private Limited',
            style: TextStyle(
              letterSpacing: 0.0,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text(
            'SRM Road, Ernakulam,',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        Center(
          child: Text(
            'Kerala, India',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Divider(height: 2.0, color: Colors.white),
        SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Icon(Icons.phone, color: Colors.amber[900]),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  launch_tel('tel:+914842406240');
                },
                child: Text(
                  '+91 484 2406240',
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 14.0,
                    decoration: TextDecoration.underline,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Icon(Icons.mobile_friendly_rounded, color: Colors.amber[900]),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  launch_tel('tel:+919778702654');
                },
                child: Text(
                  '+91 9778702654',
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Icon(Icons.email, color: Colors.amber[900]),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  launch_email('mailto:feedback@goodnesstv.in');
                },
                child: Text(
                  'feedback@goodnesstv.in',
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.amber[900],
              ),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  launch_email('mailto:info@goodnesstv.in');
                },
                child: Text(
                  'info@goodnesstv.in',
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Icon(
                Icons.web,
                color: Colors.amber[900],
              ),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  launch_site('https://www.goodnesstv.in');
                },
                child: Text(
                  'www.goodnesstv.in',
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Feel Free To Contact Us',
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
