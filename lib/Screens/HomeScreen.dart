import 'package:calwin/Screens/sign_in.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calwin/Model/User.dart';
import 'holidays.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String dateDes;
  CalendarController _controller;
  User _user;
  @override
  void initState() {
    super.initState();
    _user = widget._user;
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Calwin: The Smart Calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_rounded),
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(_routeToSignInScreen());
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://image.freepik.com/free-vector/colorful-abstract-wallpaper-design_23-2148467625.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.dstATop),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          'Welcome to your team Calendar\n' +
                              widget._user.displayName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Pacifico',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.1,
                      backgroundImage: NetworkImage(_user.photoURL),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.0),
            TableCalendar(
              calendarController: _controller,
              holidays: holidays_list,
              calendarStyle: CalendarStyle(
                holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
                selectedColor: Colors.deepOrange[400],
                todayColor: Colors.deepOrange[200],
                markersColor: Colors.brown[700],
                weekdayStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white),
              ),
              headerStyle: HeaderStyle(
                leftChevronIcon:
                    Icon(Icons.keyboard_arrow_left_rounded, color: Colors.red),
                rightChevronIcon:
                    Icon(Icons.keyboard_arrow_right_rounded, color: Colors.red),
                centerHeaderTitle: true,
                titleTextStyle:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                formatButtonTextStyle:
                    TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) {
                  // if (holidays_list.containsKey(
                  //     new DateTime(date.year, date.month, date.day))) {
                  //   if (holidays_list[new DateTime(date.year, date.month, date.day)] != null)
                  //     getHoliday(date);
                  //
                  // }
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[200],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
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
                markersBuilder: (context, date, events, holidays) {
                  final children = <Widget>[];
                  if (holidays.isNotEmpty) {
                    print(1);
                    children.add(
                      Positioned(
                        right: -2,
                        top: -2,
                        child: _buildHolidaysMarker(date),
                      ),
                    );
                  }
                  return children;
                },
              ),
              onDaySelected: (date, events, holidays) {
                _onDaySelected(date);
              },
            ),
            SizedBox(height: 30.0),
            Center(
              child: Container(
                child: Text(
                  dateDes == null ? "" : dateDes,
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getHoliday(DateTime curDate) {
    print(holidays_list[new DateTime(curDate.year, curDate.month, curDate.day)]
        .single);
    return holidays_list[new DateTime(curDate.year, curDate.month, curDate.day)]
        .single;
  }

  Widget _buildHolidaysMarker(DateTime curDate) {
    return Icon(
      Icons.icecream,
      color: Colors.redAccent,
    );
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      if (holidays_list
          .containsKey(new DateTime(date.year, date.month, date.day)))
        dateDes = getHoliday(date);
      else
        dateDes = "";
    });
  }
}
