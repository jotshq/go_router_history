import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouterstate_issue/router.dart';
import 'package:gorouterstate_issue/router_history.dart';

void main() => runApp(App());

class BackButton extends ConsumerWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locH = ref.watch(locationHistoryProvider.notifier);
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: locH.hasBackward()
          ? () {
              locH.back();
            }
          : null,
    );
  }
}

class ForwardButton extends ConsumerWidget {
  const ForwardButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locH = ref.watch(locationHistoryProvider.notifier);
    return IconButton(
      icon: const Icon(Icons.arrow_forward_ios),
      onPressed: locH.hasForward()
          ? () {
              locH.forward();
            }
          : null,
    );
  }
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: gRouter,
        title: 'GoRouter Example',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String name;

  const MyHomePage(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    final st = GoRouterState.of(context);
    print("locA: ${st.location}");
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          actions: const [BackButton(), ForwardButton()],
        ),
        body: Column(children: [
          TextButton(
              child: const Text("go to A"), onPressed: () => gRouter.go('/')),
          TextButton(
              child: const Text("go to B"), onPressed: () => gRouter.go('/b')),
          TextButton(
              child: const Text("go to C"), onPressed: () => gRouter.go('/c')),
          TextButton(
              child: const Text("go to C/1"),
              onPressed: () => gRouter.go('/c/1')),
          TextButton(
              child: const Text("go to C/2"),
              onPressed: () => gRouter.go('/c/2')),
          // TextButton(
          //     child: Text("push B"), onPressed: () => gRouter.push('/b')),
        ]));
  }
}
