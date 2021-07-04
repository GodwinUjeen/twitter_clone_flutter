import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Models/Activity.dart';
import 'package:twitter_clone/Models/UserModel.dart';
import 'package:twitter_clone/Services/DatabaseServices.dart';

class NotificationScreen extends StatefulWidget {
  final String currentUserId;

  const NotificationScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Activity> _activities = [];

  setupActivities() async {
    List<Activity> activities =
        await DatabaseServices.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  buildActivity(Activity activity) {
    return FutureBuilder(
      future: usersRef.doc(activity.fromUserId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        } else {
          UserModel user = UserModel.fromDoc(snapshot.data);
          print(user.name);
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: user.profilePicture.isEmpty
                      ? AssetImage('assets/placeholder.png') as ImageProvider
                      : NetworkImage(user.profilePicture),
                ),
                title: activity.follow == true
                    ? Text('${user.name} started following you')
                    : Text('${user.name} liked your tweet'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  color: KTweeterColor,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    print(_activities.length);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => setupActivities(),
        child: ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (BuildContext context, int index) {
            Activity activity = _activities[index];
            return buildActivity(activity);
          },
        ),
      ),
    );
  }
}
