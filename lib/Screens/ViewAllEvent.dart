import 'package:calwin/Model/Database.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ViewAllEvents extends StatefulWidget {
  final User user;
  const ViewAllEvents({Key key, this.user}) : super(key: key);
  @override
  _ViewAllEventsState createState() => _ViewAllEventsState();
}

class _ViewAllEventsState extends State<ViewAllEvents> {

  Widget eventList;
  List<dynamic> _events = [];
  @override
  void initState() {
    _events = CalwinDatabase.getListEvents(widget.user.uid);
    super.initState();
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
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => IconButton(
                      icon: notifier.isDarkTheme
                          ? Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      )
                          : Icon(Icons.arrow_back_ios),
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("All Events",
                      style: Theme.of(context).primaryTextTheme.headline1),
                ),
                Row(
                  children: [
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
                                _events = CalwinDatabase.getListEvents(widget.user.uid);
                                // _buildEventList();
                              });
                            })),
                  ],
                ),
              ],
            ),
          ),
          // calendar(),
          SizedBox(height: 10),
          Container(
            child: (_events == null) ? Container() : _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // print(_events);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400, minHeight: 56.0),
      child: ListView(
        children: _events
            .map((event) => Container(
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
        ))
            .toList(),
      ),
    );
  }

  Widget singleTile(Map<String, dynamic> event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          child: Column(
            children: [
              Text(event['title']==null?"":event['title'],
                  style: Theme.of(context).primaryTextTheme.bodyText2),
              Text(event['description']==null?"":event['description'],
                  style: Theme.of(context).primaryTextTheme.bodyText2),
            ],
          ),
        ),
        Row(children: [
          IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              onPressed: () {
                // TODO:
              }),
          IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: () async {
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

                CalwinDatabase.deleteEvent(event['id'], widget.user.uid);
                setState(() {
                  _events =CalwinDatabase.getListEvents(widget.user.uid);
                });
              }),
        ]),
      ],
    );
  }
}
