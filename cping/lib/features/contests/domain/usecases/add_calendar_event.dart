import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/domain/repository/contest_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';

class AddToCalendar implements UseCase<Map<String, String>, Params> {
  final ContestsRepository repository;

  AddToCalendar(this.repository);

  @override
  Future<Either<Failure, Map<String, String>>> call(Params params) async {
    return await repository.addEvent(params.title, params.startTime,
        params.length, params.isRegistered, params.site, params.contestId);
  }
}

class Params extends Equatable {
  final String title;
  final DateTime startTime;
  final int length;
  final ValueNotifier<String> isRegistered;
  final String site;
  final String contestId;
  Params(
      {required this.title,
      required this.startTime,
      required this.length,
      required this.isRegistered,
      required this.site,
      required this.contestId});
  @override
  List<Object?> get props => throw UnimplementedError();
}
