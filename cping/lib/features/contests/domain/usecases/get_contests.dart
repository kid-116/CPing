import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/domain/repository/contest_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';

class GetContests implements UseCase<List<Contest>, Params> {
  final ContestsRepository repository;

  GetContests(this.repository);

  @override
  Future<Either<Failure, List<Contest>>> call(Params params) async {
    return await repository.getAllContests(params.platformId);
  }
}

class Params extends Equatable {
  final int platformId;

  Params({required this.platformId});
  @override
  List<Object?> get props => throw UnimplementedError();
}
