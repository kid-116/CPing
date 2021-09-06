part of 'codeforces_bloc.dart';

abstract class CodeforcesState extends Equatable {
  const CodeforcesState();

  @override
  List<Object> get props => [];
}

class CodeforcesInitial extends CodeforcesState {}

class LoadingState extends CodeforcesState {}

class ActiveLoadedState extends CodeforcesState {
  List<CodeforcesModel> list_contest;
  // List<CodeforcesModel> list_future;

  ActiveLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class FutureLoadedState extends CodeforcesState {
  List<CodeforcesModel> list_contest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class ErrorState extends CodeforcesState {
  String error;
  ErrorState(this.error);
}
