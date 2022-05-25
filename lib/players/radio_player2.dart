import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/players/stopwatch.dart';
import 'package:njoytv/utils/colors.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:njoytv/utils/singleton.dart';
import 'package:wakelock/wakelock.dart';

class MyRadioPlayer2 extends StatefulWidget {
  final video record;
  MyRadioPlayer2({required this.record});
  @override
  MyRadioPlayer2State createState() => MyRadioPlayer2State();
}

class MyRadioPlayer2State extends State<MyRadioPlayer2> {
  late AssetsAudioPlayer _radioPlayer;
  bool isPlaying = false;
  bool bInit = false;

  String radioName = "";
  String url = "";
  String logo = "";
  String grp = "";

  List<String>? metadata;

  @override
  void initState() {
    Wakelock.enable();
    radioName = widget.record.name;
    url = widget.record.url;
    logo = widget.record.logo;
    grp = widget.record.group;
    initRadioPlayer();
    super.initState();
  }

  //'https://streaming.radio.co/s4f2cc35de/listen'

  void initRadioPlayer() {
    _radioPlayer = AssetsAudioPlayer();

    _radioPlayer.open(
      Audio.liveStream(
        url,
        metas: Metas(
          title: radioName,
          image:
              MetasImage.asset("assets/radio.png"), //can be MetasImage.network
        ),
      ),
      autoStart: true,
      showNotification: true,
      notificationSettings: NotificationSettings(
        nextEnabled: false,
        prevEnabled: false,
        playPauseEnabled: false,
        customStopAction: (player) {
          stopPlayer();
        },
      ),
    );
    bInit = true;

    setState(() {
      isPlaying = true;
    });
  }

  @override
  void dispose() {
    _radioPlayer.stop();
    Wakelock.disable();
    super.dispose();
  }

  void childActions(String _actions) async {
    if (_actions == "TOGGLEPLAY") {
      if (_radioPlayer.isPlaying.value)
        pausePlayer();
      else
        startPlayer();
    }
    if (_actions == "STOP") {
      stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!bInit) {
      stopPlayer();
      metadata = null;
      initRadioPlayer();
      startPlayer();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(radioName,
            style: Theme.of(context).appBarTheme.titleTextStyle),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              padding: EdgeInsets.only(top: 10.0),
              child: CachedNetworkImage(
                imageUrl: '${Singleton.baseURL}/LIVE-RADIO/$logo',
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
            ),
            SizedBox(height: 20),
            Divider(height: 1, color: AppColor.Divider_Color),
            SizedBox(height: 10),
            Text(
              metadata?[0] ?? '-',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 2),
            Text(
              metadata?[1] ?? '-',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 10),
            Divider(height: 1, color: AppColor.Divider_Color),
            SizedBox(height: 10),
            StopWatchTimerPage(childActions, isPlaying),
            SizedBox(height: 10),
            Divider(height: 1, color: AppColor.Divider_Color),
            ShowList(grp),
          ],
        ),
      ),
    );
  }

  void stopPlayer() async {
    try {
      await _radioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print('$e');
    }
  }

  void pausePlayer() async {
    try {
      await _radioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print('$e');
    }
  }

  void startPlayer() async {
    try {
      await _radioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('$e');
    }
  }

  ShowList(String grp) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 1.0,
      mainAxisSpacing: 1.0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(1),
      children: Singleton.getSubList(Singleton.liveRadioList, grp).map((item) {
        return GestureDetector(
          onTap: () {
            try {
              setState(() {
                radioName = item.name;
                url = item.url;
                logo = item.logo;
                grp = item.group;
                bInit = false;
              });
            } catch (e) {
              print(e);
            }
          },
          child: showCard(item.group, item.url,
              '${Singleton.baseURL}/${item.type}/${item.logo}'),
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
}
