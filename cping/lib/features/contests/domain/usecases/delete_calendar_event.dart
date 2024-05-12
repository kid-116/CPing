import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/domain/repository/contest_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';

class DeleteFromCalendar implements UseCase<bool, Params> {
  final ContestsRepository repository;

  DeleteFromCalendar(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.deleteEvent(
        params.calendarId, params.contestId, params.isRegistered);
  }
}

class Params extends Equatable {
  final String calendarId;
  final String contestId;
  final ValueNotifier<String> isRegistered;
  Params(
      {required this.calendarId,
      required this.contestId,
      required this.isRegistered});
  @override
  List<Object?> get props => throw UnimplementedError();
}
