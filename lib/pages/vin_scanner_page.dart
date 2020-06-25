import 'package:flutter/material.dart';
import 'package:vin_decoder/vin_decoder.dart';

class VINScannerPage extends StatefulWidget {
  @override
  _VINScannerPageState createState() => _VINScannerPageState();
}

class _VINScannerPageState extends State<VINScannerPage> {
  //Global Key
  final _form = GlobalKey<FormState>();

  //for the switch.
  bool switchControl = false;
  var textHolder = 'Switch is OFF';

  //initial values for make,.
  var _initValues = {
    'make': '',
    'model': '',
    'type': '',
  };

  //initiate on form submission.
  Future<void> _saveForm() async {
    _form.currentState.save();
  }

  //switch logic.
  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add VIN'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'My vehicle model year is 1981 or later.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: switchControl,
                      activeColor: Colors.orange,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
                ],
              ),
              //Title TextInput
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'VIN number',
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  //FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'VIN number can\'t be Empty';
                  }
                  return null;
                },
                onSaved: (value) async {
                  //WP0ZZZ99ZTS392124
                  var vin = VIN(number: '$value', extended: true);
                  
                  print('WMI: ${vin.wmi}');
                  print('VDS: ${vin.vds}');
                  print('VIS: ${vin.vis}');

                  print("Model year is " + vin.modelYear());
                  print("Serial number is " + vin.serialNumber());
                  print("Assembly plant is " + vin.assemblyPlant());
                  print("Manufacturer is " + vin.getManufacturer());
                  print("Year is " + vin.getYear().toString());
                  print("Region is " + vin.getRegion());
                  print("VIN string is " + vin.toString());

                  // The following calls are to the NHTSA DB, and are carried out asynchronously
                  var make = await vin.getMakeAsync();
                  print("Make is : $make");

                  var model = await vin.getModelAsync();
                  print("Model is : $model");

                  var type = await vin.getVehicleTypeAsync();
                  print("Type is : $type");
                },
              ),
              SizedBox(
                height: 10,
              ),
              //File Picker
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onPressed: () async {
                            _saveForm();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
