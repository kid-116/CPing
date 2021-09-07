import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/Repositories/atcoder_repository.dart';
import 'package:cp_ing/models/atcoder_model.dart';
import 'package:equatable/equatable.dart';

part 'atcoder_event.dart';
part 'atcoder_state.dart';

class AtcoderBloc extends Bloc<AtcoderEvent, AtcoderState> {
  AtcoderRepository repository;
  AtcoderBloc({required AtcoderState initialState, required this.repository})
      : super(AtcoderInitial()) {
    add(Active_contest_event());
  }

  @override
  Stream<AtcoderState> mapEventToState(
    AtcoderEvent event,
  ) async* {
    if (event is Active_contest_event) {
      try {
        List<AtcoderModel> list_present = [];
        yield LoadingState();
        list_present = await repository.getAtcoderData('active-contests');
        // list_future = await repository.getAtcoderData('future-contests');
        yield ActiveLoadedState(list_contest: list_present);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is Future_contest_event) {
      try {
        List<AtcoderModel> list_future = [];
        yield LoadingState();
        list_future = await repository.getAtcoderData('future-contests');
        // list_future = await repository.getCodeforcesData('future-contests');
        yield FutureLoadedState(list_contest: list_future);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
