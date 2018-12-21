import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AboutPage();
  }
}

class _AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '关于我们',
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '    数据来源于美剧天堂,每天定时获取最新连载资源下载链接',
            style: TextStyle(fontSize: 18.0),
          )),
    );
  }
}
