import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:calwin/Model/Database.dart';
import 'package:uuid/uuid.dart';

List<String> emails = [];
List<String> realEmails = [];

class eventsChooser extends StatefulWidget {
  final User user;
  //final CalwinEvent event;

  const eventsChooser({Key key, this.user}) : super(key: key);

  _eventsChooserState createState() => _eventsChooserState();
}

var uuid = Uuid();

class _eventsChooserState extends State<eventsChooser> {
  List<String> _emails;
  final _formKey = GlobalKey<FormBuilderState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _startDateTime, _finishDateTime;
  @override
  void initState() {
    // TODO: implement initState
    emails.clear();
    realEmails.clear();
    super.initState();
  }

  Future<void> getActualEmails() async {
    if (emails == null) return;
    for (int i = 0; i < emails.length; i++) {
      String mail = await CalwinDatabase.checkEmail(emails[i]);
      print(mail + "   " + emails[i]);
      if (mail == emails[i]) {
        realEmails.add(emails[i]);
        print("gud");
        print(emails[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.redAccent[400],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _formKey.currentState.save();
                final data =
                    Map<String, dynamic>.from(_formKey.currentState.value);
                data["date"] = _selectedDate;

                getActualEmails();
                print("fuck");
                print(realEmails);
                var curevent = <String, dynamic>{
                  'id': uuid.v4(),
                  'title': data['title'],
                  'description': data['description'],
                  'startTime': _startDateTime,
                  'endTime': _finishDateTime,
                  'attendeeEmail': realEmails
                };
                CalwinDatabase.addEvents(curevent, widget.user.uid);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          //add event form
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  // initialValue: widget.event?.title,
                  decoration: InputDecoration(
                      hintText: "Add Title",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 48.0)),
                ),
                Divider(),
                FormBuilderTextField(
                  name: "description",
                  // initialValue: widget.event?.description,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Add Details",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                ),
                Divider(),
                GestureDetector(
                  onTap: () => _selectDate(0),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _textEditingController1,
                      decoration: InputDecoration(
                          hintText: 'Event Start Date & Time',
                          prefixIcon: Icon(CupertinoIcons.calendar_badge_plus)),
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () => _selectDate(1),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _textEditingController2,
                      decoration: InputDecoration(
                          hintText: 'Event Finish Date & Time',
                          prefixIcon: Icon(CupertinoIcons.calendar_badge_plus)),
                    ),
                  ),
                ),
                Divider(),
                EmailInput(hint: 'Add People', parentEmails: _emails),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(int a) async {
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
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
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
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
          _startDateTime = pickedDate;
          _textEditingController1.text = pickedDate.toString();
        } else {
          _finishDateTime = pickedDate;
          _textEditingController2.text = pickedDate.toString();
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
                          backgroundColor: Colors.black,
                          child: Text(
                            email.substring(0, 1),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        labelPadding: EdgeInsets.all(1),
                        backgroundColor: Colors.grey,
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
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: Icon(CupertinoIcons.person_3_fill)),
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
