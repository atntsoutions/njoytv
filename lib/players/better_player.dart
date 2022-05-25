import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/utils/singleton.dart';
import 'package:wakelock/wakelock.dart';

class BetterPlayerPage extends StatefulWidget {
  final video record;
  BetterPlayerPage({required this.record});
  @override
  BetterPlayerPageState createState() => BetterPlayerPageState();
}

class BetterPlayerPageState extends State<BetterPlayerPage> {
  late BetterPlayerController _controller;
  bool bnew = true;
  String url = "";
  String tvname = "";
  String grp = "";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([]);
    url = widget.record.url;
    tvname = widget.record.name;
    grp = widget.record.group;

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      looping: false,
      autoPlay: true,
      fullScreenByDefault: false,
      autoDetectFullscreenAspectRatio: true,
      controlsConfiguration:
          BetterPlayerControlsConfiguration(showControls: false),
    );

    _controller = BetterPlayerController(betterPlayerConfiguration);

    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bnew) {
      bnew = false;
      stopPlayer();
      changeDatasource();
    }

    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait ? portrait() : landscape();
    });
  }

  portrait() {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(tvname, style: Theme.of(context).appBarTheme.titleTextStyle),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: ShowVideo()),
          ShowLandscapeButton(),
          ShowCaption(grp),
          Expanded(child: showList(grp)),
        ],
      ),
    );
  }

  ShowLandscapeButton() {
    return Container();
  }

  landscape() {
    return Scaffold(body: ShowVideo());
  }

  Widget ShowVideo() {
    return BetterPlayer(
      controller: _controller,
    );
  }

  void startPlayer(String? _url) async {
    setState(() {
      changeDatasource();
      bnew = false;
    });
    await _controller.play();
  }

  void changeDatasource() {
    BetterPlayerDataSource _dataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, url);
    _controller.setupDataSource(_dataSource);
  }

  void stopPlayer() async {
    try {
      await _controller.pause();
    } catch (e) {
      print('$e');
    }
  }

  void enterFullScreen() {
    try {
      _controller.enterFullScreen();
    } catch (e) {
      print('$e');
    }
  }

  ShowCaption(String _caption) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
          child: Text(
            _caption,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  showList(String grp) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 1.0,
      mainAxisSpacing: 1.0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(1),
      children:
          Singleton.getSubList(Singleton.liveStreamingList, grp).map((item) {
        return GestureDetector(
            onTap: () {
              try {
                setState(() {
                  url = item.url;
                  tvname = item.name;
                  grp = item.group;
                  bnew = true;
                });
              } catch (e) {
                print(e);
              }
            },
            child: showCard(item.group, item.url,
                '${Singleton.baseURL}/${item.type}/${item.logo}'));
      }).toList(),
    );
  }

  showCard(String stype, String url, String fileName) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3.0,
      child: CachedNetworkImage(
        imageUrl: "${fileName}",
        fit: BoxFit.fill,
        alignment: Alignment.center,
        placeholder: (context, url) {
          return SizedBox(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Wakelock.enable();
    super.dispose();
  }
}
