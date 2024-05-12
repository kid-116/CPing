import 'dart:async';
import 'dart:io';
import 'package:cping/config/constants.dart';
import 'package:cping/features/contests/data/datasources/calendar_client.dart';
import 'package:cping/features/contests/data/datasources/firestore_service.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:flutter/material.dart';
import '../../../../../core/error/exceptions.dart';

abstract class ContestsRemoteDataSource {
  Future<List<Contest>> getAllContests(int platformId);
  Future<List<Contest>> getRegisteredContests();
  Future<Map<String, String>> addEvent(
      String name,
      DateTime startTime,
      int length,
      ValueNotifier<String> isRegistered,
      String site,
      String contestId);
  Future<bool> deleteEvent(
      String calendarID, String contestId, ValueNotifier<String> isRegistered);
}

class ContestsRemoteDataSourceImpl implements ContestsRemoteDataSource {
  @override
  Future<List<Contest>> getAllContests(int platformId) async {
    try {
      List<Contest> contests = <Contest>[];
      contests = await FirestoreService.getContests(
        site: platformMapping[platformId]!,
      );
      print("Got contests");
      return contests;
    } on SocketException {
      throw NetworkException();
    }
  }

  @override
  Future<List<Contest>> getRegisteredContests() async {
    try {
      List<Contest> contests = <Contest>[];
      contests = await FirestoreService.getRegisteredContests();
      return contests;
    } on SocketException {
      throw NetworkException();
    }
  }

  @override
  Future<Map<String, String>> addEvent(
      String name,
      DateTime startTime,
      int length,
      ValueNotifier<String> isRegistered,
      String site,
      String contestId) async {
    try {
      isRegistered.value = "loading";
      final timeDifference = Duration(seconds: length);
      final endTime = startTime.add(timeDifference);

      CalendarClient client = CalendarClient();

      final contest = await client.insert(
        title: name,
        startTime: startTime,
        endTime: endTime,
      );

      final docId = await FirestoreService.addContest(
          calendarId: contest['id'].toString(),
          contestId: contestId,
          site: site,
          name: name,
          startTime: startTime,
          length: length);
      Map<String, String> result = {
        'contestId': contest['id'].toString(),
        'docId': docId,
        'name': name,
      };
      isRegistered.value = "true";
      return result;
    } on SocketException {
      throw NetworkException();
    }
  }

  @override
  Future<bool> deleteEvent(String calendarId, String contestId,
      ValueNotifier<String> isRegistered) async {
    try {
      isRegistered.value = "loading";
      CalendarClient client = CalendarClient();
      await client.delete(calendarId);
      await FirestoreService.deleteContest(docId: contestId);
      isRegistered.value = "false";
      return true;
    } on SocketException {
      throw NetworkException();
    }
  }
}
