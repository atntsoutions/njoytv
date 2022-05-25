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
      //showHeading(),
      //SizedBox(height: 5),
      showBody(
          'NJoy TV Network, the first Indian-owned broadcasting station in the South Eastern United States, with operations in Atlanta, Georgia. Anchored on Channel 21, NJoy TV is a FREE Over the Air TV network spanning throughout the south for viewers to gain the ultimate watching experience, complete with educational programs, news coverage, sporting events, political debates, sitcoms, children’s specials, and so much more! NJoy TV also airs a number of ‘round the clock radio channels in multiple Asian languages.'),
      SizedBox(height: 10),
      showBody(
          'NJoy TV is on the cutting edge of broadcast technology and is available for free downloads via the new apps and on the OTT platform, which will enable a live as well as recorded telecast of each program. NJoy TV continues to be a family-focused station.'),
      SizedBox(height: 10),
      showBody(
          'NJoy TV is a digital cultural melting pot that will open eyes to the larger world around and create an unforgettable viewing experience, all right from the comfort of your living room.'),
      //SizedBox(height: 5),
      //showText('A voice of hope for those in despair'),
      //SizedBox(height: 5),
      //showText('A beacon of light guiding those in confusion'),
      //SizedBox(height: 5),
    ]);
  }

  showHeading() {
    return Text(
      'NJOY TV',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red[900],
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  showBody(String sText) {
    return Text(
      sText,
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
