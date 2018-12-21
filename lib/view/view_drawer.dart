import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/User.dart';
import 'package:flutter_meiju/comm/Config.dart';
import 'package:flutter_meiju/utils/SpUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer(this.configuration, this.updater);

  final Config configuration;
  final ValueChanged<Config> updater;

  @override
  State<StatefulWidget> createState() {
    return _MyDrawer();
  }
}

class _MyDrawer extends State<MyDrawer> {
  User user;
  File _image;

  @override
  void initState() {
    super.initState();
    SpUtils.getUser().then((user) {
      setState(() {
        this.user = null == user ? null : user;
        print("USER=" + user.toString());
      });
    });
  }

  Future<Null> _handleThemeChange(ThemeType value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.updater != null) {
      prefs.setInt('theme', value.index);
      widget.updater(widget.configuration.copyWith(themeType: value));
    }
    Navigator.pop(context);
  }

  _showThemeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('切换主题'),
            children: <Widget>[
              SimpleDialogOption(
                child: ListTile(
                  leading: ClipOval(
                    child: Container(
                      constraints: BoxConstraints.expand(width: 40, height: 40),
                      color: Colors.white,
                      foregroundDecoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  title: Text('默认'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.light,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                ),
                onPressed: () => _handleThemeChange(ThemeType.light),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: ClipOval(
                    child: Container(
                      constraints: BoxConstraints.expand(width: 40, height: 40),
                      color: Colors.black,
                      foregroundDecoration: BoxDecoration(color: Colors.black),
                    ),
                  ),
                  title: Text('黑色'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.dark,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                ),
                onPressed: () => _handleThemeChange(ThemeType.dark),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: ClipOval(
                    child: Container(
                      constraints: BoxConstraints.expand(width: 40, height: 40),
                      color: Colors.brown,
                      foregroundDecoration: BoxDecoration(color: Colors.brown),
                    ),
                  ),
                  title: Text('棕色'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.brown,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                ),
                onPressed: () => _handleThemeChange(ThemeType.brown),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: ClipOval(
                    child: Container(
                      constraints: BoxConstraints.expand(width: 40, height: 40),
                      color: Colors.blue,
                      foregroundDecoration: BoxDecoration(color: Colors.blue),
                    ),
                  ),
                  title: Text('蓝色'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.blue,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                ),
                onPressed: () => _handleThemeChange(ThemeType.blue),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              null != user ? user.userName : "limh",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(null != user ? user.phone : "131****1234"),
            currentAccountPicture: GestureDetector(
              child: ClipOval(
                child: null != _image
                    ? Image.file(
                        _image,
                        fit: BoxFit.fill,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: "images/default_head.jpg",
                        fit: BoxFit.fitWidth,
                        image: null != user && null != user.imgUrl
                            ? user.imgUrl
                            : "",
                      ),
              ),
              onTap: ()=>Navigator.of(context).pushNamed('/userInfo'),
            ),
          ),
          ListTile(
            title: Text('切换主题'),
            leading: Icon(
              Icons.account_balance_wallet,
              size: 20,
            ),
            onTap: () {
              _showThemeDialog();
            },
          ),
          ListTile(
            title: Text('我要分享'),
            leading: Icon(
              Icons.share,
              size: 20,
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('关于我们'),
            leading: Icon(
              Icons.donut_small,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            title: Text('退出登录'),
            leading: Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            onTap: () {
              SpUtils.clearLogin();
              //关闭抽屉
              Navigator.pop(context);
              //打开登录页面
              Navigator.of(context).pushReplacementNamed("/login");
            },
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    print("选择的图片");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("选择的图片${image.path}");
    });
  }
}
