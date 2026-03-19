class Events {
  List<Event> events;

  Events({required this.events});

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
        events: (json['data']['items'] as List)
            .map((e) => Event.fromJson(e))
            .toList());
  }
}

class Event {
  final int? id;
  final String? title;
  final String? date;
  final String? day;
  final String? startDate;
  final String? description;
  final String? image;
  final int? going;
  final int? appreciate;
  final int? youGoing;
  final int? youAppreciate;

  Event(
      {this.id,
      this.title,
      this.day,
      this.date,
      this.description,
      this.image,
      this.startDate,
      this.going,
      this.appreciate,
      this.youGoing,
      this.youAppreciate});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title'],
      date: json['date'],
      day: json['day'],
      startDate: json['start_date'],
      description: json['description'],
      image: json['attachment_file'],
      going: json['going'] != null ? int.tryParse(json['going'].toString()) : null,
      appreciate: json['appreciate'] != null ? int.tryParse(json['appreciate'].toString()) : null,
      youGoing: json['you_going'] != null ? int.tryParse(json['you_going'].toString()) : null,
      youAppreciate: json['you_appreciate'] != null ? int.tryParse(json['you_appreciate'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': title,
      'date': date,
      'description': description,
      'start_date': startDate,
      'attachment_file': image,
      'going': going,
      'appreciate': appreciate,
      'you_going': youGoing,
      'you_appreciate': youAppreciate,
    };
  }
}
