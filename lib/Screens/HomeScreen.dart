import 'dart:core';
import 'package:calwin/Screens/sign_in.dart';
import 'package:calwin/Screens/eventsChooser.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'holidays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/HolidayModel.dart';
import '../Model/Database.dart';

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

  @override
  void initState() {
    super.initState();
    futureHoliday = getHolidayDetails();
    _user = widget._user;
    _events = CalwinDatabase.getAllEvents(_user.uid);
    _selectedEvents = [];
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
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
                                  Icons.refresh,
                                  size: 25,
                                  color: Colors.white,
                                )
                              : Icon(Icons.refresh, size: 25),
                          onPressed: () {
                            setState(() {
                              _events = CalwinDatabase.getAllEvents(_user.uid);
                            });
                          })),
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
          Center(
            child: Container(
              child: Text(
                dateDes == null ? "" : dateDes,
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          ),
          Text((_selectedEvents == null)? "  No Events":"  Events",style: Theme.of(context).primaryTextTheme.headline1),
          Container(
            child:  (_selectedEvents == null) ? Container():  _buildEventList(),
          ),
          //Column(children: _eventWidgets),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kRed,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => eventsChooser(user: widget._user),
            ),
          );
          setState(() {
            _events = CalwinDatabase.getAllEvents(_user.uid);
          });
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

  void _onDaySelected(BuildContext context, DateTime date) {
    setState(() {
      // print(CalwinDatabase.getAllEvents(_user.uid));
      DateTime selectedDate = DateTime(date.year, date.month, date.day);
      if (_events == null) {
        _events = CalwinDatabase.getAllEvents(_user.uid);
        _selectedEvents = _events[selectedDate];
      } else {
        _selectedEvents = _events[selectedDate];
      }

      if (holidays_list
          .containsKey(new DateTime(date.year, date.month, date.day)))
        dateDes = getHoliday(date);
      else
        dateDes = "";
    });
  }

  String getHoliday(DateTime curDate) {
    return holidays_list[new DateTime(curDate.year, curDate.month, curDate.day)]
        [0];
  }

  Widget _buildEventMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.white
            : _calendarController.isToday(date)
                ? Colors.yellow
                : Colors.orange,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: _calendarController.isSelected(date)
                ? Colors.black
                : _calendarController.isToday(date)
                    ? Colors.black
                    : Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(BuildContext context, DateTime curDate) {
    return Icon(
      Icons.circle,
      size: 10,
      color: Colors.red[900],
    );
  }

  Widget calendar() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: kRed,
            borderRadius: BorderRadius.circular(6),
            // gradient:
            //     LinearGradient(colors: [Colors.red[600], Colors.red[400]]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: new Offset(0.0, 5))
            ],
        ),
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            // canEventMarkersOverflow: true,
            // markersColor: Colors.white,
            weekdayStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            holidayStyle: TextStyle()
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            eventDayStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold), // fix.
            // todayColor: Colors.black12,
            // todayStyle: TextStyle(
            //     color: Colors.white,
            //     fontSize: 1,
            //     fontWeight: FontWeight.bold),
            outsideWeekendStyle: TextStyle(color: Colors.white60),
            outsideStyle: TextStyle(color: Colors.white60),
            weekendStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            renderDaysOfWeek: true,
            outsideDaysVisible: true,
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
                  color: Colors.red[600],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white),
                )),
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                // print(events);
                children.add(
                  Positioned(
                    top: 1,
                    right: 1,
                    child: _buildEventMarker(date, events),
                  ),
                );
              }
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

  Widget _buildEventList() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400, minHeight: 56.0),
      child: ListView(
      children: _selectedEvents
          .map((event) =>
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: kRed,
              borderRadius: BorderRadius.circular(6),
              // gradient:
              // LinearGradient(colors: [Colors.red[500],Colors.red[400],Colors.red[400],Colors.deepPurple]),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: new Offset(0.0, 5))
              ],
            ),
            child: singleTile(event),
          )
      ).toList(),
        ),
    );
  }
  
  Widget singleTile(Map<String,dynamic> event){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20,top: 15,bottom: 15),
          child: Column(
            children: [
              Text(event['title'],style: Theme.of(context).primaryTextTheme.bodyText1),
              Text(event['description'],style: Theme.of(context).primaryTextTheme.bodyText1),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
            icon: Icon(FontAwesomeIcons.edit),
            onPressed: (){
              // TODO:
            }
          ),
            IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: (){
                  // DateTime eventDate = _calendarController.selectedDay;
                  // DateTime onlyDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
                  // for (int i = 0; i < _events[onlyDate].length; i++) {
                  //   var cc = _events[onlyDate][i];
                  //   if(cc['id']== event['id']){
                  //     setState(() {
                  //       _events[onlyDate].removeAt(i);
                  //     });
                  //     break;
                  //   }
                  // }

                  CalwinDatabase.deleteEvent(event['id'], _user.uid);
                  setState(() {
                    _events = CalwinDatabase.getAllEvents(_user.uid);
                    // _calendarController.dispose()
                  });
                }
            ),
          ]
        ),
      ],
    );
  }

}
