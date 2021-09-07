// ignore_for_file: must_be_immutable

part of 'bloc.dart';

abstract class CodeforcesState extends Equatable {
  const CodeforcesState();

  @override
  List<Object> get props => [];
}

class CodeforcesInitial extends CodeforcesState {}

class LoadingState extends CodeforcesState {}

class ActiveLoadedState extends CodeforcesState {
  List<CodeforcesModel> listContest;
  // List<CodeforcesModel> list_future;

  ActiveLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class FutureLoadedState extends CodeforcesState {
  List<CodeforcesModel> listContest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class ErrorState extends CodeforcesState {
  String error;
  ErrorState(this.error);
}
