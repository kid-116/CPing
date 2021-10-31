import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cp_ing/repositories/website.dart';
import 'package:cp_ing/models/contest.dart';
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
    if (event is GetContestsEvent) {
      try {
        List<Contest> contests = [];
        yield LoadingState();
        contests =
            await repository.getContestsFromCache();
        yield ContestsLoadedState(contests: contests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is RefreshContestsEvent) {
      try {
        // yield LoadingState();
        await repository.updateCache();
        yield RefreshedCacheState();
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
