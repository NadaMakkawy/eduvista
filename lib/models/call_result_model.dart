class CallResult {
  final int status;
  final String statusMessage;
  final dynamic data;
  final String error;
  final bool isSuscces;

  CallResult({
    required this.status,
    required this.statusMessage,
    required this.data,
    required this.error,
    required this.isSuscces,
  });
}
