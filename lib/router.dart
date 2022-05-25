import 'package:flutter/material.dart';
import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/drawer/aboutus.dart';
import 'package:njoytv/drawer/contact.dart';
import 'package:njoytv/drawer/feedback.dart';
import 'package:njoytv/drawer/platformservice.dart';
import 'package:njoytv/drawer/prayer.dart';
import 'package:njoytv/drawer/satelite.dart';
import 'package:njoytv/home/home.dart';
//import 'package:njoytv/players/better_player.dart';
import 'package:njoytv/players/radio_player2.dart';
import 'package:njoytv/players/video_player.dart';
import 'package:njoytv/players/youtube_player.dart';

import 'utils/strings.dart';

import 'home/home.dart';

class AppRouter {
  AppRouter() {}

  Route generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case DEFAULT_ROUTE:
        print('Default Route');
        return MaterialPageRoute(builder: (_) => HomePage());
      case ABOUTUS_ROUTE:
        return MaterialPageRoute(builder: (_) => AboutusPage());
      case CONTACT_ROUTE:
        return MaterialPageRoute(builder: (_) => ContactPage());
      case SATELITE_ROUTE:
        return MaterialPageRoute(builder: (_) => SatelitePage());
      case PLATFORMSERVICE_ROUTE:
        return MaterialPageRoute(builder: (_) => PlatFormServicePage());
      case PRAYER_ROUTE:
        return MaterialPageRoute(builder: (_) => PrayerPage());
      case FEEDBACK_ROUTE:
        return MaterialPageRoute(builder: (_) => FeedBackPage());
      case TV_ROUTE:
        video args = settings.arguments as video;
        return MaterialPageRoute(
            builder: (_) => VideoPlayerPage(
                  record: args,
                ));
      // case TV_ROUTE1:
      //   video args = settings.arguments as video;
      //   return MaterialPageRoute(
      //       builder: (_) => BetterPlayerPage(
      //             record: args,
      //           ));
      case RADIO_ROUTE:
        video args = settings.arguments as video;
        return MaterialPageRoute(
            builder: (_) => MyRadioPlayer2(
                  record: args,
                ));
      case YOUTUBE_ROUTE:
        video args = settings.arguments as video;
        return MaterialPageRoute(
          builder: (_) => YoutubePlayerPage(
            record: args,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
