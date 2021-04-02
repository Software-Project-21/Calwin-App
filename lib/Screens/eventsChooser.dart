// import 'package:firebasestarter/core/presentation/providers/providers.dart';
// import 'package:firebasestarter/core/presentation/res/colors.dart';
// import 'package:firebasestarter/features/events/data/models/app_event.dart';
// import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class eventsChooser extends StatefulWidget {
  //final DateTime selectedDate;
  // final AppEvent event;

  // const eventsChooser({Key key, this.selectedDate, this.event})
  //     : super(key: key);
  // @override
  _eventsChooserState createState() => _eventsChooserState();
}

class _eventsChooserState extends State<eventsChooser> {
  List<String> _emails;
  final _formKey = GlobalKey<FormBuilderState>();
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
              onPressed: () async {
                //save
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
                // FormBuilderDatePicker(
                //   name: "date",
                //   //initialValue: selectedDate ?? DateTime.now(),
                //   initialDate: DateTime.now(),
                //   fieldHintText: "Add Date",
                //   initialDatePickerMode: DatePickerMode.day,
                //   inputType: InputType.date,
                //   format: DateFormat('EEEE, dd MMMM, yyyy'),
                //   decoration: InputDecoration(
                //     border: InputBorder.none,
                //     prefixIcon: Icon(Icons.calendar_today_sharp),
                //   ),
                // ),
                Divider(),
                EmailInput(hint: 'Add People',parentEmails: _emails),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmailInput extends StatefulWidget {
  final Function setList;
  final String hint;
  final List<String> parentEmails;

  const EmailInput({Key key, this.setList, this.hint, this.parentEmails}) : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  TextEditingController _emailController;
  String lastValue = '';
  List<String> emails = [];
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
                    ).toList(),
                  ],
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration.collapsed(hintText: widget.hint),
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

  setEmails(List<String> emails) {
    this.emails = emails;
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return regex.hasMatch(value);
}


