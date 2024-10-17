import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../modal/user_modal.dart';


class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: StreamBuilder(
        stream: _userRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check if users exist
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("No users found"));
          }

          // Get the users map
          Map<dynamic, dynamic> usersMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          // Convert map values to a list of UserModel
          List<UserModel> usersList = usersMap.values.map((user) => UserModel.fromJson(user)).toList();

          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              UserModel user = usersList[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.status),
                onTap: () {
                  // You can navigate to chat with the selected user if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
