part of 'bloc.dart';

abstract class WebsiteEvent extends Equatable {
  const WebsiteEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends WebsiteEvent {}

class RefreshContestsEvent extends WebsiteEvent {}

class GetContestsEvent extends WebsiteEvent {}
