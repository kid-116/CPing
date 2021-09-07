import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/codeforces_repository.dart';
import 'package:cp_ing/models/codeforces_model.dart';
import 'package:equatable/equatable.dart';

part 'codeforces_event.dart';
part 'codeforces_state.dart';

class CodeforcesBloc extends Bloc<CodeforcesEvent, CodeforcesState> {
  CodeforcesRepository repository;

  CodeforcesBloc(
      {required CodeforcesState initialState, required this.repository})
      : super(CodeforcesInitial()) {
    add(Active_contest_event());
  }

  @override
  Stream<CodeforcesState> mapEventToState(
    CodeforcesEvent event,
  ) async* {
    if (event is Active_contest_event) {
      try {
        List<CodeforcesModel> list_present = [];
        List<CodeforcesModel> list_future = [];
        yield LoadingState();
        list_present = await repository.getCodeforcesData('active-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield ActiveLoadedState(list_contest: list_present);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is Future_contest_event) {
      try {
        List<CodeforcesModel> list_future = [];
        yield LoadingState();
        list_future = await repository.getCodeforcesData('future-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield FutureLoadedState(list_contest: list_future);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
