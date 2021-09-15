import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cp_ing/repositories/website.dart';
import 'package:cp_ing/models/contest.dart';

part 'event.dart';
part 'state.dart';

class WebsiteBloc extends Bloc<WebsiteEvent, WebsiteState> {
  WebsiteRepository repository;

  WebsiteBloc({
    required WebsiteState initialState,
    required this.repository,
  }) : super(WebsiteInitial()) {
    // add(ActiveContestsEvent());
  }

  @override
  Stream<WebsiteState> mapEventToState(
      WebsiteEvent event,
  ) async* {
    if (event is ActiveContestsEvent) {
      try {
        List<Contest> presentContests = [];
        yield LoadingState();
        presentContests = await repository.getWebsiteContests('active-contests');
        yield ActiveLoadedState(contests: presentContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestsEvent) {
      try {
        List<Contest> futureContests = [];
        yield LoadingState();
        futureContests = await repository.getWebsiteContests('future-contests');
        yield FutureLoadedState(contests: futureContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
