import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meiju/comm/Config.dart';
import 'package:flutter_meiju/utils/Toast.dart';
import 'package:flutter_meiju/view/view_about.dart';
import 'package:flutter_meiju/view/view_drawer.dart';
import 'package:flutter_meiju/view/view_login.dart';
import 'package:flutter_meiju/view/view_movie.dart';
import 'package:flutter_meiju/view/view_mvinfo.dart';
import 'package:flutter_meiju/view/view_news.dart';
import 'package:flutter_meiju/view/view_register.dart';
import 'package:flutter_meiju/view/view_subs.dart';
import 'package:flutter_meiju/view/view_userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  Config _configuration = Config(themeType: ThemeType.light);

  void configurationUpdater(Config value) {
    setState(() {
      _configuration = value;
    });
  }

  int lastTime = 0;

  List<String> _title = [
    '我的订阅',
    '最新更新',
    '热播排行',
  ];
  List<Tab> _tabs = [];
  List<Widget> _page = [];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _getTabPage();
    _tabController =
        TabController(length: null != _tabs ? _tabs.length : 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      routes: {
        '/login': (context) => LoginPage(),
        '/about': (context) => AboutPage(),
        '/register': (context) => RegisterPage(),
        '/mvinfo': (context) => MvInfoPage(),
        '/userInfo': (context) => UserPage(),
      },
      home: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
                title: Text('极速追剧'),
                centerTitle: true,
                bottom: TabBar(
                  unselectedLabelColor: theme.indicatorColor,
                  labelColor: theme.indicatorColor,
                  tabs: _tabs,
                  controller: _tabController,
                )),
            drawer: MyDrawer(_configuration, configurationUpdater),
            body: TabBarView(
              controller: _tabController,
              children: _page,
            ),
          ),
          onWillPop: () {
            int newTime = DateTime.now().millisecondsSinceEpoch;
            int result = newTime - lastTime;
            lastTime = newTime;
            if (result > 2000) {
              Toast.show(context, '再按一次退出');
            } else {
              SystemNavigator.pop();
            }
            return null;
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _getTabPage() {
    for (int i = 0; i < _title.length; i++) {
      _tabs.add(Tab(
        text: _title[i],
      ));
    }
    //订阅页面
    _page.add(SubPage());
    //最新更新
    _page.add(MvNewsPage());
    //热播排行
    _page.add(RanksPage());
  }

  Future<Null> _loadConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeType themeType =
        ThemeType.values.elementAt(prefs.getInt('theme') ?? 0);

    configurationUpdater(_configuration.copyWith(themeType: themeType));
  }

  ThemeData get theme {
    switch (_configuration.themeType) {
      case ThemeType.brown:
        return ThemeData(
          primarySwatch: Colors.brown,
          brightness: Brightness.light,
          indicatorColor: Colors.white,
        );
      case ThemeType.light:
        return ThemeData(
          primaryColor: Colors.white,
          brightness: Brightness.light,
          indicatorColor: Colors.black,
        );
      case ThemeType.dark:
        return ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.white,
        );
      case ThemeType.blue:
        return ThemeData(
          indicatorColor: Colors.white,
          primarySwatch: Colors.blue,
        );
    }
    assert(_configuration.themeType != null);

    return null;
  }
}
