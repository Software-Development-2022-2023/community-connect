import 'package:community_connect/util.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:community_connect/data.dart';

import 'package:community_connect/post.dart';
import 'package:community_connect/badge.dart';

import 'package:community_connect/screens/leaderboard.dart';
import 'package:community_connect/screens/marketplace.dart';
import 'package:community_connect/screens/profile.dart';
import 'package:community_connect/screens/picturemode.dart';

const List<String> sortBy = <String>[
  "Most recent",
  "Oldest",
  "Most liked",
  "Least liked"
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getBadges();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Community Connect",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      home: const ModeNavigation(),
    );
  }
}

class ModeNavigation extends StatefulWidget {
  const ModeNavigation({super.key});

  @override
  State<ModeNavigation> createState() => _ModeNavigationState();
}

class _ModeNavigationState extends State<ModeNavigation> {
  bool _pictureMode = false;
  int _selectedDrawerIndex = -1;
  String username = "";
  String sort = sortBy.first;
  List<String> subjectChoices = List<String>.empty(growable: true);
  String enteredUsername = "";

  void _onModeTapped() {
    setState(() {
      _pictureMode = !_pictureMode;
    });
  }

  void _selectDrawerIndex(int index, [bool closeDrawer = true]) {
    if (closeDrawer && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    getUsername().then((value) {
      if (value != null) {
        setState(() {
          username = value;
        });
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Account creation",
                  textAlign: TextAlign.left,
                ),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter username",
                        textAlign: TextAlign.left,
                      ),
                      TextField(
                        onChanged: (value) {
                          enteredUsername = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter username...",
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      TextButton(
                          child: Text(
                            "Create account",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onPressed: () {
                            // Attempt account creation
                            Data.createAccount(enteredUsername).then((value) {
                              if (!value) {
                                return;
                              } else {
                                setUsername(enteredUsername);

                                setState(() {
                                  username = enteredUsername;

                                  Navigator.of(context).pop();
                                });
                              }
                            });
                          }),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? screen;
    switch (_selectedDrawerIndex) {
      case 0: // Profile.
        screen = ProfileScreen(
          username: username,
        );
        break;
      case 1: // Leaderboard.
        screen = const LeaderboardScreen();
        break;
      case 2: // My Posts.
        // Probably just the normal posts screen but with only the user's posts.
        break;
      case 3: // Marketplace.
        screen = const MarketplaceScreen();
        break;
    }

    Container switchModeButton = Container(
      height: 200,
      width: 80,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: _onModeTapped,
          child: const Icon(Icons.swap_horiz),
        ),
      ),
    );

    if (!_pictureMode) {
      final GlobalKey<ScaffoldState> _key = GlobalKey();
      // Surfing Mode.
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
              title: const Text("Community Connect"),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    _selectDrawerIndex(-1, false);
                  },
                  icon: const Icon(Icons.home))),
          floatingActionButton: switchModeButton,
          drawer: PostFilter(
            onApply: (String sortVal, List<String> subjects) {
              setState(() {
                sort = sortVal;
                subjectChoices = subjects;
              });
            },
            sortVal: sort,
            subjectChoices: subjectChoices,
          ),
          body: (screen != null)
              ? screen
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Search for a term")),
                      TextButton(
                        child: Text("Add filters..."),
                        onPressed: () => _key.currentState!.openDrawer(),
                      ),
                      PostDisplay(
                        sortVal: sort,
                        subjects: subjectChoices,
                      ),
                    ],
                  ),
                ),
          endDrawer: Drawer(
            child: ListView(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: Data.getUserData(''),
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (!snapshot.hasData) {
                            return CircleAvatar(
                              radius: 40,
                            );
                          }
                          return badges.containsKey(snapshot.data!['equippedBadge']) ? CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                badges[snapshot.data!['equippedBadge']]!
                                    .assetImage,
                          ) : CircleAvatar(radius: 40,);
                        }
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                        username,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  selected: _selectedDrawerIndex == 0,
                  onTap: () => _selectDrawerIndex(0),
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: Text(
                    "Leaderboard",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  selected: _selectedDrawerIndex == 0,
                  onTap: () => _selectDrawerIndex(1),
                ),
                ListTile(
                  leading: const Icon(Icons.smartphone),
                  title: Text(
                    "My Posts",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  selected: _selectedDrawerIndex == 0,
                  onTap: () => _selectDrawerIndex(2),
                ),
                ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(
                    "Marketplace",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  selected: _selectedDrawerIndex == 0,
                  onTap: () => _selectDrawerIndex(3),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Picture Mode.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Connect"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _pictureMode = false;
              _selectDrawerIndex(-1, false);
            },
            icon: const Icon(Icons.home)),
      ),
      body: PictureModeScreen(
        returnSurfing: _onModeTapped,
      ),
      floatingActionButton: switchModeButton,
    );
  }
}

class PostFilter extends StatefulWidget {
  Function onApply;
  String? sortVal;
  List<String>? subjectChoices;

  PostFilter(
      {super.key,
      required this.onApply,
      required this.sortVal,
      required this.subjectChoices});

  @override
  State<PostFilter> createState() => _PostFilterState();
}

class _PostFilterState extends State<PostFilter> {
  @override
  Widget build(BuildContext context) {
    widget.sortVal ??= sortBy.first;
    widget.subjectChoices ??= List<String>.empty(growable: true);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Sort by", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8.0),
          Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List<Widget>.generate(sortBy.length, (int i) {
              return ChoiceChip(
                label: Text(sortBy[i],
                    style: Theme.of(context).textTheme.bodyLarge),
                selected: sortBy[i] == widget.sortVal,
                selectedColor: Theme.of(context).colorScheme.primary,
                onSelected: (bool selected) {
                  setState(() {
                    widget.sortVal = sortBy[i];
                  });
                },
              );
            }),
          ),
          const Divider(height: 10, thickness: 1),
          Text("Subjects", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400.0),
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List<Widget>.generate(subjectList.length, (int i) {
                  return FilterChip(
                    label: Text(subjectList[i]),
                    selected: widget.subjectChoices!.contains(subjectList[i]),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected &&
                            !widget.subjectChoices!.contains(subjectList[i])) {
                          widget.subjectChoices!.add(subjectList[i]);
                        } else if (!selected) {
                          widget.subjectChoices!.remove(subjectList[i]);
                        }
                      });
                    },
                  );
                }),
              ),
            ),
          ),
          const Divider(height: 10, thickness: 1),
          TextButton(
              child:
                  Text("Search", style: Theme.of(context).textTheme.labelLarge),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 30.0, right: 30.0)),
              ),
              onPressed: () {
                Navigator.pop(context);

                widget.onApply(widget.sortVal, widget.subjectChoices);
              })
        ],
      ),
    );
  }
}

class PostDisplay extends StatelessWidget {
  String? sortVal;
  List<String>? subjects;

  PostDisplay({Key? key, required this.sortVal, required this.subjects})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    sortVal ??= sortBy.first;
    subjects ??= List<String>.empty();

    return FutureBuilder(
        future: Data.getPosts(sortBy: sortVal!, subjects: subjects!),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.all(5.0),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(thickness: 1.0, height: 30.0),
                  itemBuilder: (context, index) {
                    return snapshot.data![index];
                  }));
        });
  }
}
