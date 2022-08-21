import 'package:flutter_bloc/flutter_bloc.dart';

//https://github.com/gzeinnumer/flutter_bloc_simple_v1
//gzn_dart_blocclass_full_form_v1_essb
//EVENT-------------------------------------------------------------------------
abstract class $Example$Event{}

class $Example$EditTextEvent extends $Example$Event{
  final String value;

  $Example$EditTextEvent(this.value);
}

class $Example$SubmitEvent extends $Example$Event{}

//STATUS------------------------------------------------------------------------
abstract class $Example$Status{
  const $Example$Status();
}

class $Example$InitStatus extends $Example$Status{
  const $Example$InitStatus();
}

class $Example$OnLoadingStatus extends $Example$Status{}

class $Example$OnSuccessStatus extends $Example$Status{
  final String? msg;

  $Example$OnSuccessStatus(this.msg);
}

class $Example$OnFailedStatus extends $Example$Status{
  final Error error;

  $Example$OnFailedStatus(this.error);
}

//STATE-------------------------------------------------------------------------
class $Example$State {
  final String? value;
  // bool get isValidValue => value.toString().length > 1;

  final $Example$Status? status;

  $Example$State({
    this.value = "",
    this.status = const $Example$InitStatus(),
  });

  $Example$State copyWith({
    String? value,
    $Example$Status? status,
  }) {
    return $Example$State(
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }
}

//BLOC--------------------------------------------------------------------------
class $Example$Bloc extends Bloc<$Example$Event, $Example$State>{
  // final ExampleRepo repo;

  $Example$Bloc() : super($Example$State());

  @override
  Stream<$Example$State> mapEventToState($Example$Event event) async* {
    // if(event is ExampleEditTextEvent){
    //   yield state.copyWith(editText: event.value);
    // }
  }
}