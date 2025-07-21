class Trip {
  final int id;
  final String title;
  final String description;
  final String tanggal;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.tanggal,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tanggal: json['tanggal'],
    );
  }
}
