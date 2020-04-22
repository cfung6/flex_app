import 'dart:developer';

import 'package:flex/search_bar.dart';
import 'package:flex/sneaker.dart';
import 'package:dio/dio.dart';
import 'package:flex/sneaker_tile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  var _query = "";
  var _controller = TextEditingController();
  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(updateQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        textTheme: Theme.of(context).textTheme,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            //TODO: Implement menu
          },
        ),
        title: Text('FLEX'),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            controller: _controller,
            focusNode: _focusNode,
            searchPage: this,
          ),
          FutureBuilder(
            future: _constructList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  //TODO: error ui
                  return Container();
                }
                return _buildSearchResults(snapshot.data);
              } else {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void updateQuery() {
    setState(() {
      _query = _controller.text;
    });
  }

  Future<List<SneakerTile>> _constructList() async {
    bool releasedOnly = true;
    List<SneakerTile> sneakerList = [];
    int displayLimit = 80;
    int queryLimit = 80;
    final uri = "http://api.thesneakerdatabase.com/v1/sneakers";
    Dio dio = Dio();

    if (_query == "") {
      return sneakerList;
    }

    try {
      Response response = await dio
          .get(uri, queryParameters: {'title': _query, 'limit': queryLimit});
      int count = response.data['count'];
//      count = count < limit ? count : limit;

      log(response.data.toString());
      int j = 0;
      for (int i = 0; i < count && j < displayLimit; i++) {
        Sneaker s = Sneaker.fromJSON(response.data, i);
        if (releasedOnly && s.bigImage == "") {
          continue;
        } else {
          sneakerList.add(SneakerTile(sneaker: s));
          j++;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return sneakerList;
  }

  Widget _buildSearchResults(List<SneakerTile> sneakerList) {
    log('sneakerlist: ' + sneakerList.join(', '));
    return Expanded(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int i) {
          return sneakerList[i];
        },
        itemCount: sneakerList.length,
      ),
    );
  }
}
