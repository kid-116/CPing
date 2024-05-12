import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cping/features/contests/data/datasources/contest_remote_datasource.dart';
import 'package:cping/features/contests/data/repositories/contest_repository_impl.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/domain/repository/contest_repository.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/get_contests.dart';

part 'contests_event.dart';
part 'contests_state.dart';

class ContestsBloc extends Bloc<ContestsEvent, ContestsState> {
  ContestsBloc() : super(ContestsInitial()) {
    on<ContestsEvent>((event, emit) async {
      if (event is GetContestsEvent) {
        emit(ContestsLoading());
        final GetContests getContests = GetContests(ContestsRepositoryImpl(
            remoteDataSource: ContestsRemoteDataSourceImpl()));

        final contests =
            await getContests.call(Params(platformId: event.platformId));
        contests.fold((l) {
          emit(ContestsError(error: l.toString()));
        }, (r) {
          emit(ContestsLoaded(contests: r));
        });
      }
    });
  }
}
