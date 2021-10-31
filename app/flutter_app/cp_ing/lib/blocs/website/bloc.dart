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
  }) : super(WebsiteInitial());

  @override
  Stream<WebsiteState> mapEventToState(
    WebsiteEvent event,
  ) async* {
    if (event is ActiveContestsEventCache) {
      try {
        List<Contest> activeContests = [];
        yield LoadingState();
        activeContests =
            await repository.getContestsFromCache('active-contests');
        yield ActiveContestsEventStateCache(contests: activeContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestsEventCache) {
      try {
        List<Contest> futureContests = [];
        yield LoadingState();
        futureContests =
            await repository.getContestsFromCache('future-contests');
        yield FutureContestsEventStateCache(contests: futureContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is RefreshContestsEvent) {
      try {
        yield RefreshedCacheState();
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
