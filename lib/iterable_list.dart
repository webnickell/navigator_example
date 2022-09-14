import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IterableList extends StatefulWidget {
  const IterableList({Key? key}) : super(key: key);

  @override
  State<IterableList> createState() => _IterableListState();
}

class _IterableListState extends State<IterableList> {
  late CachingIterable<int> _cachedIterable;

  @override
  void initState() {
    super.initState();

    final gen = fibonacciGenerator();
    _cachedIterable = CachingIterable(gen.iterator);

    gen.iterator;
    _cachedIterable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CachingIterable'),
      ),
      body: ListView.custom(
        childrenDelegate: IterableSliverChildDelegate(_cachedIterable),
      ),
    );
  }
}

class IterableSliverChildDelegate<T> extends SliverChildDelegate {
  final Iterable<T> iterable;

  IterableSliverChildDelegate(this.iterable);

  @override
  Widget? build(BuildContext context, int index) {
    final item = iterable.elementAt(index);
    return Text('$item');
  }

  @override
  bool shouldRebuild(IterableSliverChildDelegate<T> oldDelegate) {
    return iterable != oldDelegate.iterable;
  }
}

Iterable<int> fibonacciGenerator() sync* {
  var fst = 1;
  var snd = 1;
  debugPrint('Produce $fst');
  yield fst;
  debugPrint('Produce $snd');
  yield snd;

  while (true) {
    final next = fst + snd;
    debugPrint('Produce $next');
    yield next;
    fst = snd;
    snd = next;
  }
}
