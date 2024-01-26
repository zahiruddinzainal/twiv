import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twiv/contact/contact_add.dart';
import 'package:twiv/contact/contact_details.dart';

List<Map<String, dynamic>> userData = [];

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: const Text('Contact'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ContactAdd()),
                );
              },
            ),
          ],
        ),
        body: UserList(),
      );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
    filteredUsers = userData;
  }

  Future<void> loadUserData() async {
    userData = [];

    String data = await rootBundle.loadString('assets/contact.json');
    List<dynamic> jsonData = json.decode(data);

    setState(() {
      userData = jsonData.cast<Map<String, dynamic>>();
      filteredUsers = userData;
    });
  }

  Future<void> _refresh() async {
    await loadUserData();
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = userData
          .where((user) =>
              user["firstName"].toLowerCase().contains(query.toLowerCase()) ||
              user["lastName"].toLowerCase().contains(query.toLowerCase()) ||
              (user["email"] != null &&
                  user["email"].toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterUsers,
              style: TextStyle(color: Colors.white), 
              decoration: InputDecoration(
                hintText: 'Enter a name or email',
                prefixIcon:
                    Icon(Icons.search, color: Colors.white), 
                filled: true,
                fillColor: const Color.fromARGB(
                    255, 230, 230, 230), 
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${user["firstName"]} ${user["lastName"]}'),
                    subtitle: Text('Email: ${user["email"]}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetails(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
