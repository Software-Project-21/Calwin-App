import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  CalendarController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calwin: The Smart Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Row(
                children:[
                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15,top: 15),
                      child: Text(
                      'Welcome to your team Calendar\n'+widget.user.displayName,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20.0,
                          fontFamily: 'Pacifico',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width*0.1,
                    backgroundImage: NetworkImage(widget.user.photoURL==null?"https://www.ucsfdentalcenter.org/sites/default/files/styles/dent_profile_teaser_526w/public/default_profile_2x_1024.png?itok=S6PqnjvS&timestamp=1503035595":widget.user.photoURL),
                  ),

                ],
              ),
            ),
            SizedBox(height: 40.0),
            TableCalendar(
              calendarController: _controller,
              calendarStyle: CalendarStyle(
                  selectedColor: Theme.of(context).primaryColor,
                  weekdayStyle: TextStyle(fontSize: 16.0),
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF5252),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
