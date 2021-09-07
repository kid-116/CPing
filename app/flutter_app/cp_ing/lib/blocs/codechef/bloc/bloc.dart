import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/codechef.dart';
import 'package:equatable/equatable.dart';

import 'package:cp_ing/models/codechef.dart';
part 'event.dart';
part 'state.dart';

class CodechefBloc extends Bloc<CodechefEvent, CodechefState> {
  CodechefRepository repository;

  CodechefBloc({required CodechefState initialState, required this.repository})
      : super(CodechefInitial()) {
    add(ActiveContestEvent());
  }

  @override
  Stream<CodechefState> mapEventToState(
    CodechefEvent event,
  ) async* {
    if (event is ActiveContestEvent) {
      try {
        List<CodechefModel> listPresent = [];
        // ignore: unused_local_variable
        List<CodechefModel> listFuture = [];
        yield LoadingState();
        listPresent = await repository.getCodechefData('active-contests');
        // list_future = await repository.getCodechefData('future-contests');
        yield ActiveLoadedState(listContest: listPresent);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestEvent) {
      try {
        List<CodechefModel> listFuture = [];
        yield LoadingState();
        listFuture = await repository.getCodechefData('future-contests');
        // list_future = await repository.getCodechefData('future-contests');
        yield FutureLoadedState(listContest: listFuture);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
