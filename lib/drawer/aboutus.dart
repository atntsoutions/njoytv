import 'package:flutter/material.dart';

class AboutusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: showListView());
  }

  showListView() {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Center(
        child: Image(
          image: AssetImage("assets/homelogo.png"),
          fit: BoxFit.contain,
          width: 100,
          height: 80,
        ),
      ),
      SizedBox(height: 5),
    ]);
  }

  showHeading() {
    return Text(
      'Goodness Television Channel is a devotional Family Channel with God’s own Signature…',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red[900],
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  showBody() {
    return Text(
      'This channel has a mission to enrich and empower the families conveying life-giving values of love and goodness. Programs are directed to binding the family in prayer, equipping parents to understand and guide the children and establishing a new generation on the firm foundation of a commitment to truth. Goodness Television telecasts programs in Malayalam and English. The Channel is committed to uphold the values of goodness and truth. We show in the Goodness TV what is needed for our heart’s transformation. ',
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Colors.cyan[900],
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
    );
  }

  showText(String sText) {
    return Text(
      sText,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.green[900],
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
