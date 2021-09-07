import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/atcoder.dart';
import 'package:cp_ing/models/atcoder.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class AtcoderBloc extends Bloc<AtcoderEvent, AtcoderState> {
  AtcoderRepository repository;
  AtcoderBloc({required AtcoderState initialState, required this.repository})
      : super(AtcoderInitial()) {
    add(ActiveContestEvent());
  }

  @override
  Stream<AtcoderState> mapEventToState(
    AtcoderEvent event,
  ) async* {
    if (event is ActiveContestEvent) {
      try {
        List<AtcoderModel> listPresent = [];
        yield LoadingState();
        listPresent = await repository.getAtcoderData('active-contests');
        // list_future = await repository.getAtcoderData('future-contests');
        yield ActiveLoadedState(listContest: listPresent);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestEvent) {
      try {
        List<AtcoderModel> listFuture = [];
        yield LoadingState();
        listFuture = await repository.getAtcoderData('future-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield FutureLoadedState(listContest: listFuture);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
