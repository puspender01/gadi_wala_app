import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_vehicle_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final data = await DatabaseHelper.instance.getVehicles();
    setState(() {
      vehicles = data;
    });
  }

  Future<void> _deleteVehicle(int id) async {
    await DatabaseHelper.instance.deleteVehicle(id);
    _loadVehicles(); // Refresh list after delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle List')),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vehicles[index]['name']),
            subtitle: Text('Reg No: ${vehicles[index]['registration_number']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteVehicle(vehicles[index]['id']),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVehicleScreen(vehicle: vehicles[index]),
                ),
              ).then((_) => _loadVehicles());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          ).then((_) => _loadVehicles());
        },
      ),
    );
  }
}
