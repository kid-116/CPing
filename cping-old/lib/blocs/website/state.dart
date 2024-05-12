part of 'bloc.dart';

abstract class WebsiteState extends Equatable {
  const WebsiteState();

  @override
  List<Object> get props => [];
}

class WebsiteInitial extends WebsiteState {}

class LoadingState extends WebsiteState {}

class ContestsLoadedState extends WebsiteState {
  final List<Contest> contests;
  final bool isOutdated;
  const ContestsLoadedState({required this.contests, required this.isOutdated});

  @override
  List<Object> get props => [contests];
}

class ErrorState extends WebsiteState {
  final String error;
  const ErrorState(this.error);
}

class RefreshedCacheState extends WebsiteState {}
