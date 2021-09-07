part of 'bloc.dart';

abstract class CodechefEvent extends Equatable {
  const CodechefEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends CodechefEvent {}

class ActiveContestEvent extends CodechefEvent {}

class FutureContestEvent extends CodechefEvent {}
