
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final FlutterContactPicker _contactPicker =  FlutterContactPicker();

  Contact? _contact;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
        appBar:  AppBar(
          title:  Text('Contact Picker Example App'),
        ),
        body:  Center(
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_contact.toString()),
               MaterialButton(
                color: Colors.blue,
                child: const Text("CLICK ME"),
                onPressed: () async {
                  Contact contact = (await _contactPicker.selectContact()) as Contact;
                  setState(() {
                    _contact = contact;
                  });
                },
              ),
               Text(
                _contact == null ? 'No contact selected.' : _contact.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}