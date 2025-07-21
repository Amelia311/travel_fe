class Itinerary {
  final int id;
  final int tripId;
  final String date;
  final String startTime;
  final String activity;

  Itinerary({
    required this.id,
    required this.tripId,
    required this.date,
    required this.startTime,
    required this.activity,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      tripId: json['trip_id'],
      date: json['date'],
      startTime: json['start_time'] ?? '',
      activity: json['activity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'date': date,
      'start_time': startTime,
      'activity': activity,
    };
  }
}
