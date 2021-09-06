part of 'codeforces_bloc.dart';

abstract class CodeforcesEvent extends Equatable {
  const CodeforcesEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends CodeforcesEvent {}

class Active_contest_event extends CodeforcesEvent {}

class Future_contest_event extends CodeforcesEvent {}
