import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/available_screen.dart';
import 'package:flutter_app/model/item_tile.dart';
import 'package:flutter_app/model/schedule_item.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*var date = DateTime.now();
  print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
  print(DateFormat('EEEE').format(date)); // prints Tuesday*/

  final mainScheduleDb = FirebaseDatabase.instance.reference().child("MainSchedule");
  final makeUpScheduleDb = FirebaseDatabase.instance.reference().child("MakeupSchedule");
  List<ScheduleItem> dummyData = [];

  @override
  void initState() {
    super.initState();

    DateTime date = DateTime.now();
    var today = DateFormat('EEEE').format(date);

    mainScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      // var data = snapshot.value;
      var values = snapshot.value;
      // var keys = snapshot.value.keys;
      dummyData.clear();
      print("VALUES...... = .....$values");
      print("value.length = ${values.length}");
      print("value type = ${values.runtimeType}");
      /*print("KEYS...... = .....$keys");
      print("VALUES...... = .....$values");*/

      for(var value in values){
        print("value = $value");
        print("value[courseId] = ${value["courseId"]}");
        print("value type = ${value.runtimeType}");
        print("value[courseId] type = ${value["courseId"].runtimeType}");
        // print("value = ${value.courseId}");

        // Map itemMap = jsonDecode(value);
        // print("itemMap = $itemMap");
        // var item = ScheduleItem.fromJson(itemMap);
        // var item = ScheduleItem.fromJson(value);
        // print("ITEM BEFORE = $item");


        var item = ScheduleItem();
        item.courseId = value["courseId"] == null ? "" : value["courseId"];
        item.endTime = value["endTime"] == null ? "" : value["endTime"];
        item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
        item.startTime = value["startTime"] == null ? "" : value["startTime"];
        item.status = value["status"] == null ? "" : value["status"];



        /*item.courseId = value.courseId == null ? "" : value.courseId;
        item.endTime = value.endTime == null ? "" : value.endTime;
        item.roomNo = value.roomNo == null ? "" : value.roomNo;
        item.startTime = value.startTime == null ? "" : value.startTime;
        item.status = value.status == null ? "" : value.status;
        print("ITEM = $item");*/
        dummyData.add(item);
      }
      print(".............................FINISHED LOOOP!!!");
      /*try{
      data.forEach((key, value){
        // if(value != null && key != null){

        print("ss5...............................................");
        print("ss5...............................................");
        ScheduleItem item = ScheduleItem(
          courseId: value['courseId'],
          startTime: value['startTime'],
          endTime: value['endTime'],
          status: value['status'],
          roomNo: value['roomNo'],
        );

        dummyData.add(item);
        }
      // }
      );
      }
      catch(e){
        print("EXCEPTION ===  $e");
      }*/
      setState(() {
      });
    });

    today = "${date.day}-${date.month}-${date.year}";
    print("TODAY: $today");
    makeUpScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      print("VALUES = $values");

      for(var value in values){
        var item = ScheduleItem();
        item.courseId = value["courseId"] == null ? "" : value["courseId"];
        item.endTime = value["endTime"] == null ? "" : value["endTime"];
        item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
        item.startTime = value["startTime"] == null ? "" : value["startTime"];
        item.status = value["status"] == null ? "" : value["status"];

        dummyData.add(item);
      }
      print(".............................FINISHED LOOOP!!!");
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: _height,
          decoration: BoxDecoration(color: Color(0xFFE4ECF1)),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
                child: Container(
                  child: Text("Important Notifications"),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Today's", style: TextStyle(fontSize: 26)),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AvailableScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              Expanded(
                //height: 500,
                child: dummyData.length ==0 ? Text("NO ITEM") : ListView.builder(
                  itemCount: dummyData.length,
                  itemBuilder: (context, i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ItemTile(dummyData[i]),
                  ),
                ),
              ),
            ],
          ),
    ));
  }
}
