import 'package:cping/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';

class GoogleSignIn implements UseCase<bool, Params> {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.googleSignIn();
  }
}

class Params extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}
