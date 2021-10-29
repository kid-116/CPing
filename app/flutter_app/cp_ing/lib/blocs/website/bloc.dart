import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cp_ing/firestore/cache.dart';
import 'package:cp_ing/models/rating.dart';
import 'package:equatable/equatable.dart';

import 'package:cp_ing/repositories/website.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    if (event is ActiveContestsEventCache) {
      try {
        List<Contest> presentcontests = [];
        yield LoadingState();
        // Fetching contests from Firebase (CACHE)
        presentcontests =
            await repository.getWebsiteContestsfromCache('active-contests');
        yield ActiveContestsEventStateCache(contests: presentcontests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is FutureContestsEventCache) {
      try {
        List<Contest> futurecontests = [];
        yield LoadingState();
        // Fetching contests from Firebase (CACHE)
        futurecontests =
            await repository.getWebsiteContestsfromCache('future-contests');
        yield FutureContestsEventStateCache(contests: futurecontests);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is RefreshContestsEvent) {
      try {
        // Calling the API which you update contests in the firebase
        await repository.addConteststoCache('active-contests');
        await repository.addConteststoCache('future-contests');
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is Getuserrating) {
      try {
        // Calling the API which you update contests in the firebase
        List<UserRating> userrating =
            await repository.getUserRating("sathu.hebbar");
        var maxrating = -2;
        var minrating = 1000000;
        for (var element in userrating) {
          maxrating =
              maxrating > element.oldRating ? maxrating : element.oldRating;
          minrating =
              minrating < element.oldRating ? minrating : element.oldRating;
        }
        yield UserRatingsLoadedState(
            userRatings: userrating,
            maxrating: maxrating,
            minrating: minrating,
            noofcontests: userrating.length);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    }
  }
}
