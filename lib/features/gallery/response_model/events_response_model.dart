class EventsResponseModel {
  List<Event> events;
  EventsResponseModel({required this.events});

  factory EventsResponseModel.fromJson(Map<String, dynamic> json) =>
      EventsResponseModel(
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  final String name;
  final DateTime date;
  final String time;

  Event({required this.name, required this.date, required this.time});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'time': time,
    };
  }
}

List<Event> events = [
  {"name": "Sample Event", "date": "2024-10-23T12:00:00", "time": "12:00"},
  {"name": "Hello_Mani", "date": "2024-10-10", "time": "10:00"},
  {"name": "Event_MM", "date": "2024-10-08", "time": "15:20"},
  {"name": "Event@Campaign", "date": "2024-12-03", "time": "18:00"},
  {"name": "YSJaganMark", "date": "2025-01-29", "time": "12:00"},
  {"name": "Test upload", "date": "2025-01-15", "time": "23:22"},
  {"name": "Fee Poru", "date": "2025-03-12", "time": "10:00"}
].map((event) => Event.fromJson(event)).toList();
