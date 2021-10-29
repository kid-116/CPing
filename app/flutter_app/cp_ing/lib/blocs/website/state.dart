part of 'bloc.dart';

abstract class WebsiteState extends Equatable {
  const WebsiteState();

  @override
  List<Object> get props => [];
}

class WebsiteInitial extends WebsiteState {}

class LoadingState extends WebsiteState {}

class ActiveLoadedState extends WebsiteState {
  final List<Contest> contests;

  const ActiveLoadedState({required this.contests});

  @override
  List<Object> get props => [contests];
}

class FutureLoadedState extends WebsiteState {
  final List<Contest> contests;

  const FutureLoadedState({required this.contests});

  @override
  List<Object> get props => [contests];
}

class ActiveContestsEventStateCache extends WebsiteState {
  final List<Contest> contests;

  const ActiveContestsEventStateCache({required this.contests});

  @override
  List<Object> get props => [contests];
}

class FutureContestsEventStateCache extends WebsiteState {
  final List<Contest> contests;

  const FutureContestsEventStateCache({required this.contests});

  @override
  List<Object> get props => [contests];
}

class ErrorState extends WebsiteState {
  final String error;
  const ErrorState(this.error);
}

class RefreshedAPIState extends WebsiteState {}

class UserRatingsLoadedState extends WebsiteState implements Equatable {
  final List<UserRating> userRatings;
  int maxrating, minrating, noofcontests;
  UserRatingsLoadedState(
      {required this.userRatings,
      required this.maxrating,
      required this.minrating,
      required this.noofcontests});
  @override
  List<Object> get props => [userRatings];
}
