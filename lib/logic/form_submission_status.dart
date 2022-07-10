abstract class FormSubmissionStatus {
  const FormSubmissionStatus();

  Object? get exception => null;

  @override
  String toString() {
    return 'InitialFormStatus';
  }
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Object exception;

  SubmissionFailed(this.exception);
}
