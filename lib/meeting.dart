import 'package:flutter/material.dart';
import 'package:industry/JournalMode.dart';
import 'package:industry/sqlite_resposible_person.dart';
import 'package:industry/sqlitehelper.dart';
import 'package:intl/intl.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}
@override
class _MeetingsScreenState extends State<MeetingsScreen> {
  List<String> todoList = [];
  List<JournalModel> _journals = [];
  List<JournalModel1> _journals1 = [];
  bool isMeetingStarted = false;
  String startTime = '';
  String endTime = '';
  bool _isLoading = true;
  List<Map<String, String>> _responsiblePersons = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _responsibilityController = TextEditingController();
  final TextEditingController _timeframeController = TextEditingController();
  final TextEditingController todoController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  late DateTime _selectedDate= DateTime.now();

  void toggleMeeting() {
    setState(() {
      if (isMeetingStarted) {
        endTime = DateFormat('hh:mm a').format(DateTime.now());
      } else {
        startTime = DateFormat('hh:mm a').format(DateTime.now());
      }
      isMeetingStarted = !isMeetingStarted;
    });
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    List<JournalModel> journalsList = data.map((journalData) {
      return JournalModel(
        id: journalData['id'],
        title: journalData['title'],
        description: journalData['description'],
        isDone: journalData['isDone'] == 1,
      );
    }).toList();

    setState(() {
      _journals = journalsList;
      _isLoading = false;
    });
  }

  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    List<JournalModel1> journalsList1 = data.map((journalData) {
      return JournalModel1(
        id: journalData['id'],
        name: journalData['name'],
        agenda: journalData['agenda'],
        responsibility: journalData['responsibility'],
        timeframe: journalData['timeframe'],
      );
    }).toList();

    setState(() {
      _journals1 = journalsList1;

    });
  }
  @override
  void initState() {
    super.initState();
    _refreshJournals();
    _refreshJournals1();
  }
  void _showForm1(int? id) async {
    if (id != null) {
      final existingJournal1 = _journals1.firstWhere((element) => element.id == id);
      _nameController.text = existingJournal1.name;
      _agendaController.text = existingJournal1.agenda;
      _responsibilityController.text = existingJournal1.responsibility;
      _timeframeController.text = existingJournal1.timeframe;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _agendaController,
              decoration: const InputDecoration(hintText: 'Agenda'),
            ),
            TextField(
              controller: _responsibilityController,
              decoration: const InputDecoration(hintText: 'Responsibilities'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(hintText: 'Time frame'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem1();
                }

                if (id != null) {
                  await _updateItem1(id);
                }

                _nameController.text = '';
                _agendaController.text = '';
                _responsibilityController.text = '';
                _timeframeController.text = '';
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Assign' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal = _journals.firstWhere((element) => element.id == id);
      _titleController.text = existingJournal.title;
      _descriptionController.text = existingJournal.description;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Agenda'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Discusion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                _titleController.text = '';
                _descriptionController.text = '';
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _addItem1() async {
    await SQLHelper1.createItem1(
      _nameController.text,
      _agendaController.text,
      _responsibilityController.text,
    _timeframeController.text
  // New item is not done by default
    );
    _refreshJournals1();
  }


  Future<void> _addItem() async {
    await SQLHelper.createItem(
      _titleController.text,
      _descriptionController.text,
      isDone: false, // New item is not done by default
    );
    _refreshJournals();
  }

  Future<void> _updateItem1(int id) async {
    await SQLHelper1.updateItem(
      id,
         _nameController.text,
        _agendaController.text,
        _responsibilityController.text,
        _timeframeController.text

    );
    _refreshJournals1();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
      isDone: _journals.firstWhere((journal) => journal.id == id).isDone,
    );
    _refreshJournals();
  }

  void _deleteItem1(int id) async {
    await SQLHelper1.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted!'),
    ));
    _refreshJournals1();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted!'),
    ));
    _refreshJournals();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Meeting details',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),),
        actions: [
        Container(
        color: Colors.green, // Change background color to green
        padding: EdgeInsets.all(7.0), // Add some padding
        child: Row(
          children: [
            IconButton(
              icon: Icon(isMeetingStarted ? Icons.stop : Icons.play_arrow),
              onPressed: toggleMeeting,
              color: Colors.white, // Icon color
            ),
            SizedBox(width: 8.0),
            Text(
              isMeetingStarted ? 'Meeting in progress' : 'Start Meeting',
              style: TextStyle(
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
             // Add spacing between text and icon

          ],
        ),
      )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'Select date...',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffbcbcbc),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                onTap: () {
                  _pickDate(context);
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                readOnly: true,
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'Select time...',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xffbcbcbc),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                onTap: () {
                  _pickTime(context);
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton.icon(
                    onPressed: () => _showForm(null),
                  icon: Icon(Icons.add),
                  label: Text('Add Agenda '),
                ),
              ),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  color: Color(0xfff7f7f7),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    leading: Checkbox(
                      value: _journals[index].isDone,
                      onChanged: (newValue) {
                        setState(() {
                          _journals[index].isDone = newValue!;
                        });
                        // Here you can call a function to update the completion status in the database
                      },
                    ),
                    title: Text(_journals[index].title),
                    subtitle: Text(_journals[index].description),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(_journals[index].id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index].id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(
                height: 20,
              ),


              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showForm1(null),
                  icon: Icon(Icons.add),
                  label: Text('Add Responsible person '),
                ),
              ),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _journals1.length,
                itemBuilder: (context, index) => Card(
                  color: Color(0xfff7f7f7),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_journals1[index].name),
                    subtitle: Text(_journals1[index].timeframe),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm1(_journals1[index].id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem1(_journals1[index].id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12,),

              // Display the responsible person details

              TextField(
                decoration: InputDecoration(
                  labelText: 'Conclusion',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Time: $startTime',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      'End Time: $endTime',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Center(child: ElevatedButton(onPressed: (){}, child: Text("Save"))),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(Duration(days: 0)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // User selected a time, update the text in the TextField.
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }
  
}

class _MeetingButton extends StatelessWidget {
  final bool isMeetingStarted;
  final VoidCallback toggleMeeting;

  _MeetingButton({
    required this.isMeetingStarted,
    required this.toggleMeeting,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isMeetingStarted ? Icons.stop : Icons.play_arrow),
      onPressed: toggleMeeting,
    );
  }
}


