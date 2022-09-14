import 'package:flutter/material.dart';
import 'package:navigator_tech_talk/config.dart';
import 'package:navigator_tech_talk/dialog_page.dart';

class Example2 extends StatefulWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  AppFlowConfiguration configuration = const AppFlowConfiguration.root();

  void closePage() {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        quest: (q) => q.share ? q.copyWith(share: false) : const AppFlowConfiguration.root(),
        createQuest: (c) {
          if (c.addParticipants) return c.copyWith(addParticipants: false);
          if (c.selectMedia) return c.copyWith(selectMedia: false);
          return const AppFlowConfiguration.root();
        },
      );
      configuration = updatedConfig;
    });
  }

  void openQuestPage(String id) {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        root: (root) => AppFlowConfiguration.quest(id: id),
      );
      configuration = updatedConfig;
    });
  }

  void openShareQuestPage() {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        quest: (q) => q.copyWith(share: true),
      );
      configuration = updatedConfig;
    });
  }

  void openCreateQuestPage() {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        root: (root) => AppFlowConfiguration.createQuest(),
      );
      configuration = updatedConfig;
    });
  }

  void openMediaDialog() {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        createQuest: (c) => c.copyWith(selectMedia: true),
      );
      configuration = updatedConfig;
    });
  }

  void openParticipantsDialog() {
    setState(() {
      final updatedConfig = configuration.maybeMap(
        orElse: () => configuration,
        createQuest: (c) => c.copyWith(addParticipants: true),
      );
      configuration = updatedConfig;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = configuration;
    return Navigator(
      onPopPage: (route, result) {
        closePage();
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
      pages: [
        const MaterialPage(child: _HomeScreen()),
        if (config is QuestAppFlowConfiguration)
          MaterialPage(
            child: _QuestFlow(config: config),
          )
        else if (config is CreateQuestAppFlowConfiguration)
          MaterialPage(
            child: _CreateQuestFlow(config: config),
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
          context.findAncestorStateOfType<_Example2State>()!.openCreateQuestPage();
        },
      ),
      body: ListView(
        children: List.generate(
          15,
          (index) => ListTile(
            title: Text('Quest #$index'),
            onTap: () {
              context.findAncestorStateOfType<_Example2State>()!.openQuestPage('$index');
            },
          ),
        ),
      ),
    );
  }
}

class _QuestFlow extends StatelessWidget {
  const _QuestFlow({Key? key, required this.config}) : super(key: key);

  final QuestAppFlowConfiguration config;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
        rootFlow.closePage();
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
      pages: [
        const MaterialPage(child: _QuestScreen()),
        if (config.share)
          const DialogPage(
            child: _ShareDialog(),
          )
      ],
    );
  }
}

class _QuestScreen extends StatelessWidget {
  const _QuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flow = context.findAncestorWidgetOfExactType<_QuestFlow>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
        ),
        title: Text(flow!.config.id),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text('Quest info ...'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.findAncestorStateOfType<_Example2State>()!.openShareQuestPage();
              },
              child: Text('Share'),
            ),
          )
        ],
      ),
    );
  }
}

class _ShareDialog extends StatelessWidget {
  const _ShareDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Do you want to share quest?'),
      actions: [
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Share'),
        ),
      ],
    );
  }
}

class _CreateQuestFlow extends StatelessWidget {
  const _CreateQuestFlow({Key? key, required this.config}) : super(key: key);

  final CreateQuestAppFlowConfiguration config;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
        rootFlow.closePage();
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
      pages: [
        const MaterialPage(child: _CreateQuestScreen()),
        if (config.selectMedia)
          const DialogPage(child: _SelectMediaDialog())
        else if (config.addParticipants)
          const DialogPage(child: _AddParticipantsDialog()),
      ],
    );
  }
}

class _CreateQuestScreen extends StatelessWidget {
  const _CreateQuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flow = context.findAncestorStateOfType<_Example2State>();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
        ),
        title: Text('Create Quest'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Quest info'),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    flow!.openMediaDialog();
                  },
                  child: Text('Media'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    flow!.openParticipantsDialog();
                  },
                  child: Text('Participants'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SelectMediaDialog extends StatelessWidget {
  const _SelectMediaDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Select media please'),
      actions: [
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Select'),
        ),
      ],
    );
  }
}

class _AddParticipantsDialog extends StatelessWidget {
  const _AddParticipantsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Add participants please'),
      actions: [
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = context.findAncestorStateOfType<_Example2State>()!;
            rootFlow.closePage();
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
