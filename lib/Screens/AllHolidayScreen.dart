import 'package:calwin/Model/HolidayModel.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'holidays.dart';

class AllHolidayScreen extends StatefulWidget {
  @override
  _AllHolidayScreenState createState() => _AllHolidayScreenState();
}

class _AllHolidayScreenState extends State<AllHolidayScreen> {
  @override
  void initState() {
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
                  child: Text("Holidays",
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
            child: (allHolidays == null) ? Container() : _buildHolidayList(),
          ),
          //Column(children: _eventWidgets),
        ],
      ),
    );
  }

  Widget _buildHolidayList() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 700, minHeight: 56.0),
      child: ListView(
        children: allHolidays
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
              Container(
                width: 300.0,
                height: 40.0,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(event['name'],
                      style: Theme.of(context).primaryTextTheme.bodyText1),
                ),
              ),
              Container(
                width: 300.0,
                height: 40.0,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(event['desc'],
                        style: Theme.of(context).primaryTextTheme.bodyText1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
