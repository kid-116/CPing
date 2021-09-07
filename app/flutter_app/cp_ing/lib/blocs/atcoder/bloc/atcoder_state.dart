part of 'atcoder_bloc.dart';

abstract class AtcoderState extends Equatable {
  const AtcoderState();

  @override
  List<Object> get props => [];
}

class AtcoderInitial extends AtcoderState {}

class LoadingState extends AtcoderState {}

class ActiveLoadedState extends AtcoderState {
  List<AtcoderModel> list_contest;
  // List<CodechefModel> list_future;

  ActiveLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class FutureLoadedState extends AtcoderState {
  List<AtcoderModel> list_contest;
  // List<CodechefModel> list_future;

  FutureLoadedState({required this.list_contest});
  @override
  List<Object> get props => [list_contest];
}

class ErrorState extends AtcoderState {
  String error;
  ErrorState(this.error);
}
