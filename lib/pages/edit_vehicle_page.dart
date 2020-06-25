import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/premission_service.dart';
import 'dart:io';

//Providers
import '../models/vehicle.dart';
import '../providers/vehicles.dart';

//Services
import '../services/compress_image.dart';
//import '../services/compress_file.dart';

class EditVehiclePage extends StatefulWidget {
  static const routeName = '/edit-vehicle-page';
  const EditVehiclePage({Key key}) : super(key: key);
  @override
  _EditVehicleStatePage createState() => _EditVehicleStatePage();
}

class _EditVehicleStatePage extends State<EditVehiclePage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  //Global Key
  final _form = GlobalKey<FormState>();

  var _editedVehicle = Vehicle(
    vehicleId: null,
    vehicleTitle: '',
    vehicleDescription: '',
    //imageUrl: '',
    pricePerDay: 0.00,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    //'imageUrl': '',
  };

  //Image paths for upload.
  Map<String, String> _filePaths;
  File _image;

  var _isInit = true;

  var _isLoading = false;

  var _isImageUploading = false;

  @override
  void initState() {
    //_imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final vehicleId = ModalRoute.of(context).settings.arguments as String;
      if (vehicleId != null) {
        _editedVehicle = Provider.of<Vehicles>(
          context,
          listen: false,
        ).findById(vehicleId);
        _initValues = {
          'title': _editedVehicle.vehicleTitle,
          'description': _editedVehicle.vehicleDescription,
          'price': _editedVehicle.pricePerDay.toString(),
          //'imageUrl': _editedVehicle.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedVehicle.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //Initite image upload from FilePicker.
  void _onFilePathChangeOnFilePicker() async {
    PermissionsService().requestStoragePermission(
      onPermissionDenied: () {
        print('Permission has been denied');
      },
      onPermissionGranted: () async {
        _filePaths = await FilePicker.getMultiFilePath(type: FileType.image);
        print(_filePaths);
        _filePaths.forEach(
          (fileName, filePath) async {
            String convertedFilePath;
            convertedFilePath = await compressImage(filePath);
            Provider.of<Vehicles>(context, listen: false)
                .uploadImageToS3(convertedFilePath);
            //compress image and get the file
            //File file = File(filePath);
            //compressAndGetFile(file, '/storage/emulated/0/gn-now/');

            print(filePath);
            print('FILE picker path is: $fileName AND $filePath');
          },
        );
      },
    );
  }

  //Initite image upload from ImagPicker.
  void _onFilePathChangeOnImagePicker() async {
    PermissionsService().requestStoragePermission(
      onPermissionDenied: () {
        print('Permission has been denied');
      },
      onPermissionGranted: () async {
        _image = await ImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );

        print('IMAGE picker path is: ');
        print(_image.path);
        //compressImage(_image.path);
        Provider.of<Vehicles>(context, listen: false)
            .uploadImageToS3(_image.path);
      },
    );
  }

/*
  //On file picker
  void _onFilePathChange() {
    compressImage();
    if (filePaths?.isNotEmpty) {
      setState(() {
        _isImageUploading = true;
      });
      print('FILE PATH IS $filePaths');
      filePaths.forEach((fileName, filePath) {
        Provider.of<Vehicles>(context, listen: false).uploadImageToS3(filePath);
        print('$fileName AND $filePath');
      });
      print(filePaths);
    }

    setState(() {
      _isImageUploading = false;
    });
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg'))) {
        return;
      }

      //tells to rebuild the widget
      setState(() {});
    }
  }
*/

  //disposing focus nodes after using to preserve memory.
  @override
  void dispose() {
    //_imageUrlFocusNode.removeListener(_updateImageUrl);

    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _imageUrlController.dispose();
    super.dispose();
  }

  //initiate on form submission
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    //stops submission if validation is true,
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedVehicle.vehicleId != null) {
      //update existing vehicle
      await Provider.of<Vehicles>(context, listen: false)
          .updateVehicle(_editedVehicle.vehicleId, _editedVehicle);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        //add new vehicle
        await Provider.of<Vehicles>(context, listen: false)
            .addVehicle(_editedVehicle);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            //content: Text('Something went wrong ${error}'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      print('saveform');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    //Title TextInput
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                          labelText: 'Title',
                          errorStyle: TextStyle(
                            color: Colors.red,
                          )),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title can\'t be Empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedVehicle = Vehicle(
                          vehicleId: _editedVehicle.vehicleId,
                          isFavourite: _editedVehicle.isFavourite,
                          vehicleTitle: value,
                          pricePerDay: _editedVehicle.pricePerDay,
                          vehicleDescription: _editedVehicle.vehicleDescription,
                          imageUrl: _editedVehicle.imageUrl,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Price TextInput
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                          labelText: 'Price',
                          errorStyle: TextStyle(
                            color: Colors.red,
                          )),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedVehicle = Vehicle(
                          vehicleId: _editedVehicle.vehicleId,
                          isFavourite: _editedVehicle.isFavourite,
                          vehicleTitle: _editedVehicle.vehicleTitle,
                          //converts String to value
                          pricePerDay: double.parse(value),
                          vehicleDescription: _editedVehicle.vehicleDescription,
                          imageUrl: _editedVehicle.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Price can\'t be Empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                    ),
                    //Description TextInput
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (value) {
                        _editedVehicle = Vehicle(
                          vehicleId: _editedVehicle.vehicleId,
                          isFavourite: _editedVehicle.isFavourite,
                          vehicleTitle: _editedVehicle.vehicleTitle,
                          pricePerDay: _editedVehicle.pricePerDay,
                          vehicleDescription: value,
                          imageUrl: _editedVehicle.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 15) {
                          return '${15 - value.length} more characters required.';
                        }
                        return null;
                      },
                    ),
                    /*
                    Image.asset(
                        '/data/user/0/com.example.gn_v3/cache/IMG-20200220-WA0036.jpg'),

                    
                    new Image.network(
                        'https://gn-img.s3.ap-south-1.amazonaws.com/ap-south-1%3Af869e0a2-a83d-4a1d-b227-f09fad7a36a4/eye.png'),
                    */
                    //File Picker
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _isImageUploading
                              ? Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    FlatButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Text(
                                        'Take a Photo',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onPressed: () async {
                                        _onFilePathChangeOnImagePicker();

                                        print(_image);
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      child: Text('Select from storage',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal)),
                                      onPressed: () async {
                                        _onFilePathChangeOnFilePicker();
                                      },
                                    )
                                  ],
                                )
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
