import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

Future loadClient() async {
  try {
    final user = await GoogleSignIn().signIn();
    final authHeaders = await user!.authHeaders;
    final client = GoogleAuthClient(authHeaders);
    CalendarClient.calendar = cal.CalendarApi(client);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Event createEvent(String title, DateTime startTime, DateTime endTime) {
  Event event = Event();
  event.summary = title;
  event.start = createEventDateTime(startTime);
  event.end = createEventDateTime(endTime);

  return event;
}

EventDateTime createEventDateTime(DateTime time) {
  EventDateTime eventTime = EventDateTime();
  eventTime.dateTime = time;
  eventTime.timeZone = DateTime.now().timeZoneName;

  return eventTime;
}

class CalendarClient {
  static dynamic calendar;

  Future<Map<String, String>> insert(
      {required String title,
      required DateTime startTime,
      required DateTime endTime}) async {
    Map<String, String> eventData = {};

    String calendarId = 'primary';

    Event event = createEvent(title, startTime, endTime);

    try {
      await loadClient();
      await calendar.events.insert(event, calendarId).then((value) {
        if (value.status == 'confirmed') {
          String eventId = value.id;
          eventData = {'id': eventId};
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return eventData;
  }

  Future<void> delete(String eventId) async {
    String calendarId = 'primary';

    try {
      await loadClient();
      await calendar.events.delete(calendarId, eventId).then((value) {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
