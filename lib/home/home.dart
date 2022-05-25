import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:njoytv/drawer/drawer.dart';
import 'package:njoytv/theme.dart';
import 'package:njoytv/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/utils/functions.dart';
import 'package:njoytv/utils/singleton.dart';
import '../utils/strings.dart';

import 'package:njoytv/business/video_Controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoController _video_controller = new VideoController();
  late Future<bool> _checkServer;
  int _selectedIndex = 0;
  String streamType = "LIVE-TV";
  bool isDarkMode = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      streamType = index == 0
          ? "LIVE-TV"
          : index == 1
              ? "LIVE-RADIO"
              : "YOUTUBE";
    });
  }

  @override
  void initState() {
    print('Checking Server For Updates');

    this.ResetTheme();

    _checkServer = _video_controller.CheckServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      drawer: HomeDrawer(),
      body: FutureBuilder(
        future: _checkServer,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasData) return portrait();
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[900],
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Live TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: 'Live Radio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.youtube_searched_for),
            label: 'VOD',
          ),
        ],
      ),
    );
  }

  ResetTheme() async {
    isDarkMode = await ReadLocalStorage('darkmode', isDarkMode);
    Provider.of<ThemeSelector>(context, listen: false).setTheme(isDarkMode);
    // ReadLocalStorage('darkmode', isDarkMode).then((value) {
    //   Provider.of<ThemeSelector>(context, listen: false).setTheme(isDarkMode);
    // });
  }

  portrait() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          floating: true,
          expandedHeight: 60,

          elevation: 0,

          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              background: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  "assets/homelogo.png",
                ),
              )),
          //backgroundColor: AppColor.Page_Title_Background,
          //foregroundColor: AppColor.Page_Title_Color,
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.dark_mode_sharp),
              color: isDarkMode ? Colors.white : Colors.black,
              tooltip: 'Dark Mode',
              onPressed: () {
                // handle the press
                isDarkMode = !isDarkMode;
                SaveLocalStorage('darkmode', isDarkMode).then((value) {
                  Provider.of<ThemeSelector>(context, listen: false)
                      .setTheme(isDarkMode);
                });
              },
            ),
          ],
        ),
        showThemeList(),
        showVideos(),
        //showSilverSizedBox(3),
      ],
    );
  }

  showThemeList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(height: 3),
          showTheme(),
        ],
      ),
    );
  }

  showTheme() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            viewportFraction: 1,
            autoPlayCurve: Curves.easeIn,
            enlargeCenterPage: false,
          ),
          items: Singleton.themeList.map(
            (item) {
              return ClipRRect(
                //borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                child: Container(
                  padding: EdgeInsets.all(2),
                  child:
                      getImagePoster("${Singleton.baseURL}/THEME/${item.logo}"),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  showVideos() {
    return SliverList(
      delegate: SliverChildListDelegate(showStreaming()),
    );
  }

  List<video> getList() {
    return streamType == 'LIVE-TV'
        ? Singleton.liveStreamingList
        : streamType == 'LIVE-RADIO'
            ? Singleton.liveRadioList
            : Singleton.youTubeList;
  }

  showStreaming() {
    int count = Singleton.getGroupList(getList()).length;
    List<Widget> Items = [];
    String grp = "";
    for (int k = 0; k < count; k++) {
      grp = Singleton.getGroupList(getList())[k];
      Items.add(ShowCaption(grp));
      Items.add(showVideoList(grp, k));
    }
    return Items;
  }

  showVideoList(String grp, int ctr) {
    return Container(
      padding: EdgeInsets.all(1),
      child: Padding(
        padding: EdgeInsets.only(left: 0),
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            viewportFraction: .25,
            enlargeCenterPage: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            height: 90,
          ),
          items: Singleton.getSubList(getList(), grp).map(
            (item) {
              return GestureDetector(
                  onTap: () {
                    try {
                      if (item.type == "LIVE-TV") {
                        if (Singleton.videoplayer == 0)
                          Navigator.pushNamed(context, TV_ROUTE,
                              arguments: item);
                        if (Singleton.videoplayer == 1)
                          Navigator.pushNamed(context, TV_ROUTE1,
                              arguments: item);
                      } else if (item.type == "LIVE-RADIO") {
                        Navigator.pushNamed(context, RADIO_ROUTE,
                            arguments: item);
                      } else if (item.type == "YOUTUBE") {
                        Navigator.pushNamed(context, YOUTUBE_ROUTE,
                            arguments: item);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: showCard(
                      item.group,
                      item.url,
                      item.type == "YOUTUBE"
                          ? "https://img.youtube.com/vi/${item.url}/0.jpg"
                          : '${Singleton.baseURL}/${item.type}/${item.logo}'));
            },
          ).toList(),
        ),
      ),
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

  showSilverCaption(String _caption) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ShowCaption(_caption),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  showSilverSizedBox(double _height) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(height: _height),
        ],
      ),
    );
  }

  ShowCaption(String _caption) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
          child: Text(
            _caption,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  showListView() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          showListViewItems(),
        ],
      ),
    );
  }

  showListViewItems() {
    return ListView.custom(
      childrenDelegate: SliverChildBuilderDelegate(
        (buildContext, index) {
          return Card(
            child: showCard(
                Singleton.liveStreamingList[index].group,
                Singleton.liveStreamingList[index].url,
                '${Singleton.baseURL}/LIVE-TV/${Singleton.liveStreamingList[index].logo}'),
          );
        },
        childCount: Singleton.liveStreamingList.length,
      ),
      padding: EdgeInsets.all(1),
      shrinkWrap:
          true, //shrinkwrap false will cause memory leakage and reduce app performance
      reverse: false,
      scrollDirection: Axis.vertical,
      itemExtent: 100, // increase height or width depending on scrill direction
    );
  }

  showFeaturedVideoList() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      delegate: SliverChildListDelegate(
        Singleton.youtTubeFeauredList.map((item) {
          return GestureDetector(
            onTap: () {
              print(item.url);
              Navigator.pushNamed(context, YOUTUBE_ROUTE, arguments: item.url);
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Card(
                  margin: EdgeInsets.all(1),
                  color: AppColor.HomePage_Featued_Card_Background,
                  elevation: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: "https://img.youtube.com/vi/${item.url}/0.jpg",
                    fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return SizedBox(
                        width: 10,
                        height: 10,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  getImagePoster(String imgName) {
    try {
      return CachedNetworkImage(
        imageUrl: imgName,
        fit: BoxFit.fill,
        placeholder: (context, url) => LinearProgressIndicator(
          backgroundColor: Colors.black,
          color: Colors.black,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } catch (e) {
      return Container();
    }
  }

  getSocialMediaImage(String imgName) {
    try {
      return CachedNetworkImage(
        imageUrl: imgName,
        fit: BoxFit.fill,
        placeholder: (context, url) {
          return Center(child: CircularProgressIndicator());
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } catch (e) {
      return Container();
    }
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
