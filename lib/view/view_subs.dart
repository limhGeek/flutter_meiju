import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/Movie.dart';
import 'package:flutter_meiju/bean/MvList.dart';
import 'package:flutter_meiju/bean/Token.dart';
import 'package:flutter_meiju/bean/User.dart';
import 'package:flutter_meiju/utils/Api.dart';
import 'package:flutter_meiju/utils/Http.dart';
import 'package:flutter_meiju/utils/SpUtils.dart';
import 'package:flutter_meiju/utils/Toast.dart';
import 'package:flutter_meiju/view/view_mvinfo.dart';

class SubPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubPage();
  }
}

class _SubPage extends State<SubPage> {
  bool isLogin = false;
  bool isNull = true;
  bool isPerformingRequest = false; // 是否有请求正在进行
  var _items = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getSubData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return _noLoginPage();
    } else {
      return _dataPage();
    }
  }

  Widget _noLoginPage() {
    //没有登录，无订阅数数据
    return InkWell(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_emoticon,
              size: 40,
            ),
            Text(
              '您还没登录，请先登录',
            )
          ],
        ),
      ),
      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
    );
  }

  Widget _dataPage() {
    //没有登录，无订阅数数据
    if (isNull) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 40,
            ),
            Text(
              '您还没有订阅数据',
            )
          ],
        ),
      );
    } else {
      return RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int position) {
              return _itemListView(position);
            },
            itemCount: _items.length,
            controller: _scrollController,
          ),
          onRefresh: () {
            _items.clear();
            _getSubData();
          });
    }
  }

  Widget _itemListView(int index) {
    if (null == this._items || this._items.isEmpty) {
      return null;
    }
    MvList movie = this._items[index];
    return GestureDetector(
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(6.0, 6.0, 10.0, 6.0),
                child: CachedNetworkImage(
                  imageUrl: movie.mvImg,
                  placeholder: Image.asset('images/default_head.jpg'),
                  errorWidget: Icon(Icons.error),
                  width: 100,
                  height: 140,
                ),
                alignment: FractionalOffset.center,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      null == movie.mvName ? "" : movie.mvName,
                      style: TextStyle(fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      movie.mvStatus,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                        null == movie.sourceTime
                            ? "更新时间："
                            : "更新时间：${movie.sourceTime}",
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new MvInfoPage(
            title: movie.mvName,
            mvImg: movie.mvImg,
            link: movie.mvLink,
            isSub: true,
          );
        }));
      },
    );
  }

  Future<Null> _getSubData() async {
    Token token = await SpUtils.getToken();
    print(token.toString());
    setState(() {
      this.isLogin = token == null ? false : true;
      print('isLogin=$isLogin');
    });

    Http.get(
        Api.URL_MVSUB_LIST,
        (data) {
          List mvlist = data.map((m) => MvList.fromJson(m)).toList();
          setState(() {
            if (null != mvlist) {
              isNull = false;
              this._items.addAll(mvlist);
            }
          });
        },
        header: {"Token": token.token},
        errorCallBack: (msg) {
          Toast.show(context, msg);
        });
  }
}
