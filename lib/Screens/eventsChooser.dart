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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
