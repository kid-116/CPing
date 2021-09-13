import 'package:cp_ing/blocs/authentication/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis/calendar/v3.dart';

Future loadClient() async {
  try {
    // print('getting client');
    final user = await GoogleSignIn().signIn();
    final authHeaders = await user!.authHeaders;
    final client = GoogleAuthClient(authHeaders);
    CalendarClient.calendar = cal.CalendarApi(client);
    // print(CalendarClient.calendar);
  } catch (e) {
    print('client could not be loaded');
    print(e);
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
        print("Event status: ${value.status}");
        if (value.status == 'confirmed') {
          String eventId = value.id;
          eventData = {'id': eventId};
        } else {
          print("Unable to add event to Google Calendar");
        }
      });
    } catch (e) {
      print("Error creating event: $e");
    }
    return eventData;
  }

  // Future<Map<String, String>> modify({
  //   required String id,
  //   required String title,
  //   required DateTime startTime,
  //   required DateTime endTime
  // }) async {
  //   Map<String, String> eventData = {};
  //
  //   String calendarId = 'primary';
  //
  //   Event event = createEvent(title, startTime, endTime);
  //
  //   try {
  //     await loadClient();
  //     await calendar.events
  //         .patch(event, calendarId, id)
  //         .then((value) {
  //           print("Event status: ${value.status}");
  //           if (value.status == 'confirmed') {
  //             String eventId = value.id;
  //             eventData = {
  //               'id': eventId
  //             };
  //           } else {
  //             print("Unable to update event to Google Calendar");
  //           }
  //         });
  //   } catch(e) {
  //     print("Error updating event: $e");
  //   }
  //
  //   return eventData;
  // }

  Future<void> delete(String eventId) async {
    String calendarId = 'primary';

    try {
      await loadClient();
      await calendar.events.delete(calendarId, eventId).then((value) {
        print("Event deleted from Google Calendar");
      });
    } catch (e) {
      print("Error deleting event: $e");
    }
  }
}
