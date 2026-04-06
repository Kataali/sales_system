import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sales_system/shared/error/exception.dart';

/// Raw stream of connectivity-change events.
/// Each emission is a list of currently active connectivity types.
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Derived bool: `true` when at least one interface is not [ConnectivityResult.none].
/// Stays `true` (optimistic) until the very first event arrives.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStreamProvider).when(
    data: (results) => results.any((r) => r != ConnectivityResult.none),
    loading: () => true,
    error: (_, __) => true,
  );
});

/// Checks the **current** connectivity and throws [NetworkException] if offline.
///
/// Call this at the start of every network operation in the datasource layer
/// so that failures surface as [NetworkException] → [NetworkFailure] rather
/// than an opaque [SocketException].
Future<void> guardConnectivity() async {
  final results = await Connectivity().checkConnectivity();
  if (results.every((r) => r == ConnectivityResult.none)) {
    throw const NetworkException();
  }
}
