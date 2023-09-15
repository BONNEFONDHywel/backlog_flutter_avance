class SoireeData {
  final String title;
  final String imagePath;
  final String type;
  final String statut;
  final DateTime? datetime;
  final List<String> comments;
  final List<String> participants;

  SoireeData({required this.title, required this.imagePath,required this.type,required this.datetime, this.comments = const [],this.participants = const [],  this.statut =  'Pending'});
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'picture': imagePath,
      'type': type,
      'statut': statut,
      'comments': comments,
    "datetime":datetime,
    'participants': participants
    };
  }
}