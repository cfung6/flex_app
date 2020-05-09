import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/sneaker_screen.dart';
import 'package:flex/ui/sneaker_tile.dart';
import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  final List<Sneaker> sneakers;
  final String displayName;
  final bool showMenu;
  final bool allContained;

  Collection({
    @required this.sneakers,
    @required this.displayName,
    this.showMenu = true,
    this.allContained = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCollectionList();
  }

  Widget _buildCollectionList() {
    List<SneakerTile> sneakerTiles = _sneakerListToSneakerTileList(sneakers);

    return Expanded(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int i) {
          return sneakerTiles[i];
        },
        itemCount: sneakerTiles.length,
      ),
    );
  }

  List<SneakerTile> _sneakerListToSneakerTileList(List<Sneaker> sneakers) {
    List<SneakerTile> sneakerTiles = [];

    for (int i = 0; i < sneakers.length; i++) {
      sneakerTiles.add(
        SneakerTile(
          sneaker: sneakers[i],
          onTap: _goToSneakerScreen,
          showMenu: showMenu,
          displayName: displayName,
          contains: allContained,
        ),
      );
    }

    return sneakerTiles;
  }

  void _goToSneakerScreen(BuildContext context, Sneaker s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SneakerScreen(
          sneaker: s,
          sneakerInList: sneakers.contains(s),
          displayName: displayName,
        ),
      ),
    );
  }
}
