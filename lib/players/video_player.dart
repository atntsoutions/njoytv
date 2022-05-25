import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/utils/singleton.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'package:loading_indicator/loading_indicator.dart';

class VideoPlayerPage extends StatefulWidget {
  final video record;
  VideoPlayerPage({required this.record});
  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
  String url = "";
  String tvname = "";
  String grp = "";

  bool bnew = true;
  bool bufferWindowShown = false;
  int bufferCounter = 0;
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture = null;

  @override
  void initState() {
    url = widget.record.url;
    tvname = widget.record.name;
    grp = widget.record.group;
    Wakelock.enable();
    super.initState();
  }

  playVideo() {
    try {
      bnew = false;
      _initializeVideoPlayerFuture = null;
      _controller = VideoPlayerController.network(url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.addListener(handleListner);
      _controller.play();
    } catch (e) {}
  }

  handleListner() {
    if (_controller.value.isBuffering) {
      if (!bufferWindowShown) {
        setState(() {
          bufferWindowShown = true;
        });
      }
    } else {
      if (bufferWindowShown) {
        setState(() {
          bufferWindowShown = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([]);
    if (bnew) {
      stopPlayer();
      playVideo();
    }

    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait ? portrait() : landscape();
    });
  }

  stopPlayer() async {
    try {
      _controller.dispose();
    } catch (e) {}
  }

  portrait() {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(tvname, style: Theme.of(context).appBarTheme.titleTextStyle),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            iconSize: 16,
            onPressed: () {
              // handle the press
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .30,
            child: ShowVideo(),
          ),
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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ShowVideo(),
      ),
    );
  }

  Widget ShowVideo() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                if (bufferWindowShown)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: LoadingIndicator(
                          indicatorType: Indicator.circleStrokeSpin,
                          colors: [
                            Colors.red,
                            Colors.green,
                            Colors.blue,
                            Colors.yellow,
                            Colors.orange,
                          ],
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        }
      },
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
