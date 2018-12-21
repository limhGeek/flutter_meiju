import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/Movie.dart';
import 'package:flutter_meiju/bean/MvList.dart';
import 'package:flutter_meiju/bean/Token.dart';
import 'package:flutter_meiju/utils/Api.dart';
import 'package:flutter_meiju/utils/Http.dart';
import 'package:flutter_meiju/utils/SpUtils.dart';
import 'package:flutter_meiju/utils/Toast.dart';
import 'package:flutter/services.dart';

class MvInfoPage extends StatefulWidget {
  final String title;
  final String link;
  final String mvImg;
  final bool isSub;

  MvInfoPage({this.title, this.link, this.mvImg, this.isSub});

  @override
  State<StatefulWidget> createState() {
    return _MvInfoPage();
  }
}

class _MvInfoPage extends State<MvInfoPage> {
  Movie movie;
  bool _isSub = false;
  var _items = [];

  @override
  void initState() {
    super.initState();

    _isSub = null == widget.isSub ? false : widget.isSub;
    _getMvInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () => Navigator.pop(context),
            ),
            title: Text(widget.title),
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.mvImg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _itemView(index)),
              itemExtent: 80.0)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isSub = !_isSub;
          _setSubMovie(widget.link, _isSub);
          setState(() {});
        },
        child: Icon(_isSub ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }

//Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Container(
//                margin: const EdgeInsets.fromLTRB(6.0, 6.0, 10.0, 6.0),
//                child: CachedNetworkImage(
//                  imageUrl: widget.mvImg,
//                  placeholder: Image.asset('images/default_head.jpg'),
//                  errorWidget: Icon(Icons.error),
//                  width: 100,
//                  height: 140,
//                ),
//                alignment: FractionalOffset.center,
//              ),
//              Expanded(
//                  child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  Text(
//                    movie != null ? movie.status : "状态：",
//                    style: TextStyle(fontSize: 16.0),
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 1,
//                  ),
//                  Text(movie != null ? movie.dao : "导演：",
//                      style: TextStyle(fontSize: 16.0),
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 1),
//                  Text(movie != null ? movie.actor : "主演：",
//                      style: TextStyle(fontSize: 16.0),
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 1),
//                  Text(
//                    movie != null && null != movie.type ? movie.type : "小分类：",
//                    style: TextStyle(fontSize: 18.0),
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 1,
//                  ),
//                ],
//              )),
//            ],
//          ),
//          Container(
//            child: Text(
//                null != movie && null != movie.info ? '简介：${movie.info}' : ""),
//          ),
//          Expanded(child: ListView.builder(
//              itemBuilder: (BuildContext context, int position) {
//            return _itemView(position);
//          }))
//        ],
//      )
  Widget _itemView(int position) {
    if (null == _items || _items.isEmpty) return null;
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Text(_items[position].sourceName)),
              FlatButton(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: _items[position].sourceLink));
                    Toast.show(context, '下载链接已复制，打开迅雷下载');
                  },
                  child: Text('复制')),
            ],
          ),
          Text(
            '资源：${_items[position].sourceType}',
            style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
          )
        ],
      ),
    );
  }

  Future<Null> _setSubMovie(String link, bool isSub) async {
    Token token = await SpUtils.getToken();
    Http.post(
        Api.URL_MVSUB_SET,
        (data) {
          Toast.show(context, "操作成功");
        },
        params: {
          "link": link.replaceAll('https://www.meijutt.com/content/', ""),
          "status": isSub ? "1" : "0"
        },
        header: {"Token": token.token},
        errorCallBack: (msg) {
          Toast.show(context, msg);
        });
  }

  Future<Null> _getMvInfo() async {
    Http.get(
        Api.URL_MVINFO1,
        (data) {
          Movie movie = Movie.fromJson(data);
          setState(() {
            this.movie = movie;
          });
        },
        params: {
          'link':
              widget.link.replaceFirst('https://www.meijutt.com/content/', '')
        },
        errorCallBack: (msg) {
          Toast.show(context, msg);
        });
    Http.get(
        Api.URL_MVINFO2,
        (data) {
          List mvlist = data.map((m) => MvList.fromJson(m)).toList();
          setState(() {
            if (null != mvlist) {
              this._items.addAll(mvlist);
            }
          });
        },
        params: {
          'link':
              widget.link.replaceFirst('https://www.meijutt.com/content/', '')
        },
        errorCallBack: (msg) {
          Toast.show(context, msg);
        });
  }
}
