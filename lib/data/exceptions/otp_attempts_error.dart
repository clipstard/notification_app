class OtpAttemptsError extends Error {
  final DateTime dueDate;
  OtpAttemptsError(this.dueDate);
}
