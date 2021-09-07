import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/codeforces.dart';
import 'package:cp_ing/models/codeforces.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class CodeforcesBloc extends Bloc<CodeforcesEvent, CodeforcesState> {
  CodeforcesRepository repository;

  CodeforcesBloc(
      {required CodeforcesState initialState, required this.repository})
      : super(CodeforcesInitial()) {
    add(ActiveContestEvent());
  }

  @override
  Stream<CodeforcesState> mapEventToState(
    CodeforcesEvent event,
  ) async* {
    if (event is ActiveContestEvent) {
      try {
        List<CodeforcesModel> listPresent = [];
        List<CodeforcesModel> listFuture = [];
        yield LoadingState();
        listPresent = await repository.getCodeforcesData('active-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield ActiveLoadedState(listContest: listPresent);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestEvent) {
      try {
        List<CodeforcesModel> listFuture = [];
        yield LoadingState();
        listFuture = await repository.getCodeforcesData('future-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield FutureLoadedState(listContest: listFuture);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
