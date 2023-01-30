import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:community_connect/post.dart';
import 'package:community_connect/badge.dart';

import 'package:community_connect/screens/leaderboard.dart';
import 'package:community_connect/screens/marketplace.dart';
import 'package:community_connect/screens/profile.dart';


const List<String> subjectList = <String>["Recycling", "Solar Power", "Planting trees", "Renewables", "Picking up trash"];
const List<String> sortBy = <String>["Most recent", "Most liked", "Least liked"];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData( // TODO: Whoever wants to deal with colours and stuff can change this.
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
  Widget build(BuildContext context) {
    Widget? screen;
    switch (_selectedDrawerIndex) { // TODO: All of this. Probably create a new file for organization.
      case 0: // Profile.
        screen = const ProfileScreen(
          username: "TestUsername",
        );
        break;
      case 1: // Leaderboard.
        screen = const LeaderboardScreen();
        break;
      case 2: // My Posts.
        // Probably just the normal posts screen but with only the user's posts.
        break;
      case 3: // Marketplace.
        // screen = const MarketplaceScreen();
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
              icon: const Icon(Icons.home))
          ),
          floatingActionButton: switchModeButton,
        body: (screen != null) ? screen : Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search for a term"
                )
              ),
              TextButton(
                child: Text("Add filters..."),
                onPressed: () => _key.currentState!.openDrawer(),
              ),
              PostDisplay(),
            ],
          ),
        ),
        drawer: PostFilter(),
        endDrawer: Drawer(
          child: ListView(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: getBadgeImage("bird"), // TODO: Add badge profile picture.
                    ),
                    SizedBox(height: 14,),
                    Text(
                      "ExampleUsername", // TODO: Change to actual username.
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
                title: Text("Profile", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(0),
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard),
                title: Text("Leaderboard", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(1),
              ),
              ListTile(
                leading: const Icon(Icons.smartphone),
                title: Text("My Posts", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(2),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: Text("Marketplace", style: Theme.of(context).textTheme.titleMedium,),
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
      ),
      body: PictureModeScreen(returnSurfing: _onModeTapped,),
      floatingActionButton: switchModeButton,
    );
  }
}

class PostFilter extends StatefulWidget {
  const PostFilter({super.key});

  @override
  State<PostFilter> createState() => _PostFilterState();
}

class _PostFilterState extends State<PostFilter> {
  String sortVal = sortBy.first;
  List<String> subjectChoices = [];

  @override
  Widget build(BuildContext context) {
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
                label: Text(sortBy[i], style: Theme.of(context).textTheme.bodyLarge),
                selected: sortBy[i] == sortVal,
                selectedColor: Theme.of(context).colorScheme.primary,
                onSelected: (bool selected) {
                  setState(() {
                    sortVal = sortBy[i];
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
                    selected: subjectChoices.contains(subjectList[i]),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected && !subjectChoices.contains(subjectList[i])) {
                          subjectChoices.add(subjectList[i]);
                        } else if (!selected) {
                          subjectChoices.remove(subjectList[i]);
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
            child: Text("Search", style: Theme.of(context).textTheme.labelLarge),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 30.0, right: 30.0)),
            ),
            onPressed: () {
              Navigator.pop(context);

              // TODO: Update Search Results
            }
          )
        ],
      ),
    );
  }
}

class PostDisplay extends StatelessWidget {
  const PostDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Post> posts = [
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        imageUrl: "https://images.wagwalkingweb.com/media/training_guides/cover-his-nose/hero/How-to-Train-Your-Dog-to-Cover-His-Nose.jpg",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
        likeInfo: LikeInfo(500, true),
        filters: ["recycling", "solar power", "Renewables", "Planting trees"],
      ),
    ];

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(5.0),
        itemCount: posts.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1.0, height: 30.0),
        itemBuilder: (context, index) {
          return posts[index];
        }
      )
    );
  }
}

class PictureModeScreen extends StatefulWidget {
  PictureModeScreen({Key? key, required this.returnSurfing}) : super(key: key);

  Function returnSurfing;

  @override
  State<PictureModeScreen> createState() => _PictureModeScreenState();
}

class _PictureModeScreenState extends State<PictureModeScreen> {

  File? imageFile;

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      widget.returnSurfing();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      _getFromCamera();
    }
    return ListView(
      children: [
        const SizedBox(height: 50,),
        imageFile != null ?
          Image.file(imageFile!) :
          const Icon(Icons.camera_enhance_rounded),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: ElevatedButton(
            child: const Text(
              "Post.", // TODO: Probably make this look nicer.
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              print(imageFile); // TODO: Post image.
            },
          ),
        ),
      ],
    );
  }
}

