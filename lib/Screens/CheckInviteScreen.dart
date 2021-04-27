import 'package:calwin/Model/Database.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckInviteScreen extends StatefulWidget {
  final User user;
  const CheckInviteScreen({Key key, this.user}) : super(key: key);

  @override
  _CheckInviteScreenState createState() => _CheckInviteScreenState();
}

class _CheckInviteScreenState extends State<CheckInviteScreen> {
  List<dynamic> _invites = [];
  List<dynamic> invitations = [];
  static double allowed;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    allowed = availableHeight;
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
                  child: Text("Invites",
                      style: Theme.of(context).primaryTextTheme.headline1),
                ),
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
                            _invites = CalwinDatabase.getListInvites(widget.user.uid);
                            print(_invites);
                          });
                        })),
              ],
            ),
          ),
          // calendar(),
          SizedBox(height: 10),
          Container(
            child: (_invites == null) ? Container() : _buildInvitesList(),
          ),
          //Column(children: _eventWidgets),
        ],
      ),
    );
  }

  Widget _buildInvitesList() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 0.95 * allowed, minHeight: 56.0),
      child: ListView(
        children: _invites
            .map((invite) => Container(
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
                  child: singleTile(invite),
                ))
            .toList(),
      ),
    );
  }

  Widget singleTile(Map<String, dynamic> invite) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          child: Column(
            children: [
              Text(invite['title'],
                  style: Theme.of(context).primaryTextTheme.bodyText1),
              Text(invite['description'],
                  style: Theme.of(context).primaryTextTheme.bodyText1),
            ],
          ),
        ),
        Row(children: [
          IconButton(
              icon: Icon(CupertinoIcons.check_mark),
              onPressed: () {
                CalwinDatabase.acceptInvite(invite, widget.user.uid);
                CalwinDatabase.deleteInvite(widget.user.uid, invite['id']);
                setState(() {
                  _invites = CalwinDatabase.getListInvites(widget.user.uid);
                });
              }),
          IconButton(
              icon: Icon(CupertinoIcons.clear),
              onPressed: () {
                CalwinDatabase.deleteInvite(widget.user.uid, invite['id']);
                setState(() {
                  _invites = CalwinDatabase.getListInvites(widget.user.uid);
                });
              }),
        ]),
      ],
    );
  }
}
