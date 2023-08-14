
class JournalModel {
  final int id;
  final String title;
  final String description;
  bool isDone;

  JournalModel({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });
}
class JournalModel1 {
  final int id;
  final String name;
  final String agenda;
  final String responsibility;
  final String timeframe;

  JournalModel1({
    required this.id,
    required this.name,
    required this.agenda,
    required this.responsibility,
    required this.timeframe
  });
}
class JournalModel2 {
  final int id;
  final String discussion;


  JournalModel2({
    required this.id,
    required this.discussion,
  });
}

class MeetingJournal {
  final int id;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String agenda;
  final String discussion;
  final String responsiblePerson;


  MeetingJournal({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.agenda,
    required this.discussion,
    required this.responsiblePerson,

  });
}
