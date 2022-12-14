import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
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
  int _selectedIndex = 0;

  void _onModeTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      onTap: _onModeTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_camera),
          label: "Picture",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.web),
          label: "Surfing",
        ),
      ],
      currentIndex: _selectedIndex,
    );

    if (_selectedIndex == 1) {
      // Surfing Mode.
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Community Connect"),
            centerTitle: true,
            bottom: const TabBar(
             tabs: [
              Tab(
                  text: 'Market',
                  icon: Icon(Icons.local_grocery_store) // TODO: Or maybe Icons.store if that looks better.
              ),
              Tab(
                  text: 'Leadership',
                  icon: Icon(Icons.leaderboard)
              ),
              Tab(
                  text: 'Trending',
                  icon: Icon(Icons.trending_up)
              ),
            ],
          ),
          ),
          body: const TabBarView( // Tabs.
            children: [
            Center(child: Text("sdfkldfskjl")),
            Center(child: Text("dfskjlkjldf")),
            Center(child: Text("sdijflkldfs")),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
    }

    // Picture Mode.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Connect"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("kjdfskdfs"),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
