import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/sneaker_screen.dart';
import 'package:flex/ui/sneaker_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCollection extends StatefulWidget {
  @override
  _MyCollectionState createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  List<Sneaker> sneakers;

  @override
  Widget build(BuildContext context) {
    sneakers = Provider.of<List<Sneaker>>(context);
    return _buildCollectionList();
  }

  Widget _buildCollectionList() {
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
              sneakerInList: sneakers.contains(s),
            ),
      ),
    );
  }
}
