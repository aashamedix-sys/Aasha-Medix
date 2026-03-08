import 'dart:io';
import 'dart:developer';
import 'dart:async';

/// Checks internet connectivity by attempting a DNS lookup.
class ConnectivityChecker {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Throws a user-friendly exception if there is no connection.
  static Future<void> requireConnection() async {
    if (!await isConnected()) {
      throw Exception(
        'No internet connection. Please check your Wi-Fi or mobile data and try again.',
      );
    }
  }
}

/// Executes an async function with automatic retries on failure.
class RetryHelper {
  static Future<T> retry<T>({
    required Future<T> Function() action,
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 2),
    String? context,
  }) async {
    int attempt = 0;
    T? result;
    dynamic lastError;

    while (attempt < maxAttempts) {
      try {
        result = await action();
        return result!;
      } catch (e) {
        lastError = e;
        attempt++;
        log('[RetryHelper] Attempt $attempt/$maxAttempts failed ${context != null ? "($context)" : ""}: $e');
        if (attempt < maxAttempts) {
          await Future.delayed(delay * attempt); // Exponential backoff
        }
      }
    }

    throw lastError ?? Exception('Operation failed after $maxAttempts attempts');
  }
}
