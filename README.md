# flutter_bloc_simple_v1

| <img src="/preview/preview1.png" width="300"/> | <img src="/preview/preview2.png" width="300"/> | <img src="/preview/preview3.png" width="300"/> |

- example_bloc.dart
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_event.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_state.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_status.dart';
import 'package:flutter_bloc_simple_v1/repo/example_repo.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState>{
  final ExampleRepo exampleRepo;

  ExampleBloc(this.exampleRepo) : super(ExampleState());

  @override
  Stream<ExampleState> mapEventToState(ExampleEvent event) async* {
    if(event is ExampleEditTextEvent){
      yield state.copyWith(editText: event.value);

    } else if(event is ExampleSubmitEvent){
      yield state.copyWith(status: ExampleOnLoadingStatus());

      try{
        bool res = await exampleRepo.validate(state.editText.toString());
        if(res) {
          yield state.copyWith(status: ExampleOnSuccessStatus('Ada "a" ' ,state.editText.toString()));
        } else {
          yield state.copyWith(status: ExampleOnSuccessStatus('Tidak ada "a"', state.editText.toString()));
        }
      } on Error catch(e){
          yield state.copyWith(status: ExampleOnFailedStatus(e));
      }
    }
  }
}
```

- example_event.dart
```dart
abstract class ExampleEvent{}

class ExampleEditTextEvent extends ExampleEvent{
  final String value;

  ExampleEditTextEvent(this.value);
}

class ExampleSubmitEvent extends ExampleEvent{}
```
- example_state.dart
```dart
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
```

- example_status.dart
```dart
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
```

- example_repo.dart
```dart
class ExampleRepo{
  Future<bool> validate(String editText) async{
    await Future.delayed(const Duration(seconds: 1));
    return editText.contains("a");
  }
}
```

- example_view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_bloc.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_event.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_state.dart';
import 'package:flutter_bloc_simple_v1/bloc/example/example_status.dart';
import 'package:flutter_bloc_simple_v1/repo/example_repo.dart';

class ExampleView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ExampleBloc>(
              create: (context) => ExampleBloc(context.read<ExampleRepo>()))
        ],
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return BlocListener<ExampleBloc, ExampleState>(
      listener: (context, state) {
        final status = state.status;
        if (status is ExampleOnFailedStatus) {
          final c = state.status as ExampleOnFailedStatus;
          print(c.error.toString());
          // _showSnackbar(context, c.error.toString());
        } else if (status is ExampleOnSuccessStatus) {
          final c = state.status as ExampleOnSuccessStatus;
          print(c.msg.toString());
          // _showSnackbar(context, c.msg.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _editText(),
              const SizedBox(height: 16),
              _btn(),
              const SizedBox(height: 16),
              _textRealTime(),
              const SizedBox(height: 16),
              _textNotRealTime(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editText() {
    return BlocBuilder<ExampleBloc, ExampleState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            hintText: "ExampleEditTextEvent",
          ),
          validator: (value) => state.isValidEditText ? null : "To short",
          onChanged: (value) => context.read<ExampleBloc>().add(ExampleEditTextEvent(value)),
        );
      },
    );
  }

  Widget _btn() {
    return BlocBuilder<ExampleBloc, ExampleState>(
      builder: (context, state) {
        return state.status is ExampleOnLoadingStatus
            ? const CircularProgressIndicator()
            : ElevatedButton(
                    child: const Text('ExampleSubmitEvent'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ExampleBloc>().add(ExampleSubmitEvent());
                      }
                    },
                  );
      },
    );
  }

  Widget _textRealTime() {
    return BlocBuilder<ExampleBloc, ExampleState>(
      builder: (context, state) {
        if (state.status is ExampleOnSuccessStatus) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Real Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text('Result : ${state.editText}'),
              Text('More than 1 : ${state.isValidEditText}'),
              Text('Constains "a" : ${state.isEditTextConstainsA}'),
            ],
          );
        } else {
          return const Text('Type something and click ExampleSubmitEvent');
        }
      },
    );
  }

  Widget _textNotRealTime() {
    return BlocBuilder<ExampleBloc, ExampleState>(
      builder: (context, state) {
        if (state.status is ExampleOnSuccessStatus) {
          final c = state.status as ExampleOnSuccessStatus;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Not Real Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text('After Validate : ${c.msg}'),
              Text('Text : ${c.resFinal}'),
            ],
          );
        } else {
          return const Text('Type something and click ExampleSubmitEvent');
        }
      },
    );
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```