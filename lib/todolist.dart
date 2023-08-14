import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industry/JournalMode.dart';
import 'package:industry/sqlitehelper.dart';
import 'package:industry/visitors_sqlite.dart';

class todolist extends StatelessWidget {
  const todolist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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


  void _showForm(int? id) async {
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
              decoration: const InputDecoration(hintText: 'Title'),
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
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
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
                    onPressed: () => _showForm(_journals2[index].id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(_journals2[index].id),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
