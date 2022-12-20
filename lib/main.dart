import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

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
    switch (_selectedDrawerIndex) { // TODO: All of this.
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
            children: <Widget>[
              Text("Filters:", style: Theme.of(context).textTheme.headline6),
              const PostFilter(), // TODO: Maybe make the filters into a side sheet instead.
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Probably design this to look nicer. I feel like something should be added here.",
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
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
                leading: const Icon(Icons.question_mark),
                title: Text("My Posts", style: Theme.of(context).textTheme.titleMedium,),
                selected: _selectedDrawerIndex == 0,
                onTap: () => _selectDrawerIndex(0),
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
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
      body: const PictureModeScreen(),
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
  const PictureModeScreen({Key? key}) : super(key: key);

  @override
  State<PictureModeScreen> createState() => _PictureModeScreenState();
}

class _PictureModeScreenState extends State<PictureModeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

