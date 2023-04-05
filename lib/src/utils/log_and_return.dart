T Function(dynamic e) logAndReturn<T>(T value, [String? message]) {
  return (e) {
    print('${message ?? 'Error'}: $e');
    return value;
  };
}
