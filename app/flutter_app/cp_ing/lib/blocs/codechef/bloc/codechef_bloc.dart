import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/codechef_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:cp_ing/models/codechef_model.dart';
part 'codechef_event.dart';
part 'codechef_state.dart';

class CodechefBloc extends Bloc<CodechefEvent, CodechefState> {
  CodechefRepository repository;

  CodechefBloc({required CodechefState initialState, required this.repository})
      : super(CodechefInitial()) {
    add(Active_contest_event());
  }

  @override
  Stream<CodechefState> mapEventToState(
    CodechefEvent event,
  ) async* {
    if (event is Active_contest_event) {
      try {
        List<CodechefModel> list_present = [];
        List<CodechefModel> list_future = [];
        yield LoadingState();
        list_present = await repository.getCodechefData('active-contests');
        // list_future = await repository.getCodechefData('future-contests');
        yield ActiveLoadedState(list_contest: list_present);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is Future_contest_event) {
      try {
        List<CodechefModel> list_future = [];
        yield LoadingState();
        list_future = await repository.getCodechefData('future-contests');
        // list_future = await repository.getCodechefData('future-contests');
        yield FutureLoadedState(list_contest: list_future);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
