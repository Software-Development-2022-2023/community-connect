import 'package:flutter/material.dart';
import 'package:community_connect/util.dart';


class BadgeIcon extends StatelessWidget {
  const BadgeIcon({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(2.9),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: null, // TODO: Use this.id to get badge image.
      ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    int followers = 2313434, following = 9223; // TODO: Get this from database with username.
    int posts = 98327, likes = 13233932838829;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: null, // TODO: Get image from database with username.
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(username,
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
            child: Wrap( // TODO: Fill with actual badges.
              children: [BadgeIcon(id: ""), BadgeIcon(id: ""), BadgeIcon(id: ""), BadgeIcon(id: ""), BadgeIcon(id: ""),],
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
