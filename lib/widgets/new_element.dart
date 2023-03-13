// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:lab4/views/list_item.dart';
import 'package:nanoid/nanoid.dart';
import 'package:date_field/date_field.dart';

class NovElement extends StatefulWidget {

  final Function addItem;

  NovElement(this.addItem);

  @override
  State<NovElement> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {

  final _naslovController = TextEditingController();
  final _datumController = TextEditingController();

  late String naslov;
  late String datum;
  late DateTime? selectedDate = DateTime.now();

  void _submitData() {
    if(_naslovController.text.isEmpty) {
      return;
    }
    
    final vnesenNaslov = _naslovController.text;
    final vnesenDatum = _datumController.text;
    
    final newItem = ListItem(nanoid(5) , vnesenNaslov, selectedDate);
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        TextField(
          controller: _naslovController,
          decoration: const InputDecoration(labelText: "Subject"),
          onSubmitted: (_) => _submitData(),
        ),


        // TextField(
        //   controller: _datumController,
        //   decoration: const InputDecoration(
        //     icon: Icon(Icons.calendar_today),
        //     labelText: "Enter Date"
        //   ),
        //   readOnly: true,
        //   onTap: () async {
        //     DateTime? pickedDate = await showDatePicker(
        //       context: context, 
        //       initialDate: DateTime.now(), 
        //       firstDate: DateTime(1950), 
        //       lastDate: DateTime(2100));

        //       //String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);

        //       setState(() {
        //         _datumController.text = pickedDate as String;
        //       });
        //   },
        // ),


        DateTimeField(
          decoration: const InputDecoration(
            hintText: 'Please select'
          ),
          selectedDate: selectedDate,
          onDateSelected: (DateTime value) => {
            setState(() {
              selectedDate = value;
            })
        }), 
      

        TextButton(onPressed: _submitData, child: const Text('Add'))
      ]),
    );
  }
}