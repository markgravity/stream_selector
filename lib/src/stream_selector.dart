import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

/// A wrapper class of [StreamBuilder].
///
class StreamSelector<T> extends SingleChildStatefulWidget {
  /// Both `builder` and `selector` must not be `null`.
  StreamSelector({
    Key? key,
    required this.stream,
    required this.builder,
    Widget? child,
  }) : super(key: key, child: child);

  /// Must not be `null`
  final Stream<T> stream;

  /// A function that builds a widget tree from `child` and the last result of
  /// [stream].
  ///
  /// [builder] will be called again whenever the its parent widget asks for an
  /// update
  ///
  /// Must not be `null`.
  final ValueWidgetBuilder<T> builder;

  @override
  _StreamSelectorState<T> createState() => _StreamSelectorState<T>();
}

class _StreamSelectorState<T> extends SingleChildState<StreamSelector<T>> {
  T? value;
  Widget? cache;
  Widget? oldWidget;
  bool isInitialEventSkipped = false;
  Stream<T>? stream;

  @override
  void initState() {
    super.initState();

    // Get a stream from selector
    stream = widget.stream;
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: value,
      builder: (context, snapshot) {
        if (snapshot.hasError) throw snapshot.error!;

        // Ignore a null event when create a stream
        if (!isInitialEventSkipped) {
          isInitialEventSkipped = true;
          return SizedBox.shrink();
        }

        final selected = snapshot.data;
        var shouldInvalidateCache = oldWidget != widget ||
            !const DeepCollectionEquality().equals(value, selected);
        if (shouldInvalidateCache) {
          value = selected;
          oldWidget = widget;
          cache = widget.builder(
            context,
            selected as T,
            child,
          );
        }
        return cache!;
      },
    );
  }
}
