import 'dart:math';

import 'package:flutter/material.dart';

import 'package:community_connect/post.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:community_connect/screens/leaderboard.dart';
import 'package:community_connect/screens/marketplace.dart';
import 'package:community_connect/screens/profile.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  void _selectDrawerIndex(int index) {
    Navigator.pop(context);
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? screen;
    switch (_selectedDrawerIndex) { // TODO: All of this. Probably create a new file for organization.
      case 0: // Profile.
        // screen = const ProfileScreen();
        break;
      case 1: // Leaderboard.
        // screen = const LeaderboardScreen();
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
      // Surfing Mode.
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Community Connect"),
            centerTitle: true,
          ),
          floatingActionButton: switchModeButton,
        body: (screen != null) ? screen : Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search for a term"
                )
              ),
              PostFilter(), // TODO: Maybe make the filters into a side sheet instead.
              PostDisplay(),
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
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: null, // TODO: Add badge profile picture.
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

class PostFilter extends StatelessWidget {
  const PostFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        return; // TODO: Open filters sidebar
      },
      child: const Text("Add filters"),
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

