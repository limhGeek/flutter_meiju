import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meiju/bean/Movie.dart';
import 'package:flutter_meiju/utils/Api.dart';
import 'package:flutter_meiju/utils/Http.dart';
import 'package:flutter_meiju/utils/Toast.dart';

class RanksPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<RanksPage> {
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false; // 是否有请求正在进行
  int pageNum = 1;
  var _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: GridView.count(
          crossAxisCount: 3,
          controller: _scrollController,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 0.7,
          padding: const EdgeInsets.all(8.0),
          children: _itemGridView(),
        ),
        onRefresh: () {
          pageNum = 1;
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

  List<Widget> _itemGridView() {
    List<Widget> grids = List();
    if (null == _items || _items.length == 0) return grids;
    for (int i = 0; i < _items.length; i++) {
      Movie movie = _items[i];
      Widget widget = Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: const FractionalOffset(0.9, 0.9),
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: movie.img,
                      placeholder: Image.asset('images/default_head.jpg'),
                      errorWidget: Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    width: 120,
                    height: 140,
                  ),
                  Text(
                    movie.score,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                movie.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      );
      grids.add(widget);
    }
    return grids;
  }

  void _getMovies() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      Http.get(
          Api.URL_MOVIES + '/$pageNum',
          (data) {
            print('movies=$data');
            List movie = data.map((m) => Movie.fromJson(m)).toList();
            if (movie.isEmpty && _items.isNotEmpty) {
              print('数据加载完了');
              Toast.show(context, '已经加载完了');
            }
            setState(() {
              if (movie != null) {
                _items.addAll(movie);
                pageNum++;
              }
              isPerformingRequest = false;
            });
          },
          errorCallBack: (msg) {
            Toast.show(context, msg);
          });
    }
  }
}
