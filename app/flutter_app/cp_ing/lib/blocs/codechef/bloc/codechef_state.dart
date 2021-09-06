part of 'codechef_bloc.dart';

abstract class CodechefState extends Equatable {
  const CodechefState();

  @override
  List<Object> get props => [];
}

class CodechefInitial extends CodechefState {}

class LoadingState extends CodechefState {}

class ActiveLoadedState extends CodechefState {
  List<CodechefModel> list_contest;
  // List<CodechefModel> list_future;

  ActiveLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class FutureLoadedState extends CodechefState {
  List<CodechefModel> list_contest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class ErrorState extends CodechefState {
  String error;
  ErrorState(this.error);
}
