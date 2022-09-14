import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigator_tech_talk/config.dart';
import 'package:navigator_tech_talk/dialog_page.dart';

abstract class AppRouter {
  static AppRouter of(BuildContext context) {
    final i = context.dependOnInheritedWidgetOfExactType<_InheritedRouterWidget>();
    return i!.router;
  }

  void closePage();

  void openQuestPage(String id);

  void openShareQuestPage();

  void openCreateQuestPage();

  void openMediaDialog();

  void openParticipantsDialog();
}

class _InheritedRouterWidget extends InheritedWidget {
  const _InheritedRouterWidget({
    super.key,
    required super.child,
    required this.router,
  });

  final AppRouter router;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class AppRouterDelegate extends RouterDelegate<AppFlowConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppFlowConfiguration>
    implements AppRouter {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  AppFlowConfiguration? _configuration;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppFlowConfiguration? get currentConfiguration => _configuration;

  @override
  Future<void> setNewRoutePath(AppFlowConfiguration configuration) async {
    _configuration = configuration;
    notifyListeners();
  }

  void closePage() {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      quest: (q) => q.share ? q.copyWith(share: false) : const AppFlowConfiguration.root(),
      createQuest: (c) {
        if (c.addParticipants) return c.copyWith(addParticipants: false);
        if (c.selectMedia) return c.copyWith(selectMedia: false);
        return const AppFlowConfiguration.root();
      },
    );
    _configuration = updatedConfig;

    notifyListeners();
  }

  void openQuestPage(String id) {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      root: (root) => AppFlowConfiguration.quest(id: id),
    );
    _configuration = updatedConfig;
    notifyListeners();
  }

  void openShareQuestPage() {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      quest: (q) => q.copyWith(share: true),
    );
    _configuration = updatedConfig;
    notifyListeners();
  }

  void openCreateQuestPage() {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      root: (root) => AppFlowConfiguration.createQuest(),
    );
    _configuration = updatedConfig;
    notifyListeners();
  }

  void openMediaDialog() {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      createQuest: (c) => c.copyWith(selectMedia: true),
    );
    _configuration = updatedConfig;
    notifyListeners();
  }

  void openParticipantsDialog() {
    final updatedConfig = _configuration?.maybeMap(
      orElse: () => _configuration,
      createQuest: (c) => c.copyWith(addParticipants: true),
    );
    _configuration = updatedConfig;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final config = _configuration ?? const AppFlowConfiguration.root();
    return _InheritedRouterWidget(
      router: this,
      child: Navigator(
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
            MaterialPage(child: _QuestFlow(config: config))
          else if (config is CreateQuestAppFlowConfiguration)
            MaterialPage(
              child: _CreateQuestFlow(config: config),
            )
        ],
      ),
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
          AppRouter.of(context).openCreateQuestPage();
        },
      ),
      body: ListView(
        children: List.generate(
          15,
          (index) => ListTile(
            title: Text('Quest #$index'),
            onTap: () {
              AppRouter.of(context).openQuestPage('$index');
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
        final rootFlow = AppRouter.of(context);
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
            final rootFlow = AppRouter.of(context);
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
                AppRouter.of(context).openShareQuestPage();
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
            final rootFlow = AppRouter.of(context);
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = AppRouter.of(context);
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
        final rootFlow = AppRouter.of(context);
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
    final flow = AppRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final rootFlow = AppRouter.of(context);
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
            final rootFlow = AppRouter.of(context);
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = AppRouter.of(context);
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
            final rootFlow = AppRouter.of(context);
            rootFlow.closePage();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final rootFlow = AppRouter.of(context);
            rootFlow.closePage();
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}

class AppConfigurationParser extends RouteInformationParser<AppFlowConfiguration> {
  const AppConfigurationParser();
  @override
  Future<AppFlowConfiguration> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(const AppFlowConfiguration.root());
  }
}
