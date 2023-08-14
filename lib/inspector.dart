import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class InspectorScreen extends StatefulWidget {
  const InspectorScreen({Key? key}) : super(key: key);

  @override
  _InspectorScreenState createState() => _InspectorScreenState();
}

class _InspectorScreenState extends State<InspectorScreen> {
  List<String> todoList = [];
  String? selectedUnit;
  final ImagePicker _imagePicker = ImagePicker();
  List<String> units = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4', 'Unit 5'];
  final TextEditingController todoController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  File? _selectedImage;
  bool isImagePickerActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text('Visitors details'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Inspectors Name',
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Purpose of inspection',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Extras',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: const Color(0xffc6c6c6)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Add Image',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                  SizedBox(width: 172),
                  ElevatedButton(
                    onPressed: () => captureImage(),
                    child: Text(
                      '+',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                    ),
                  ),
                ],
              ),

              // Display the image container only when an image is selected.
              if (_selectedImage != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(_selectedImage!),
                ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(320, 40)),
                onPressed: () {},
                child: Text("Save"),
              ),
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

  Future<File?> saveImage(File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderName = 'images'; // Replace with your desired folder name
      final folder = Directory('${directory.path}/$folderName');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      final imagePath = '${folder.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await file.copy(imagePath);
      return savedImage;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  Future<void> captureImage() async {
    isImagePickerActive = true;
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    isImagePickerActive = false;
    if (image != null) {
      final file = File(image.path);
      final savedImage = await saveImage(file);
      setState(() {
        _selectedImage = savedImage;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: InspectorScreen(),
  ));
}
