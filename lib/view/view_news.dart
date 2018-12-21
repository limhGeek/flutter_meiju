import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/MvList.dart';
import 'package:flutter_meiju/utils/Api.dart';
import 'package:flutter_meiju/utils/Http.dart';
import 'package:flutter_meiju/utils/Toast.dart';
import 'package:flutter_meiju/view/view_mvinfo.dart';

class MvNewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MvNewsPage();
  }
}

class _MvNewsPage extends State<MvNewsPage> {
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false; // 是否有请求正在进行
  int pageNum = 1;
  var _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int position) {
            return _itemListView(position);
          },
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _items == null ? 0 : _items.length + 1,
          controller: _scrollController,
        ),
        onRefresh: () {
          pageNum = 1;
          _items.clear();
          _getMovies();
        },
        notificationPredicate: defaultScrollNotificationPredicate,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMovies();
      }
    });
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
            isSub: false,
          );
        }));
      },
    );
  }

  void _getMovies() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      Http.get(Api.URL_MVUPDATE, (data) {
        print('movies=$data');
        List mvlist = data.map((m) => MvList.fromJson(m)).toList();
        if (mvlist.isEmpty && _items.isNotEmpty) {
          print('数据加载完了');
          Toast.show(context, '已经加载完了');
        }
        setState(() {
          if (mvlist != null) {
            _items.addAll(mvlist);
            pageNum++;
          }
          isPerformingRequest = false;
        });
      }, errorCallBack: (msg) {
        Toast.show(context, msg);
      });
    }
  }
}
