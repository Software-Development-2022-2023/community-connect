import 'package:flutter/material.dart';
import 'package:community_connect/util.dart';

import 'package:community_connect/badge.dart';
import 'package:community_connect/util.dart';

import '../data.dart';


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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Data.getUserData(''),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot)
      {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          List<GestureDetector> ownedBadges = [];
          for (String e in snapshot.data!['badges']) {
            ownedBadges.add(GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => popup(context, "Change Profile Picture", "Equip \"${badges[e]!.name}\" badge as your profile picture?"),
                  ).then((value) {
                    if (value) {
                      Data.equipBadge(badges[e]!).then((_) {
                        setState(() {});
                      });
                    }
                  });
                },
                child: BadgeIcon(id: e, selected: e == snapshot.data!['equippedBadge'],)
            ));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: badges.containsKey(snapshot.data!['equippedBadge']) ? badges[snapshot.data!['equippedBadge']]!.assetImage : null,
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
                                    Text(formatNumber(snapshot.data!['followers']),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),),
                                    const Text("Followers"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(formatNumber(snapshot.data!['followedAccounts'].length),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),),
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
                    children: ownedBadges,
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
                        Text(formatNumber(snapshot.data!['posts'].length),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),),
                        const Text("Posts"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(formatNumber(snapshot.data!['likes']),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),),
                        const Text("Likes"),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, left: 10.0, bottom: 10.0),
                  child: Scrollbar(
                    child: GridView.builder(
                        itemCount: snapshot.data!['posts'].length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              color: Colors.green[50],
                              child: FutureBuilder(
                                future: Data.getDownloadUrl(snapshot.data!['posts'][index]),
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    return Image.network(
                                      snapshot.data!,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                }
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
