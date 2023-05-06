import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Generic AsyncValueWidget for handling async data
class AsyncValueWidget<T> extends StatelessWidget {
  /// Constructor
  const AsyncValueWidget({
    Key? key,
    required this.value,
    required this.data,
    this.loading,
  }) : super(key: key);

  final AsyncValue<T> value;

  /// Loading widget
  final Widget? loading;

  /// output builder function
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading != null
          ? loading!
          : const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, __) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.running_with_errors),
              Text(error.toString()),
            ],
          ),
        );
      },
    );
  }
}
