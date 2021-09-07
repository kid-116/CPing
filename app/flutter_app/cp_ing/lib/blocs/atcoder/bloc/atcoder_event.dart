part of 'atcoder_bloc.dart';

abstract class AtcoderEvent extends Equatable {
  const AtcoderEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends AtcoderEvent {}

class Active_contest_event extends AtcoderEvent {}

class Future_contest_event extends AtcoderEvent {}
