import 'package:cping/features/contests/data/datasources/contest_remote_datasource.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/domain/repository/contest_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';

class ContestsRepositoryImpl implements ContestsRepository {
  final ContestsRemoteDataSource remoteDataSource;

  ContestsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Contest>>> getAllContests(int platformId) async {
    try {
      List<Contest> result = await remoteDataSource.getAllContests(platformId);

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Contest>>> getRegisteredContests() async {
    try {
      List<Contest> result = await remoteDataSource.getRegisteredContests();
      return Right(result);
      // final result = await remoteDataSource.logOut();
      // return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> addEvent(
      String name,
      DateTime startTime,
      int length,
      ValueNotifier<String> isRegistered) async {
    try {
      final result = await remoteDataSource.addEvent(
          name, startTime, length, isRegistered);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    }
  }
}
