class AppError {
  final String message;
  final String? code;
  final dynamic originalError;

  AppError(this.message, {this.code, this.originalError});

  @override
  String toString() => message;

  static AppError from(dynamic e) {
    String message = 'An unexpected error occurred. Please try again.';
    String? code;

    final eStr = e.toString();
    
    // Auth Errors
    if (eStr.contains('AuthException') || eStr.contains('invalid login credentials')) {
      message = 'Invalid login credentials. Please check your details and try again.';
      code = 'auth_failed';
    } else if (eStr.contains('timeout')) {
      message = 'The connection timed out. Please check your internet connection.';
      code = 'timeout';
    } else if (eStr.contains('SocketException') || eStr.contains('network error')) {
      message = 'Network error. Please ensure you are connected to the internet.';
      code = 'network_error';
    } else if (eStr.contains('PostgrestException')) {
      message = 'Database operation failed. Please try again later.';
      code = 'db_error';
    } else if (eStr.contains('StorageException')) {
      message = 'Failed to access files. Please try again later.';
      code = 'storage_error';
    } else if (e is Exception) {
      // Clean up "Exception: " prefix if present
      message = e.toString().replaceFirst('Exception: ', '');
    }

    return AppError(message, code: code, originalError: e);
  }
}
