import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteStatusNotifier extends StateNotifier<bool> {
  RouteStatusNotifier() : super(false);

  void activateRoute() => state = true; // Route is active
  void cancelRoute() => state = false; // Route is canceled
}

final routeStatusProvider = StateNotifierProvider<RouteStatusNotifier, bool>(
  (ref) => RouteStatusNotifier(),
);
