part of 'contests_bloc.dart';

abstract class ContestsState extends Equatable {
  const ContestsState();

  @override
  List<Object> get props => [];
}

class ContestsInitial extends ContestsState {}

class ContestsLoading extends ContestsState {}

class ContestsLoaded extends ContestsState {
  final List<Contest> contests;

  ContestsLoaded({required this.contests});

  @override
  List<Object> get props => [contests];
}

class ContestsError extends ContestsState {
  final String error;

  ContestsError({required this.error});

  @override
  List<Object> get props => [error];
}

class ContestRegistered extends ContestsState {
  final String message;

  ContestRegistered({required this.message});

  @override
  List<Object> get props => [message];
}

class ContestUnregistered extends ContestsState {
  final String message;

  ContestUnregistered({required this.message});

  @override
  List<Object> get props => [message];
}
