import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> googleSignIn();
  Future<Either<Failure, bool>> logOut();
}
