import 'dart:core';
import 'package:calwin/Screens/sign_in.dart';
import 'package:calwin/Screens/eventsChooser.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:calwin/Model/calender_model.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'holidays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/HolidayModel.dart';
import 'package:http/http.dart' as http;

// class Htt extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  User _user;
  bool _isSigningOut = false;
  Future<HolidayModel> futureHoliday;
  DateTime _selectedDay = DateTime.now();
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _selectedEvents = [];
  List<dynamic> _holidays = [];
  //List<Widget> get _eventWidgets =>
  //  _selectedEvents.map((e) => events(e)).toList();
  String dateDes;

  void initState() {
    super.initState();
    futureHoliday = getHolidayDetails();
    _user = widget._user;
    // DB.init().then((value) => _fetchEvents());
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Calendar",
                    style: Theme.of(context).primaryTextTheme.headline1),
                Row(children: [
                  Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => IconButton(
                          icon: notifier.isDarkTheme
                              ? FaIcon(
                                  FontAwesomeIcons.moon,
                                  size: 20,
                                  color: Colors.white,
                                )
                              : Icon(Icons.wb_sunny),
                          onPressed: () => {notifier.toggleTheme()})),
                  Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => IconButton(
                          icon: notifier.isDarkTheme
                              ? Icon(
                                  Icons.exit_to_app_rounded,
                                  size: 20,
                                  color: Colors.white,
                                )
                              : Icon(Icons.exit_to_app_rounded),
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context)
                                .pushReplacement(_routeToSignInScreen());
                          })),
                ]),
              ],
            ),
          ),
          calendar(),
          eventTitle(),
          Center(
            child: Container(
              child: Text(
                dateDes == null ? "" : dateDes,
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          ),
          //Column(children: _eventWidgets),
          SizedBox(height: 60)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => eventsChooser(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  /*Widget events(var d) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(d, style: Theme.of(context).primaryTextTheme.bodyText1),
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.redAccent,
                  size: 15,
                ),
                onPressed: () => _deleteEvent(d))
          ])),
    );
  }*/

  void _onDaySelected(BuildContext context, DateTime date) {
    setState(() {
      if (holidays_list
          .containsKey(new DateTime(date.year, date.month, date.day)))
        dateDes = getHoliday(date);
      else
        dateDes = "";
    });
  }

  // void _create(BuildContext context) {
  //   String _name = "";
  //   var content = TextField(
  //     style: GoogleFonts.montserrat(
  //         color: Color.fromRGBO(105, 105, 108, 1), fontSize: 16),
  //     autofocus: true,
  //     decoration: InputDecoration(
  //       labelStyle: GoogleFonts.montserrat(
  //           color: Color.fromRGBO(59, 57, 60, 1),
  //           fontSize: 18,
  //           fontWeight: FontWeight.normal),
  //       labelText: 'Workout Name',
  //     ),
  //     onChanged: (value) {
  //       _name = value;
  //     },
  //   );
  //   var btn = FlatButton(
  //     child: Text('Save',
  //         style: GoogleFonts.montserrat(
  //             color: Color.fromRGBO(59, 57, 60, 1),
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold)),
  //     onPressed: () => _addEvent(_name),
  //   );
  //   var cancelButton = FlatButton(
  //       child: Text('Cancel',
  //           style: GoogleFonts.montserrat(
  //               color: Color.fromRGBO(59, 57, 60, 1),
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold)),
  //       onPressed: () => Navigator.of(context).pop(false));
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       elevation: 0.0,
  //       backgroundColor: Colors.transparent,
  //       child: Stack(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.all(6),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               shape: BoxShape.rectangle,
  //               borderRadius: BorderRadius.circular(6),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black26,
  //                   blurRadius: 10.0,
  //                   offset: const Offset(0.0, 10.0),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min, // To make the card compact
  //               children: <Widget>[
  //                 SizedBox(height: 16.0),
  //                 Text("Add Event",
  //                     style: GoogleFonts.montserrat(
  //                         color: Color.fromRGBO(59, 57, 60, 1),
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold)),
  //                 Container(padding: EdgeInsets.all(20), child: content),
  //                 Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: <Widget>[btn, cancelButton]),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /* void _fetchEvents() async {
    _events = {};
    List<Map<String, dynamic>> _results = await DB.query(CalendarItem.table);
    _data = _results.map((item) => CalendarItem.fromMap(item)).toList();
    _data.forEach((element) {
      DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(element.date.toString())));
      if (_events.containsKey(formattedDate)) {
        _events[formattedDate].add(element.name.toString());
      } else {
        _events[formattedDate] = [element.name.toString()];
      }
    });
    setState(() {});
  }

  void _addEvent(String event) async {
    CalendarItem item =
        CalendarItem(date: _selectedDay.toString(), name: event);
    await DB.insert(CalendarItem.table, item);
    _selectedEvents.add(event);
    _fetchEvents();

    Navigator.pop(context);
  }*/

  String getHoliday(DateTime curDate) {
    return holidays_list[new DateTime(curDate.year, curDate.month, curDate.day)]
        [0];
  }

  Widget _buildHolidaysMarker(BuildContext context, DateTime curDate) {
    return Icon(
      Icons.circle,
      size: 10,
      color: Colors.red[900],
    );
  }

  /*// Delete doesnt refresh yet, thats it, then done!
  void _deleteEvent(String s) {
    List<CalendarItem> d = _data.where((element) => element.name == s).toList();
    if (d.length == 1) {
      DB.delete(CalendarItem.table, d[0]);
      _selectedEvents.removeWhere((e) => e == s);
      _fetchEvents();
    }
  }
*/
  Widget calendar() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            gradient:
                LinearGradient(colors: [Colors.red[600], Colors.red[400]]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: new Offset(0.0, 5))
            ]),
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            // canEventMarkersOverflow: true,
            markersColor: Colors.white,
            weekdayStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            holidayStyle: TextStyle()
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            todayColor: Colors.white54,
            todayStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold),
            outsideWeekendStyle: TextStyle(color: Colors.white60),
            outsideStyle: TextStyle(color: Colors.white60),
            weekendStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            renderDaysOfWeek: false,
          ),
          holidays: holidays_list,
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, events) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              );
            },
            todayDayBuilder: (context, date, events) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white),
                )),
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                    bottom: 0,
                    child: _buildHolidaysMarker(context, date),
                  ),
                );
              }
              return children;
            },
          ),
          onDaySelected: (date, events, holidays) {
            _onDaySelected(context, date);
          },
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.monday,
          events: _events,
          headerStyle: HeaderStyle(
            leftChevronIcon:
                Icon(Icons.arrow_back_ios, size: 15, color: Colors.white),
            rightChevronIcon:
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white),
            titleTextStyle:
                GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
            formatButtonDecoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: GoogleFonts.montserrat(
                color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget eventTitle() {
    if (_selectedEvents.length == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Text("No events",
            style: Theme.of(context).primaryTextTheme.headline1),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      child:
          Text("Events", style: Theme.of(context).primaryTextTheme.headline1),
    );
  }
}
