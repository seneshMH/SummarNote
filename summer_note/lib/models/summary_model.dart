class Summary {
  final String title;
  final String body;

  Summary({required this.title, required this.body});

  // Convert Summary object to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  // Factory method to create a Summary object from a Map
  factory Summary.fromMap(Map<String, dynamic> map) {
    return Summary(
      title: map['title'],
      body: map['body'],
    );
  }
}
