import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshableColumn extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> children;
  const RefreshableColumn({
    Key? key,
    required this.onRefresh,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildListDelegate.fixed(children))
        ],
      ),
    );
  }
}

class ProviderRefreshingColumn extends ConsumerStatefulWidget {
  // The type would ideally be simply _FutureProviderBase, but it is
  // a private class inside riverpod.
  final List<AutoDisposeFutureProvider> providers;
  final List<Widget> children;
  const ProviderRefreshingColumn({
    Key? key,
    required this.providers,
    required this.children,
  }) : super(key: key);

  @override
  ConsumerState<ProviderRefreshingColumn> createState() =>
      _ProviderRefreshingColumnState();
}

class _ProviderRefreshingColumnState
    extends ConsumerState<ProviderRefreshingColumn> {
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    waitForAllProviders().then((_) {
      setState(() => isFirstTime = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshableColumn(
      onRefresh: () async {
        // https://github.com/rrousselGit/riverpod/issues/875#issuecomment-982845243
        // We use invalidate instead of refresh since we do not need
        // the return value. Do a read to trigger an immediate
        // re-fetching of packages and to get the future.
        for (final provider in widget.providers) {
          ref.invalidate(provider);
        }
        // Wait for all the futures to complete so that the spinner is
        // visble till everything is completely loaded.
        await waitForAllProviders();
        setState(() => isFirstTime = false);
      },
      children: widget.children,
    );
  }

  Future<List<dynamic>> waitForAllProviders() =>
      Future.wait(widget.providers.map((p) => ref.read(p.future)));
}
