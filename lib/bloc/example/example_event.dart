abstract class ExampleEvent{}

class ExampleEditTextEvent extends ExampleEvent{
  final String value;

  ExampleEditTextEvent(this.value);
}

class ExampleSubmitEvent extends ExampleEvent{}