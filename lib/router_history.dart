import 'package:go_router/go_router.dart';
import 'package:gorouterstate_issue/router.dart';

import 'package:riverpod/riverpod.dart';

class LocationNotifier extends StateNotifier<String> {
  LocationNotifier() : super(gRouter.location) {
    gRouter.routeInformationProvider.addListener(onChange);
    gRouter.routerDelegate.addListener(onChange);
    gRouter.addListener(onChange);
  }
  void onChange() {
    state = gRouter.location;
  }

  @override
  void dispose() {
    gRouter.removeListener(onChange);
    gRouter.routeInformationProvider.removeListener(onChange);
    gRouter.routerDelegate.removeListener(onChange);
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, String>(
    (ref) => LocationNotifier());

class LocationHistory {
  List<String> history;
  List<String> popped;

  LocationHistory(this.history, this.popped);

  LocationHistory clone() {
    return LocationHistory(
        List<String>.from(history), List<String>.from(popped));
  }
}

class LocationHistoryNotifier extends StateNotifier<LocationHistory> {
  LocationHistoryNotifier(Ref ref) : super(LocationHistory([], [])) {
    ref.listen(locationProvider, (previous, next) {
      print(
          "History: ${state.history} - Popped: ${state.popped} - Next: ${next}");
      if (state.history.isNotEmpty && state.history.last == next) {
        print("NO push history is already up to date");
        return;
      }
      state.history.add(next);
      if (state.popped.isNotEmpty && state.popped.last == next) {
        print("POP LAST");
        state.popped.removeLast();
      } else {
        print("CLEAR");
        state.popped.clear();
      }
      state = state.clone();
    }, fireImmediately: true);
  }

  void back() {
    print("HistoryBACK: ${state.history} - Popped: ${state.popped}");
    state.popped.add(state.history.removeLast());
    final newLoc = state.history.last;
    print("HistoryBACK2: ${state.history} - Popped: ${state.popped}");
    state = state.clone();
    gRouter.go(newLoc);
  }

  void forward() {
    print("HistoryFWD: ${state.history} - Popped: ${state.popped}");
    final newLoc = state.popped.removeLast();
    state.history.add(newLoc);
    print("HistoryFWD2: ${state.history} - Popped: ${state.popped}");
    state = state.clone();
    gRouter.go(newLoc);
  }

  bool hasForward() {
    return state.popped.isNotEmpty;
  }

  bool hasBackward() {
    return state.history.length > 1;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final locationHistoryProvider =
    StateNotifierProvider<LocationHistoryNotifier, LocationHistory>(
        (ref) => LocationHistoryNotifier(ref));
