import 'package:flutter/material.dart';

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
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedDrawerIndex) { // TODO: All of this. Probably create a new file for organization.
      case 0: // Profile.
        // return const ProfileScreen();
        break;
      case 1: // Leaderboard.
        // return const LeaderboardScreen();
        break;
      case 2: // My Posts.
        // Probably just the normal posts screen but with only the user's posts.
        break;
      case 3: // Marketplace.
        // return const MarketplaceScreen();
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
            children: [
              Text("Filters:", style: Theme.of(context).textTheme.headline6),
              const PostFilter(), // TODO: Maybe make the filters into a side sheet instead.
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
    return Wrap(
      spacing: 15,
      children: [
        FilterChip( // TODO: Probably make this into a class. I don't know all the filters, so I won't do this yet.
          label: const Text("Filter name."),
          selected: true,
          onSelected: (bool value) {},
        ),
        FilterChip(
          label: const Text("fskl."),
          onSelected: (bool value) {},
        ),
        FilterChip(
          label: const Text("Longer filter name."),
          onSelected: (bool value) {},
        ),
      ],
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

