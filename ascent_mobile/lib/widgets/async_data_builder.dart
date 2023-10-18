import 'package:ascent_pms/pages/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncDataBuilder<T> extends StatelessWidget {
  const AsyncDataBuilder(
    this.value,
    this.onData, {
    super.key,
    this.flexLoading = true,
  });

  final Widget Function(T) onData;
  final AsyncValue<T> value;
  final bool flexLoading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      error: (error, stackTrace) => handleNoInternet(error, context),
      loading: () {
        const center = Center(child: CircularProgressIndicator());
        return flexLoading ? const Flexible(child: center) : center;
      },
      data: onData,
    );
  }
}
