part of 'contests_bloc.dart';

abstract class ContestsEvent extends Equatable {
  const ContestsEvent();

  @override
  List<Object> get props => [];
}

class GetContestsEvent extends ContestsEvent {
  final int platformId;

  GetContestsEvent({required this.platformId});

  @override
  List<Object> get props => [platformId];
}

class GetRegisteredContestsEvent extends ContestsEvent {
  @override
  List<Object> get props => [];
}

class RegisterContestEvent extends ContestsEvent {
  final String contestId;

  RegisterContestEvent({required this.contestId});

  @override
  List<Object> get props => [contestId];
}

class UnregisterContestEvent extends ContestsEvent {
  final String contestId;

  UnregisterContestEvent({required this.contestId});

  @override
  List<Object> get props => [contestId];
}
