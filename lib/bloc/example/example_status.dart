abstract class ExampleStatus{
  const ExampleStatus();
}

class ExampleInitialStatus extends ExampleStatus{
  const ExampleInitialStatus();
}

class ExampleOnLoadingStatus extends ExampleStatus{}

class ExampleOnSuccessStatus extends ExampleStatus{
  final String? msg;
  final String? resFinal;

  ExampleOnSuccessStatus(this.msg, this.resFinal);
}

class ExampleOnFailedStatus extends ExampleStatus{
  final Error error;

  ExampleOnFailedStatus(this.error);
}
