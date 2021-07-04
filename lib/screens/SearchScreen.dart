import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Models/UserModel.dart';
import 'package:twitter_clone/Services/DatabaseServices.dart';
import 'package:twitter_clone/screens/ProfileScreen.dart';

class SearchScreen extends StatefulWidget {
  final String? currentUserId;

  const SearchScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? _users;
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance!
        .addPostFrameCallback(((_) => _searchController.clear()));
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search twitter...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white,
              onPressed: () {
                clearSearch();
              },
            ),
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                _users = DatabaseServices.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 200,
                  ),
                  Text(
                    'Search Twitter...',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(KTweeterColor),
                    ),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('No users found...'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel user =
                        UserModel.fromDoc(snapshot.data.docs[index]);
                    return buildUserTile(user);
                  },
                );
              },
            ),
    );
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/placeholder.png') as ImageProvider
            : NetworkImage(user.profilePicture),
      ),
      title: Text(user.name),
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: ProfileScreen(
              currentUserId: widget.currentUserId,
              visitedUserId: user.id,
            ),
            type: PageTransitionType.leftToRight,
          ),
        );
      },
    );
  }
}
