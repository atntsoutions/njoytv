import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/utils/singleton.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final video record;

  YoutubePlayerPage({required this.record});

  @override
  YoutubePlayerPageState createState() => YoutubePlayerPageState();
}

class YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;

  bool isPlaying = false;

  String id = "";
  String tvname = "";
  String grp = "";

  @override
  void initState() {
    Wakelock.enable();
    id = widget.record.url;
    tvname = widget.record.name;
    grp = widget.record.group;
    initPlayer();
    super.initState();
  }

  void initPlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
      ),
    );
    isPlaying = true;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([]);
    if (!isPlaying) startPlayer();
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
          ShowCaption(grp),
          Expanded(child: showList(grp)),
        ],
      ),
    );
  }

  landscape() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: ShowVideo()),
        ],
      ),
    );
  }

  ShowLandscapeButton() {
    return Container();
  }

  YoutubePlayerBuilder ShowVideo() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        aspectRatio: 16 / 9,
      ),
      builder: (context, player) {
        return player;
      },
    );
  }

  void startPlayer() {
    _controller.load(id);
  }

  showList(String grp) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 1.0,
      mainAxisSpacing: 1.0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(1),
      children: Singleton.getSubList(Singleton.youTubeList, grp).map((item) {
        return GestureDetector(
          onTap: () {
            try {
              setState(() {
                id = item.url;
                tvname = item.name;
                grp = item.group;
                isPlaying = false;
              });
            } catch (e) {
              print(e);
            }
          },
          child: showCard(item.group, item.url,
              "https://img.youtube.com/vi/${item.url}/0.jpg"),
        );
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

  getYoutbueImage(String imgName) {
    try {
      return CachedNetworkImage(
        imageUrl: imgName,
        fit: BoxFit.fill,
        placeholder: (context, url) {
          return SizedBox(
            width: 10,
            height: 10,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } catch (e) {
      return Container();
    }
  }
}
