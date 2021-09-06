part of 'codechef_bloc.dart';

abstract class CodechefEvent extends Equatable {
  const CodechefEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends CodechefEvent {}

class Active_contest_event extends CodechefEvent {}

class Future_contest_event extends CodechefEvent {}
