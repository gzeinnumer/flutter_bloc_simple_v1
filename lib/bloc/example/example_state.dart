import 'package:flutter_bloc_simple_v1/bloc/example/example_status.dart';

class ExampleState {
  final String? editText;

  bool get isValidEditText => editText.toString().length > 1;
  bool get isEditTextConstainsA => editText.toString().contains("a");

  final ExampleStatus? status;

  ExampleState({
    this.editText = "",
    this.status = const ExampleInitialStatus(),
  });

  ExampleState copyWith({
    String? editText,
    ExampleStatus? status,
  }) {
    return ExampleState(
      editText: editText ?? this.editText,
      status: status ?? this.status,
    );
  }
}
