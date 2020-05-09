import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/sneaker_screen.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/search_bar.dart';
import 'package:flex/ui/sneaker_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

//public for search bar to access
class _SearchState extends State<Search> {
  String _query = "";
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Sneaker> _sneakers;
  String _displayName;

  Future<List<SneakerTile>> _sneakerTiles;

  @override
  void initState() {
    _controller.addListener(_updateQuery);
    _sneakerTiles = _constructList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _sneakers = Provider.of<List<Sneaker>>(context);
    _displayName = Provider.of<String>(context);

    return Column(
      children: <Widget>[
        SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          onSearchBarClear: _updateQuery,
        ),
        FutureBuilder<List<SneakerTile>>(
          future: _sneakerTiles,
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
                child: Loading(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults(List<SneakerTile> sneakerList) {
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

      int j = 0;
      for (int i = 0; i < count && j < displayLimit; i++) {
        Sneaker s = Sneaker.fromJSON(response.data, i);
        if (releasedOnly && s.bigImage == "") {
          continue;
        } else {
          sneakerList.add(
            SneakerTile(
              sneaker: s,
              onTap: _goToSneakerScreen,
              displayName: _displayName,
            ),
          );
          j++;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return sneakerList;
  }

  void _updateQuery() {
    setState(() {
      if (_query != _controller.text.trim()) {
        _query = _controller.text.trim();
        _sneakerTiles = _constructList();
      }
    });
  }

//  Future<void> _addSneakerToCurrentUserCollection(Sneaker s) async {
//    User user = await _auth.currentUser();
//    if (!user.userInfo.isAnonymous) {
//      DatabaseHelper db =
//      DatabaseHelper(displayName: user.userInfo.displayName);
//      await db.addSneakerToCollection(s);
//    } else {
//      //TODO: ask to register
//    }
//  }

  void _goToSneakerScreen(BuildContext context, Sneaker s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
        StreamProvider<List<Sneaker>>.value(
          value: DatabaseHelper(_displayName).getSneakerCollection(),
          child: SneakerScreen(
            sneaker: s,
            displayName: _displayName,
          ),
          initialData: List<Sneaker>(),
          catchError: (_, error) {
            log(error.toString());
            return List<Sneaker>();
          },
        ),
      ),
    );
  }
}
