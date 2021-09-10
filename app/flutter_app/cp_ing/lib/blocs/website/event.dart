part of 'bloc.dart';

abstract class WebsiteEvent extends Equatable {
  const WebsiteEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends WebsiteEvent {}

class ActiveContestsEvent extends WebsiteEvent {}

class FutureContestsEvent extends WebsiteEvent {}