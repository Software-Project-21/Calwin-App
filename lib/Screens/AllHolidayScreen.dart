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
                SizedBox(
                  width: 40,
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
    return Container(
      height: 700,
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.transparent,
              Colors.transparent,
              Colors.purple
            ],
            stops: [
              0.0,
              0.02,
              0.98,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
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
                width: 315,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text(event['name'],
                          style: Theme.of(context).primaryTextTheme.headline2),
                    ),
                    Text(
                      getDate(event['dt']),
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                width: 300.0,
                child: Text(event['desc'],
                    style: Theme.of(context).accentTextTheme.bodyText1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getDate(String date) {
    String newDate = date.substring(0, 10);
    return newDate;
  }
}
