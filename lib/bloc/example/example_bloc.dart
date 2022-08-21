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