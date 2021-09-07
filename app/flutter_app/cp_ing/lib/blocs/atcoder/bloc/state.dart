// ignore_for_file: must_be_immutable

part of 'bloc.dart';

abstract class AtcoderState extends Equatable {
  const AtcoderState();

  @override
  List<Object> get props => [];
}

class AtcoderInitial extends AtcoderState {}

class LoadingState extends AtcoderState {}

class ActiveLoadedState extends AtcoderState {
  List<AtcoderModel> listContest;
  // List<CodechefModel> list_future;

  ActiveLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class FutureLoadedState extends AtcoderState {
  List<AtcoderModel> listContest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.listContest});
  @override
  List<Object> get props => [listContest];
}

class ErrorState extends AtcoderState {
  String error;
  ErrorState(this.error);
}
