import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddVehicleScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicle;

  AddVehicleScreen({this.vehicle});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController insuranceDetailsController = TextEditingController();
  final TextEditingController insuranceExpiryController = TextEditingController();
  final TextEditingController puccExpiryController = TextEditingController();
  final TextEditingController registrationDateController = TextEditingController();
  final TextEditingController serviceDateController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      nameController.text = widget.vehicle!['name'];
      regNumberController.text = widget.vehicle!['registration_number'];
      insuranceDetailsController.text = widget.vehicle!['insurance_details'];
      insuranceExpiryController.text = widget.vehicle!['insurance_expiry'];
      puccExpiryController.text = widget.vehicle!['pucc_expiry'];
      registrationDateController.text = widget.vehicle!['registration_date'];
      serviceDateController.text = widget.vehicle!['service_date'];
      if (widget.vehicle!['photo_path'] != null) {
        _image = File(widget.vehicle!['photo_path']);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveVehicle() async {
    if (nameController.text.isEmpty || regNumberController.text.isEmpty) return;

    final vehicleData = {
      'name': nameController.text,
      'registration_number': regNumberController.text,
      'insurance_details': insuranceDetailsController.text,
      'insurance_expiry': insuranceExpiryController.text,
      'pucc_expiry': puccExpiryController.text,
      'registration_date': registrationDateController.text,
      'service_date': serviceDateController.text,
      'photo_path': _image?.path ?? '',
    };

    if (widget.vehicle == null) {
      await DatabaseHelper.instance.addVehicle(vehicleData);
    } else {
      await DatabaseHelper.instance.updateVehicle(widget.vehicle!['id'], vehicleData);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Vehicle Name')),
              TextField(controller: regNumberController, decoration: InputDecoration(labelText: 'Registration Number')),
              TextField(
                controller: insuranceExpiryController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Insurance Expiry Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), // Only allow future dates
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      insuranceExpiryController.text = pickedDate.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
              TextField(
                controller: puccExpiryController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'PUCC Expiry Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), // Only allow future dates
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      puccExpiryController.text = pickedDate.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
              TextField(
                controller: registrationDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Registration Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Allow past dates
                    lastDate: DateTime.now(), // Up to today
                  );
                  if (pickedDate != null) {
                    setState(() {
                      registrationDateController.text = pickedDate.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
              TextField(
                controller: serviceDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Service Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Allow past dates
                    lastDate: DateTime.now(), // Up to today
                  );
                  if (pickedDate != null) {
                    setState(() {
                      serviceDateController.text = pickedDate.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              _image != null ? Image.file(_image!, height: 100) : Container(),
              ElevatedButton(onPressed: _pickImage, child: Text('Upload Photo')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveVehicle, child: Text('Save Vehicle')),
            ],
          ),
        ),
      ),
    );
  }
}
