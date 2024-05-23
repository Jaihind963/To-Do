import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database{
  Future addToday(Map<String, dynamic>userTodayMap,String id)async{
    return await FirebaseFirestore.instance.collection("Today").doc(id).set(userTodayMap);
  }

  Future addTomorrow(Map<String, dynamic> userTomorrowMap, String id)async{
    return await FirebaseFirestore.instance.collection("Tomorrow").doc(id).set(userTomorrowMap);
  }
  Future addNextWeek(Map<String, dynamic> userNextWeek, String id)async{
    return await FirebaseFirestore.instance.collection("NextWeek").doc(id).set(userNextWeek);
  }
  Future <Stream<QuerySnapshot>> showAllToDo (String day)async{
return FirebaseFirestore.instance.collection(day).snapshots();
  }

 Future updateIfTicked(String id, String day, bool isSelected)async{
    return await FirebaseFirestore.instance.collection(day).doc(id).update({"Yes":isSelected});
  }
  Future updateToDo(String id, String day, Map<String, dynamic>editToDO)async{
    return await FirebaseFirestore.instance.collection(day).doc(id).update(editToDO);
  }

  Future deleteToDo (String id, String day)async{
    return await FirebaseFirestore.instance.collection(day).doc(id).delete();
  }
}