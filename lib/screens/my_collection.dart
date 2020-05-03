import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/loading.dart';
import 'package:flex/screens/sneaker_screen.dart';
import 'package:flex/services/auth.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/sneaker_tile.dart';
import 'package:flutter/material.dart';

class MyCollection extends StatefulWidget {
  @override
  _MyCollectionState createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: auth.getDisplayName(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            //TODO: return error ui
            return Container();
          } else {
            return _buildStreamBuilder(snapshot.data);
          }
        } else {
          return Column(
            children: <Widget>[
              Expanded(
                child: Loading(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStreamBuilder(String displayName) {
    return StreamBuilder<List<Sneaker>>(
      stream: DatabaseHelper(displayName: displayName).getSneakerCollection(),
      initialData: List<Sneaker>(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          //TODO: return error ui
          return Container();
        } else {
          return _buildCollectionList(snapshot.data);
        }
      },
    );
  }

  Widget _buildCollectionList(List<Sneaker> sneakers) {
    List<SneakerTile> sneakerTiles = _sneakerListToSneakerTileList(sneakers);

    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int i) {
              return sneakerTiles[i];
            },
            itemCount: sneakerTiles.length,
          ),
        ),
      ],
    );
  }

  List<SneakerTile> _sneakerListToSneakerTileList(List<Sneaker> sneakers) {
    List<SneakerTile> sneakerTiles = [];

    for (int i = 0; i < sneakers.length; i++) {
      sneakerTiles.add(
        SneakerTile(
          sneaker: sneakers[i],
          onTap: _goToSneakerScreen,
        ),
      );
    }

    return sneakerTiles;
  }

  void _goToSneakerScreen(Sneaker s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            SneakerScreen(
              sneaker: s,
            ),
      ),
    );
  }
}
