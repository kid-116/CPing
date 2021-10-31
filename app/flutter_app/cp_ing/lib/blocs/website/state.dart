part of 'bloc.dart';

abstract class WebsiteState extends Equatable {
  const WebsiteState();

  @override
  List<Object> get props => [];
}

class WebsiteInitial extends WebsiteState {}

class LoadingState extends WebsiteState {}

class ActiveContestsEventState extends WebsiteState {
  final List<Contest> contests;

  const ActiveContestsEventState({required this.contests});

  @override
  List<Object> get props => [contests];
}

class FutureContestsEventState extends WebsiteState {
  final List<Contest> contests;

  const FutureContestsEventState({required this.contests});

  @override
  List<Object> get props => [contests];
}

class ErrorState extends WebsiteState {
  final String error;
  const ErrorState(this.error);
}

class RefreshedCacheState extends WebsiteState {
  final String currentTab;

  const RefreshedCacheState({required this.currentTab});
}