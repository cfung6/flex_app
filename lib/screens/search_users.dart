import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  String _query = '';
  String _displayName;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<List<DocumentSnapshot>> _userList;

  @override
  void initState() {
    _userList = _getUsers();
    _controller.addListener(_updateQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _displayName = Provider.of<String>(context);

    return Column(
      children: <Widget>[
        SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          onSearchBarClear: _updateQuery,
        ),
        FutureBuilder<List<DocumentSnapshot>>(
          future: _getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                //TODO: error ui
                return Container();
              }
              return _buildUserSearchResults(snapshot.data);
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

  Widget _buildUserSearchResults(List<DocumentSnapshot> docs) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          String name = docs[index].data['display_name'];

          if (!(name == null || name.isEmpty)) {
            return ListTile(
              title: Text(
                name,
              ),
            );
          } else {
            return Container(
              height: 0.0,
              width: 0.0,
            );
          }
        },
        itemCount: docs.length,
      ),
    );
  }

  void _updateQuery() {
    setState(() {
      if (_query != _controller.text.trim()) {
        _query = _controller.text.trim();
        _userList = _getUsers();
      }
    });
  }

  Future<List<DocumentSnapshot>> _getUsers() async {
    if (_query.isEmpty) {
      return List<DocumentSnapshot>();
    }
    return await DatabaseHelper(null).getUsersContainingQuery(_query);
  }
}
