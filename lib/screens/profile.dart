import 'package:flutter/material.dart';
import 'package:community_connect/util.dart';

import 'package:community_connect/badge.dart';
import 'package:community_connect/util.dart';


class BadgeIcon extends StatelessWidget {
  BadgeIcon({Key? key, required this.id, this.selected = false}) : super(key: key);

  final String id;
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.9),
      decoration: BoxDecoration(
        color: selected ? Colors.greenAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: badges[id]!.assetImage,
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> ownedBadges = [];
  String activeBadge = "";

  @override
  Widget build(BuildContext context) {
    int followers = 2313434, following = 9223; // TODO: Get this from database with username.
    int posts = 98327, likes = 13233932838829;

    if (ownedBadges.isEmpty) {
      ownedBadges = ["bird", "landscape", "favorites1", "likes1"]; // TODO: Get badge IDs the user owns.
      activeBadge = "bird"; // TODO: Get the index of the badge the user current has equipped.
    }
    List<GestureDetector> badgeIcons = ownedBadges.map((e) =>
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => popup(context, "Change Profile Picture", "Equip \"${badges[e]!.name}\" badge as your profile picture?"),
          ).then((value) {
            if (value) {
              // TODO: Update database with currently equipped badge ID (e).
              setState(() {
                activeBadge = e;
              });
            }
          });
        },
        child: BadgeIcon(id: e, selected: e == activeBadge,)
      ),
    ).toList();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: badges[activeBadge]!.assetImage,
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.username,
                        style: const TextStyle(fontSize: 25),),
                      const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(formatNumber(followers),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              const Text("Followers"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(formatNumber(following),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              const Text("Following"),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.green[50],
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              children: badgeIcons,
            ),
          ),
        ),
        const Divider(height: 10, thickness: 3,),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(formatNumber(posts),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const Text("Posts"),
                ],
              ),
              Column(
                children: [
                  Text(formatNumber(likes),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const Text("Likes"),
                ],
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0),
            child: Scrollbar(
              child: GridView.builder(
                  itemCount: 17, // TODO: Get post count from database.
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(color: Colors.green[50],), // TODO: Fill with actual post images.
                    );
                  }
              ),
            ),
          ),
        ),
      ],
    );
  }
}
