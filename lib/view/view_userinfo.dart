import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/User.dart';
import 'package:flutter_meiju/utils/SpUtils.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPage();
  }
}

class _UserPage extends State<UserPage> {
  User user;

  @override
  void initState() {
    super.initState();
    SpUtils.getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            flexibleSpace: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Text(''),
                  ),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    child: ClipOval(
                      child: Image.network(
                        null != user && user.imgUrl != null
                            ? user.imgUrl
                            : "https://avatar.csdn.net/F/5/4/3_yumi0629.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    null != user ? user.userName : "",
                    style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                        fontSize: 18.0),
                  ),
                  Text(
                    null != user ? user.phone : "",
                    style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            expandedHeight: 200.0,
          ),
        ],
      ),
    );
  }
}
