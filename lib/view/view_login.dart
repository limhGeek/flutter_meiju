import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meiju/utils/Api.dart';
import 'package:flutter_meiju/utils/Http.dart';
import 'package:flutter_meiju/utils/SpUtils.dart';
import 'package:flutter_meiju/utils/Toast.dart';
import 'package:flutter_meiju/widget/view_loading.dart';

import '../bean/Token.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  static const leftRightPadding = 30.0;
  static const topBottomPadding = 4.0;
  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  static const LOGO = "images/logo.png";
  bool _isLoading = false;
  int lastTime = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('登录'),
            ),
            body: ProgressDialog(
              loading: _isLoading,
              msg: '登录中...',
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: new Image.asset(
                      LOGO,
                      fit: BoxFit.fitWidth,
                    ),
                    width: 120.0,
                    height: 80.0,
                  ),
                  Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 20.0,
                        leftRightPadding, topBottomPadding),
                    child: new TextField(
                      controller: _userNameController,
                      decoration: new InputDecoration(hintText: "请输入用户名"),
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 20.0,
                        leftRightPadding, topBottomPadding),
                    child: new TextField(
                      controller: _userPassController,
                      decoration: new InputDecoration(hintText: "请输入密码"),
                      obscureText: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          child: Text(
                            '注册',
                          ),
                          padding: EdgeInsets.fromLTRB(
                              leftRightPadding, 10.0, leftRightPadding, 10.0),
                        ),
                        onTap: () => Navigator.pushNamed(context, "/register"),
                      ),
                      Expanded(
                        child: Text(''),
                        flex: 1,
                      ),
                      InkWell(
                        child: Container(
                          child: Text(
                            '忘记密码',
                          ),
                          padding: EdgeInsets.fromLTRB(
                              leftRightPadding, 10.0, leftRightPadding, 10.0),
                        ),
                        onTap: () {
                          //TODO 忘记密码
                        },
                      ),
                    ],
                  ),
                  new Container(
                    width: 360.0,
                    margin: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    padding: new EdgeInsets.fromLTRB(leftRightPadding,
                        topBottomPadding, leftRightPadding, topBottomPadding),
                    child: new Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 6.0,
                      child: new FlatButton(
                          onPressed: () {
                            _postLogin(_userNameController.text,
                                _userPassController.text);
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              '马上登录',
                              style: TextStyle(
                                  color: Theme.of(context).indicatorColor),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )),
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
        });
  }

  void _postLogin(String phone, String password) async {
    if (phone.isEmpty || password.isEmpty) {
      Toast.show(context, "手机号或密码不能为空");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, String> params = {'phone': phone, 'password': password};

    Http.post(
        Api.URL_LOGIN,
        (data) async {
          SpUtils.saveToken(json.encode(data));
          Token token = await SpUtils.getToken();
          _getUserInfo(token);
        },
        params: params,
        errorCallBack: (errorMsg) {
          Toast.show(context, errorMsg.toString());
          setState(() {
            _isLoading = false;
          });
        });
  }

  void _getUserInfo(Token token) {
    print('Token=' + token.toString());
    Http.get(
        Api.URL_USERINFO,
        (data) {
          setState(() {
            _isLoading = false;
          });
          SpUtils.saveUser(json.encode(data));
          SpUtils.getUser().then((user) {
            Navigator.pushReplacementNamed(context, "/");
            Toast.show(context, "登录成功");
          });
        },
        header: {'Token': token.token},
        errorCallBack: (errorMsg) {
          Toast.show(context, errorMsg.toString());
          setState(() {
            _isLoading = false;
          });
        });
  }
}
