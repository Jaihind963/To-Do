import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:to_do/screens/dummy.dart';
import 'package:to_do/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController addToDoController = TextEditingController();

  bool today = true, tomorrow = false, nextWeek = false;
  bool isSelected = false;
  Stream? todoStream;
  List<bool> showDeleteButtons = [];
  getontheload() async {
    todoStream = await Database().showAllToDo(today
        ? "Today"
        : tomorrow
            ? "Tomorrow"
            : "NextWeek");
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allWork() {
    return Expanded(
      child: StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // Initialize the showDeleteButtons list based on the data length
          if (showDeleteButtons.length != snapshot.data.docs.length) {
            showDeleteButtons = List.filled(snapshot.data.docs.length, false);
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return ListTile(
                leading: Checkbox(
                  value: ds["Yes"],
                  activeColor: const Color(0xFF279cfb),
                  onChanged: (value) async {
                    await Database().updateIfTicked(
                        ds["Id"],
                        today
                            ? "Today"
                            : tomorrow
                                ? "Tomorrow"
                                : "NextWeek",
                        value!);
                    setState(() {
                      showDeleteButtons[index] = value!;
                    });
                  },
                ),
                title: GestureDetector(
                    onTap: () {
                      
                      addToDoController.text = ds["Work"];
                     
                      editWorkToDo(ds["Id"]);
                      // Navigator.push(context,MaterialPageRoute(builder: (context) => Dummy(),));
                    },
                    child: Text(ds["Work"])),
                trailing: showDeleteButtons[index]
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          // await FirebaseFirestore.instance
                          //     .collection(today ? "Today" : tomorrow ? "Tomorrow" : "NextWeek")
                          //     .doc(ds["Id"])
                          //     .delete();
                          Database().deleteToDo(
                              ds["Id"],
                              today
                                  ? "Today"
                                  : tomorrow
                                      ? "Tomorrow"
                                      : "NextWeek");
                        },
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addToDoController.clear();
          openBox(context);
        },
        child: const Icon(
          Icons.add,
          size: 25,
          color: Color.fromARGB(255, 107, 179, 239),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // ignore: use_full_hex_values_for_flutter_colors
              Color(0xFF232FDA2),
              Color(0xFF13D8CA),
              Color(0xFF09adfe),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Hello\nJaihind",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Good Morning",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),
            // CheckboxListTile(value: value, onChanged: onChanged)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  today
                      ? Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 47, 243, 247),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Today",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            today = true;
                            tomorrow = false;
                            nextWeek = false;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            "Today",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                  tomorrow
                      ? Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 47, 243, 247),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Tomorrow",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            today = false;
                            tomorrow = true;
                            nextWeek = false;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            "Tomorrow",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                  nextWeek
                      ? Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 47, 243, 247),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Next-Week",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            today = false;
                            tomorrow = false;
                            nextWeek = true;
                            await getontheload();
                            setState(() {});
                          },
                          child: const Text(
                            "Next-Week",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),
            //  const SizedBox(height: 20),
            allWork(),
          ],
        ),
      ),
    );
  }

  Future openBox(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
                const Text("Add your Points"),
                const SizedBox(height: 10),
                TextField(
                  controller: addToDoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> userToDo = {
                      "Work": addToDoController.text,
                      "Id": id,
                      "Yes": false
                    };
                    today
                        ? Database().addToday(userToDo, id)
                        : tomorrow
                            ? Database().addTomorrow(userToDo, id)
                            : Database().addNextWeek(userToDo, id);
                    Navigator.pop(context);
                    addToDoController.clear();
                  },
                  child: const Center(
                    child: Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      Future editWorkToDo (String id)=> showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    "Edit ToDo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: addToDoController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Map<String, dynamic> editToDO = {
                                        "Work": addToDoController.text,
                                        "Id": id
                                      };
                                      await Database().updateToDo(
                                          id,
                                          today
                                              ? "Today"
                                              : tomorrow
                                                  ? "Tomorrow"
                                                  : "NextWeek",
                                          editToDO).then((value) => Navigator.pop(context));
                                    },
                                    child: Center(
                                      child: Text("Update"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
}
