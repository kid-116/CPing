part of 'bloc.dart';

abstract class AtcoderEvent extends Equatable {
  const AtcoderEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends AtcoderEvent {}

class ActiveContestEvent extends AtcoderEvent {}

class FutureContestEvent extends AtcoderEvent {}
