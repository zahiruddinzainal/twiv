import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ContactDetails extends StatefulWidget {
  final Map<String, dynamic> user;

  ContactDetails({required this.user});

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late Map<String, dynamic> editedUser;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late DateTime? dob;

  @override
  void initState() {
    super.initState();
    editedUser = Map.from(widget.user);
    firstNameController = TextEditingController(text: editedUser['firstName']);
    lastNameController = TextEditingController(text: editedUser['lastName']);
    emailController = TextEditingController(text: editedUser['email']);
    dob = editedUser['dob'] != null
        ? DateFormat('dd/MM/yyyy').parse(editedUser['dob'])
        : null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Date of Birth: '),
                TextButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: dob ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        dob = selectedDate;
                      });
                    }
                  },
                  child: Text(
                    dob != null
                        ? DateFormat('dd/MM/yyyy').format(dob!)
                        : 'Select Date',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Update editedUser with the latest information
                editedUser['firstName'] = firstNameController.text;
                editedUser['lastName'] = lastNameController.text;
                editedUser['email'] = emailController.text;
                editedUser['dob'] =
                    dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : null;

                print('Latest User details: $editedUser');

                // Load existing data from the JSON file
                String data =
                    await rootBundle.loadString('assets/contact.json');
                List<dynamic> jsonData = json.decode(data);

                // Find the index of the entry with the specified id
                int indexToUpdate = -1;
                for (int i = 0; i < jsonData.length; i++) {
                  if (jsonData[i]['id'] == editedUser['id']) {
                    indexToUpdate = i;
                    break;
                  }
                }

                // Update the entry if found
                if (indexToUpdate != -1) {
                  // Create a new JSON object with the updated information
                  Map<String, dynamic> updatedEntry = {
                    'id': editedUser['id'],
                    'firstName': editedUser['firstName'],
                    'lastName': editedUser['lastName'],
                    'email': editedUser['email'],
                    'dob': editedUser['dob'],
                  };

                  // Replace the existing entry with the updated one
                  jsonData[indexToUpdate] = updatedEntry;

                  // Print the updated data
                  print('Updated Data: $jsonData');

                  // Write the updated data back to the file
                  String updatedData = json.encode(jsonData);
                  await writeToFile(updatedData);
                } else {
                  print('Entry with id ${editedUser['id']} not found.');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> writeToFile(String data) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = '${appDocumentsDirectory.path}/contact.json';
  File file = File(filePath);
  await file.writeAsString(data);
  print('contact.json updated and replaced.');
}
