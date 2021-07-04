import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Models/Tweet.dart';
import 'package:twitter_clone/Models/UserModel.dart';
import 'package:twitter_clone/Services/DatabaseServices.dart';
import 'package:twitter_clone/Widgets/TweetContainer.dart';
import 'package:twitter_clone/screens/CreateTweetScreen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  const HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingTweets = [];
  bool _isLoading = false;

  buildTweets(Tweet tweet, UserModel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TweetContainer(
        tweet: tweet,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  showFollowingTweets(String currentUserId) {
    List<Widget> followingTweetsList = [];
    for (Tweet tweet in _followingTweets) {
      followingTweetsList.add(
        FutureBuilder(
          future: usersRef.doc(tweet.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildTweets(tweet, author);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
    }
    return followingTweetsList;
  }

  setupFollowingTweets() async {
    setState(() {
      _isLoading = true;
    });
    List followingTweets =
        await DatabaseServices.getHomeTweets(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingTweets = followingTweets;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Image.asset('assets/tweet.png'),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: CreateTweetScreen(
                    currentUserId: widget.currentUserId,
                  ),
                  type: PageTransitionType.leftToRight));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: Container(
          height: 40,
          child: Image.asset('assets/logo.png'),
        ),
        title: Text(
          'Home Screen',
          style: TextStyle(color: KTweeterColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => setupFollowingTweets(),
        child: ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: _followingTweets.isEmpty && _isLoading == false
                      ? [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'There is no New Tweets',
                            style: TextStyle(fontSize: 20),
                          ),
                        ]
                      : showFollowingTweets(widget.currentUserId),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
