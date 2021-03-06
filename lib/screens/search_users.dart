import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/provider_models/follower_num.dart';
import 'package:flex/provider_models/following_list.dart';
import 'package:flex/provider_models/following_num.dart';
import 'package:flex/screens/user_screen.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

//Values that SearchUsers consumes:
//  -display name of the current user

//This screen is never pushed to navigation stack
//Parent: Home
class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  String _query = '';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _userDisplayName;

  Future<List<DocumentSnapshot>> _userList;

  @override
  void initState() {
    _userList = _getUsers();
    _controller.addListener(_updateQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userDisplayName = Provider.of<String>(context);

    return Column(
      children: <Widget>[
        SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          onSearchBarClear: _updateQuery,
        ),
        FutureBuilder<List<DocumentSnapshot>>(
          future: _userList,
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
        itemBuilder: (context, i) {
          String name = docs[i].data['display_name'];

          if (!(name == null || name.isEmpty)) {
            return ListTile(
              title: Text(
                name,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      MultiProvider(
                    child: UserScreen(
                      doc: docs[i],
                      currentUserDisplayName: _userDisplayName,
                    ),
                        providers: [
                          StreamProvider<List<Sneaker>>.value(
                            value: DatabaseHelper(_userDisplayName)
                                .getSneakerCollection(),
                            initialData: List<Sneaker>(),
                            catchError: (_, error) {
                              log(error.toString());
                              return List<Sneaker>();
                            },
                          ),
                          StreamProvider<FollowingList>.value(
                            value: DatabaseHelper(_userDisplayName)
                                .getFollowing(),
                            initialData: FollowingList(),
                            catchError: (_, error) {
                              log(error.toString());
                              return FollowingList();
                            },
                          ),
                          StreamProvider<FollowerNum>.value(
                            value: DatabaseHelper(name)
                                .getNumFollowers(),
                            initialData: FollowerNum(),
                            catchError: (_, error) {
                              log(error.toString());
                              return FollowerNum();
                            },
                          ),
                          StreamProvider<FollowingNum>.value(
                            value: DatabaseHelper(name)
                                .getNumFollowing(),
                            initialData: FollowingNum(),
                            catchError: (_, error) {
                              log(error.toString());
                              return FollowingNum();
                            },
                          ),
                        ],
                  ),
                ));
              },
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
