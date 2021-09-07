part of 'bloc.dart';

abstract class CodechefState extends Equatable {
  const CodechefState();

  @override
  List<Object> get props => [];
}

class CodechefInitial extends CodechefState {}

class LoadingState extends CodechefState {}

class ActiveLoadedState extends CodechefState {
  List<CodechefModel> listContest;
  // List<CodechefModel> list_future;

  ActiveLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class FutureLoadedState extends CodechefState {
  List<CodechefModel> listContest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class ErrorState extends CodechefState {
  String error;
  ErrorState(this.error);
}
