import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('todos');
  final TextEditingController _todoController = TextEditingController();

  List<Map<dynamic, dynamic>> _todoList = [];
  String? _updateKey;  // To hold the key of the item being updated

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  // Fetch todo list from Firebase
  void _getTodos() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final mapData = Map<dynamic, dynamic>.from(data as Map);
        setState(() {
          _todoList = mapData.entries.map((entry) {
            return Map<dynamic, dynamic>.from(entry.value)..['key'] = entry.key;
          }).toList();
        });
      }
    });
  }

  // Add new todo item to Firebase
  void _addOrUpdateTodo() {
    if (_todoController.text.isNotEmpty) {
      if (_updateKey == null) {
        // Add new task
        _database.push().set({
          'task': _todoController.text,
          'completed': false,
        }).then((_) {
          _todoController.clear();
        }).catchError((error) {
          print('Failed to add todo: $error');
        });
      } else {
        // Update existing task
        _database.child(_updateKey!).update({
          'task': _todoController.text,
        }).then((_) {
          _todoController.clear();
          setState(() {
            _updateKey = null;  // Reset the key after update
          });
        }).catchError((error) {
          print('Failed to update todo: $error');
        });
      }
    }
  }

  // Populate text field for editing
  void _editTodoItem(String key, String task) {
    setState(() {
      _todoController.text = task;
      _updateKey = key;  // Store the key of the item to update
    });
  }

  // Update todo item (toggle completion)
  void _toggleTodoComplete(String key, bool completed) {
    _database.child(key).update({
      'completed': !completed,
    });
  }

  // Delete todo item from Firebase
  void _deleteTodo(String key) {
    _database.child(key).remove().catchError((error) {
      print('Failed to delete todo: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase To-Do App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Enter new task or edit existing',
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.black54,
                  icon: Icon(_updateKey == null ? Icons.add : Icons.save),  // Change icon based on add/update
                  onPressed: _addOrUpdateTodo,  // Add or update todo
                ),
              ],
            ),
          ),
          Expanded(
            child: _todoList.isEmpty
                ? Center(child: Text('No tasks available'))
                : ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                final todo = _todoList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        todo['task'],
                        style: TextStyle(
                          decoration: todo['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,color: Colors.green,),
                            onPressed: () => _editTodoItem(todo['key'], todo['task']),  // Edit item
                          ),
                          IconButton(
                            icon: Icon(
                                color: Colors.indigo,
                                todo['completed']
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank
                            ),
                            onPressed: () => _toggleTodoComplete(todo['key'], todo['completed']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever_outlined,color: Colors.red,),
                            onPressed: () => _deleteTodo(todo['key']),
                          ),
                        ],
                      ),
                    ),
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
