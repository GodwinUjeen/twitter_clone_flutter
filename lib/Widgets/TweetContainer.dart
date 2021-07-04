import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Models/Tweet.dart';
import 'package:twitter_clone/Models/UserModel.dart';
import 'package:twitter_clone/Services/DatabaseServices.dart';

class TweetContainer extends StatefulWidget {
  final Tweet tweet;
  final UserModel author;
  final String? currentUserId;

  const TweetContainer(
      {Key? key, required this.tweet, required this.author, this.currentUserId})
      : super(key: key);

  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initTweetLikes() async {
    bool isLiked =
        await DatabaseServices.isLikeTweet(widget.currentUserId, widget.tweet);
   if(mounted){
     setState(() {
       _isLiked = isLiked;
     });
   }
  }

  likeTweet() {
    if (_isLiked) {
      DatabaseServices.unlikeTweet(widget.currentUserId, widget.tweet);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeTweet(widget.currentUserId, widget.tweet);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.tweet.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty
                    ? AssetImage('assets/placeholder.png') as ImageProvider
                    : NetworkImage(widget.author.profilePicture),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.author.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.tweet.text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          widget.tweet.image.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: KTweeterColor,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.tweet.image,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: likeTweet,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  Text(_likesCount.toString() + ' Likes')
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.repeat),
                  ),
                  Text(widget.tweet.retweets.toString() + ' Retweets')
                ],
              ),
              Text(
                widget.tweet.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
        ],
      ),
    );
  }
}
