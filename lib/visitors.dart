import 'package:flutter/material.dart';
import 'package:industry/JournalMode.dart';
import 'package:industry/sqlitehelper.dart';
import 'package:industry/todolist.dart';
import 'package:industry/visitors_sqlite.dart';
import 'package:intl/intl.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  _VisitorsScreenState createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  List<String> todoList = [];
  String? selectedUnit;

  TextEditingController _dateController = TextEditingController();
  List<String> units = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4', 'Unit 5'];
  final TextEditingController todoController = TextEditingController();
  late DateTime _selectedDate= DateTime.now();

  List<JournalModel2> _journals2 = [];
  bool _isLoading = true;

  void _refreshJournals2() async {
    final data = await SQLHelper2.getItems();
    List<JournalModel2> journalsList2 = data.map((journalData) {
      return JournalModel2(
        id: journalData['id'],
        discussion: journalData['discussion'],

      );
    }).toList();

    setState(() {
      _journals2 = journalsList2;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals2();
  }

  final TextEditingController _discussionController = TextEditingController();


  void _showForm2(int? id) async {
    if (id != null) {
      final existingJournal = _journals2.firstWhere((element) => element.id == id);
      _discussionController.text = existingJournal.discussion;

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
              controller: _discussionController,
              decoration: const InputDecoration(hintText: 'Discussion'),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                _discussionController.text = '';

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    await SQLHelper2.createItem1(
      _discussionController.text,


    );
    _refreshJournals2();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper2.updateItem(
      id,
      _discussionController.text,

    );
    _refreshJournals2();
  }

  void _deleteItem(int id) async {
    await SQLHelper2.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted!'),
    ));
    _refreshJournals2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Visitors details'),
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
                  labelText: 'Name',
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
                decoration: InputDecoration(
                  labelText: 'Purpose of Visitation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                onChanged: (newValue) {
                  setState(() {
                    selectedUnit = newValue!;
                  });
                },
                items: units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select a unit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () => _showForm2(null),
                icon: Icon(Icons.add),
                label: Text('Discussions '),
              ),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _journals2.length,
                itemBuilder: (context, index) => Card(
                  color: Color(0xfff7f7f7),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(

                    title: Text(_journals2[index].discussion),

                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _updateItem(_journals2[index].id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals2[index].id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Instruction or Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Extras',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
            SizedBox(height: 12,),
            Center(child: ElevatedButton(style: ElevatedButton.styleFrom(
              fixedSize: Size(320,40)
            ),onPressed: (){}, child: Text("Save"))),
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
}
