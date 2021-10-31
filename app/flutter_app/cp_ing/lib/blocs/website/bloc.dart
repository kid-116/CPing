import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cp_ing/repositories/website.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';

part 'state.dart';

class WebsiteBloc extends Bloc<WebsiteEvent, WebsiteState> {
  WebsiteRepository repository;
  late String currentTab;

  WebsiteBloc({
    required WebsiteState initialState,
    required this.repository,
  }) : super(WebsiteInitial());

  @override
  Stream<WebsiteState> mapEventToState(
    WebsiteEvent event,
  ) async* {
    if (event is ActiveContestsEvent) {
      currentTab = 'A';
      try {
        debugPrint("inside active");
        List<Contest> activeContests = [];
        yield LoadingState();
        activeContests =
            await repository.getContestsFromCache('active-contests');
        debugPrint("bloc:");
        debugPrint(activeContests.toString());
        yield ActiveContestsEventState(contests: activeContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestsEvent) {
      currentTab = 'F';
      try {
        List<Contest> futureContests = [];
        yield LoadingState();
        futureContests =
            await repository.getContestsFromCache('future-contests');
        // debugPrint("bloc:");
        // debugPrint(futureContests.toString());
        yield FutureContestsEventState(contests: futureContests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is RefreshContestsEvent) {
      try {
        yield LoadingState();
        debugPrint("outdated cache");
        await repository.updateCache();
        yield RefreshedCacheState(currentTab: currentTab);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
