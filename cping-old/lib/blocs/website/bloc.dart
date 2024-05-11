import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/website.dart';
import '../../models/contest.dart';

part 'event.dart';
part 'state.dart';

class WebsiteBloc extends Bloc<WebsiteEvent, WebsiteState> {
  WebsiteRepository repository;
  late String currentTab;

  WebsiteBloc({
    required WebsiteState initialState,
    required this.repository,
  }) : super(WebsiteInitial()) {
    on<WebsiteEvent>((event, emit) async {
      if (event is GetContestsEvent) {
        try {
          List<Contest> contests = [];
          emit(LoadingState());
          contests = await repository.getContestsFromCache();
          emit(ContestsLoadedState(
              contests: contests,
              isOutdated: await repository.checkLastUpdate()));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      } else if (event is RefreshContestsEvent) {
        try {
          await repository.updateCache();
          emit(RefreshedCacheState());
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
    });
  }
}
