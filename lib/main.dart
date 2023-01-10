import 'dart:math';

import 'package:flutter/material.dart';

import 'package:community_connect/post.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

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
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedDrawerIndex) { // TODO: All of this. Probably create a new file for organization.
      case 0: // Profile.
        break;
      case 1: // Leaderboard.
        break;
      case 2: // My Posts.
        break;
      case 3: // Market.
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
        body: Padding(
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
                onTap: () => _selectDrawerIndex(0),
              ),
              ListTile(
                leading: const Icon(Icons.smartphone),
                title: Text("My Posts", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(0),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: Text("Market", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(0),
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
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        likeInfo: LikeInfo(500, true),
        filters: [FilterInfo("recycling"), FilterInfo("solar power"), FilterInfo("Renewables"), FilterInfo("Planting trees")],
      ),
      Post(
        badge: "",
        username: "sejafh",
        time: 234234,
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        likeInfo: LikeInfo(500, true),
        filters: [FilterInfo("recycling"), FilterInfo("solar power"), FilterInfo("Renewables"), FilterInfo("Planting trees")],
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

