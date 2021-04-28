import 'dart:math';

import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:calwin/Model/Database.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

List<String> emails = [];

class ModifyEventScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic> event;

  const ModifyEventScreen({Key key, this.user, this.event}) : super(key: key);

  _ModifyEventScreenState createState() => _ModifyEventScreenState();
}


class _ModifyEventScreenState extends State<ModifyEventScreen> {
  List<String> _emails;
  final _formKey = GlobalKey<FormBuilderState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _startDateTime, _finishDateTime;
  int len;
  @override
  void initState() {
    emails.clear();
    // emails = widget.event['attendeeEmail'];
    _textEditingController1.text = widget.event['startTime'].toDate().toString().substring(0,16);
    _textEditingController2.text = widget.event['endTime'].toDate().toString().substring(0,16);
    _startDateTime = widget.event['startTime'].toDate();
    _finishDateTime = widget.event['endTime'].toDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: <Widget>[
          //add event form
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
                  child: Text("Modify Event",
                      style: Theme.of(context).primaryTextTheme.headline1),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "title",
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                    initialValue: widget.event['title'],
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: Theme.of(context).accentTextTheme.bodyText1,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kRed,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.short_text,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    name: "description",
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                    initialValue: widget.event['description'],
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: Theme.of(context).primaryTextTheme.bodyText2,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kRed,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.short_text,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(0),
                    child: AbsorbPointer(
                      child: FormBuilderTextField(
                        controller: _textEditingController1,
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                        decoration: InputDecoration(
                            hintText: 'Event Start Date & Time',
                            labelStyle:
                            Theme.of(context).primaryTextTheme.bodyText2,
                            hintStyle:
                            Theme.of(context).accentTextTheme.bodyText1,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kRed,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.calendar_badge_plus,
                              color: Theme.of(context).accentColor,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(1),
                    child: AbsorbPointer(
                      child: FormBuilderTextField(
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                        controller: _textEditingController2,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                        decoration: InputDecoration(
                            hintText: 'Event Finish Date & Time',
                            hintStyle:
                            Theme.of(context).accentTextTheme.bodyText1,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kRed,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(CupertinoIcons.calendar_badge_plus,
                                color: Theme.of(context).accentColor)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  EmailInput(hint: 'Add People', parentEmails: _emails),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 130,right : 130),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith<Size>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) Size(50, 50);
                    return Size(50, 40);
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.lightBlueAccent;
                    return kRed; // Use the component's default.
                  },
                ),
              ),
              onPressed: () async {
                _formKey.currentState.save();
                final data =
                Map<String, dynamic>.from(_formKey.currentState.value);
                data["date"] = _selectedDate;
                // realEmails.clear();
                // getActualEmails();
                // List<String> res;
                // Future.delayed(Duration(seconds: 5), () {
                //   res = CalwinDatabase.fetchActualEmails();
                // });
                // print(res);
                var curevent = <String, dynamic>{
                  'id': widget.event['id'],
                  'title': data['title'],
                  'description': data['description'],
                  'startTime': _startDateTime,
                  'endTime': _finishDateTime,
                  'attendeeEmail': emails,
                };
                CalwinDatabase.addEvents(curevent, widget.user.uid);
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
    );
  }

  _selectDate(int a) async {
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = _startDateTime;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done', style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Theme.of(context).brightness,
                    ),
                    child: CupertinoDatePicker(
                      initialDateTime: a==1?_startDateTime:DateTime.now(),
                      minimumDate: a==1?_startDateTime:null,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        if (a == 0) {
          _startDateTime = DateTime(pickedDate.year,pickedDate.month,pickedDate.day,pickedDate.hour,pickedDate.minute);
          _textEditingController1.text = _startDateTime.toString().substring(0,16);
        } else {
          _finishDateTime = DateTime(pickedDate.year,pickedDate.month,pickedDate.day,pickedDate.hour,pickedDate.minute);
          _textEditingController2.text = _finishDateTime.toString().substring(0,16);
        }
        _selectedDate = pickedDate;
      });
    }
  }
}

class EmailInput extends StatefulWidget {
  final Function setList;
  final String hint;
  final List<String> parentEmails;

  const EmailInput({Key key, this.setList, this.hint, this.parentEmails})
      : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  TextEditingController _emailController;
  String lastValue = '';
  FocusNode focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    focus.addListener(() {
      if (!focus.hasFocus) {
        updateEmails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              // padding: EdgeInsets.only(left: 100),
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(
                minWidth: 0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    ...emails
                        .map(
                          (email) => Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            email.substring(0, 1),
                            style: TextStyle(color:  Theme.of(context).accentColor),
                          ),
                        ),
                        labelPadding: EdgeInsets.all(2),
                        backgroundColor: kRed,
                        label: Text(
                          email,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onDeleted: () => {
                          setState(() {
                            emails.removeWhere((element) => email == element);
                          })
                        },
                      ),
                    )
                        .toList(),
                  ],
                ),
              ),
            ),
            TextField(
              style: Theme.of(context).primaryTextTheme.bodyText2,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).accentTextTheme.bodyText1,
                hintText: widget.hint,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kRed,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.person_3_fill,
                  color: Theme.of(context).accentColor,
                ),
              ),
              controller: _emailController,
              focusNode: focus,
              onChanged: (String val) {
                setState(() {
                  if (val != lastValue) {
                    lastValue = val;
                    if (val.endsWith(' ') && validateEmail(val.trim())) {
                      if (!emails.contains(val.trim())) {
                        emails.add(val.trim());
                        widget.setList(emails);
                      }
                      _emailController.clear();
                    } else if (val.endsWith(' ') && !validateEmail(val.trim())) {
                      _emailController.clear();
                    }
                  }
                });
              },
              onEditingComplete: () {
                updateEmails();
              },
            )
          ],
        ));
  }

  updateEmails() {
    setState(() {
      if (validateEmail(_emailController.text)) {
        if (!emails.contains(_emailController.text)) {
          emails.add(_emailController.text.trim());
          widget.setList(emails);
        }
        _emailController.clear();
      } else if (!validateEmail(_emailController.text)) {
        _emailController.clear();
      }
    });
  }

  setEmails(List<String> email) {
    emails = email;
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return regex.hasMatch(value);
}
