import 'package:flutter/material.dart';

class Example1 extends StatefulWidget {
  const Example1({Key? key}) : super(key: key);

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  String? _questId;
  bool _createQuest = false;

  void closePage() {
    if (_questId != null) {
      setState(() {
        _questId = null;
      });
    } else if (_createQuest) {
      setState(() {
        _createQuest = false;
      });
    }
  }

  void openQuestPage(String id) {
    setState(() {
      _questId = id;
    });
  }

  void openCreateQuestPage() {
    setState(() {
      _createQuest = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        closePage();
        return true;
      },
      pages: [
        const MaterialPage(child: _HomeScreen()),
        if (_questId != null)
          const MaterialPage(child: _QuestScreen())
        else if (_createQuest)
          const MaterialPage(
            fullscreenDialog: true,
            child: _CreateQuestScreen(),
          )
      ],
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.findAncestorStateOfType<_Example1State>()!.openCreateQuestPage();
        },
      ),
      body: ListView(
        children: List.generate(
          15,
          (index) => ListTile(
            title: Text('Quest #$index'),
            onTap: () {
              context.findAncestorStateOfType<_Example1State>()!.openQuestPage('$index');
            },
          ),
        ),
      ),
    );
  }
}

class _QuestScreen extends StatelessWidget {
  const _QuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flow = context.findAncestorStateOfType<_Example1State>();
    return Scaffold(
      appBar: AppBar(
        title: Text(flow!._questId!),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Quest info'),
          )
        ],
      ),
    );
  }
}

class _CreateQuestScreen extends StatelessWidget {
  const _CreateQuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flow = context.findAncestorStateOfType<_Example1State>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quest'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Quest info'),
          )
        ],
      ),
    );
  }
}
