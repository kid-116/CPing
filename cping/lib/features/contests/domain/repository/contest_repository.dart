import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import '../../../../core/error/failures.dart';

abstract class ContestsRepository {
  Future<Either<Failure, List<Contest>>> getAllContests(int platformId);
  Future<Either<Failure, List<Contest>>> getRegisteredContests();
  Future<Either<Failure, Map<String, String>>> addEvent(
      String name,
      DateTime startTime,
      int length,
      ValueNotifier<String> isRegistered,
      String site,
      String contestId);
  Future<Either<Failure, bool>> deleteEvent(
      String calendarID, String contestId, ValueNotifier<String> isRegistered);
  // Future<Either<Failure, bool>> registerContest(String contestId);
}
