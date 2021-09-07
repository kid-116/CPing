part of 'bloc.dart';

abstract class CodeforcesEvent extends Equatable {
  const CodeforcesEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends CodeforcesEvent {}

class ActiveContestEvent extends CodeforcesEvent {}

class FutureContestEvent extends CodeforcesEvent {}
