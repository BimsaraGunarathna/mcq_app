import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import '../http/http_response_handler.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
//import 'package:simple_permissions/simple_permissions.dart';

//S3
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

//Exception
import '../exceptions/http_exception.dart';

//Models
import '../models/vehicle.dart';
import '../models/user_model.dart';
import '../models/vehicle_image_policy.dart';

//Credentials
import '../credentials//aws_user_pool_credential.dart';

//Providers
//import '../providers/auth.dart';

//mix in here is kind of like extending but more flexible.
class Vehicles with ChangeNotifier {
  //Vehicles(this.idToken, this._items);

  //CognitoCredentials _cognitoCredentials;
  List<Vehicle> _items = [];
  List<Vehicle> _hostItems = [];
  List<Vehicle> _singleItem = [];
  var _showFavouritesOnly = false;
  String userEmail;

  //Authentication Credentials
  String idToken;
  String identityId;

  //getter for list of vehicles
  List<Vehicle> get items {
    if (_showFavouritesOnly) {
      return _items.where((vehicleItem) => vehicleItem.isFavourite).toList();
    }
    //return copy of an items
    return [..._items];
  }

  List<Vehicle> get hostItems {
    return [..._hostItems];
  }

/*
  List<Vehicle> get findHostItems() {
    
    var accessKeyId = _cognitoCredentials.accessKeyId;
    _items.forEach(
        (vehicle) => {
          return vehicle.contains((vehi) => vehi.vehicleId == id);
        }
      );
    //return _items.firstWhere((vehi) => vehi.hostId == accessKeyId);

  }
  */
  Vehicle findSingleItem(String id) {
    return _items.firstWhere((vehi) => vehi.vehicleId == id);
  }

/*
  void haveCredentials(CognitoCredentials credentials) {
    _cognitoCredentials = credentials;
    print('CREDENTIALS in VEHICLE $_cognitoCredentials');
    var accessKeyId = _cognitoCredentials.accessKeyId;
    var idToken;
    
    print('Access key ID is : $accessKeyId');
  }
*/
  void haveIdToken(String idToken) {
    print('IdToken is : $idToken');
    this.idToken = idToken;
  }

  void haveIdentityId(String identityId) {
    print('identityId is : $identityId');
    this.identityId = identityId;
  }

  void haveUserAttributes(User user) {
    userEmail = user.email;
  }

  //getter for the single vehicle that matches vehicleId
  Vehicle findById(String id) {
    return _items.firstWhere((vehi) => vehi.vehicleId == id);
  }

  void showFavouriteOnly() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  }

  //uplaod an image to S3
  Future<void> uploadImageToS3(String filePath) async {
    final _userPool = CognitoUserPool(awsUserPoolId, awsClientId);

    final _cognitoUser = CognitoUser('bimsara.gunarathna@gmail.com', _userPool);
    final authDetails = AuthenticationDetails(
        username: 'bimsara.gunarathna@gmail.com', password: 'test1234');

    CognitoUserSession _session;
    try {
      _session = await _cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      print(e);
    }

    final _credentials = CognitoCredentials(identityPoolId, _userPool);
    await _credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
    //var something = await _credentials.getAwsCredentials(_session.getIdToken().getIssuedAt()).toString();

    String identityId = await CognitoIdentityId(identityPoolId, _userPool)
        .getIdentityId(_session.getIdToken().getJwtToken());

    print('Identity id is: ' + identityId);

    const _region = 'ap-south-1';
    const _s3Endpoint = 'https://gn-img.s3-ap-south-1.amazonaws.com';

    //filePath = await FilePicker.getFilePath(type: FileType.IMAGE);
    File file = File(filePath);
    print('CHOOSEN FILE NAME: $file');

    String fileName = filePath.split("/").last;
    print(fileName);

    //depricated typed is removed.
    //DelegatingStream.typed(file.openRead())
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    final policy = Policy.fromS3PresignedPost(
      '$identityId/profile-picture/$fileName',
      'gn-img',
      15,
      _credentials.accessKeyId,
      length,
      _credentials.sessionToken,
      region: _region,
    );
    final key = SigV4.calculateSigningKey(
        _credentials.secretAccessKey, policy.datetime, _region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    print('SecretAccessKey is: ');
    print(_credentials.secretAccessKey);

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;
    req.fields['x-amz-security-token'] = _credentials.sessionToken;

    try {
      final res = await req.send();
      await for (var value in res.stream.transform(utf8.decoder)) {
        print(value);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Get all the vehicle from server.
  Future<void> fetchAndSetVehicles() async {
    print('idToken @ fetchAndSetVehicles: ' + idToken);
    const url =
        'https://ao83dvqxaf.execute-api.ap-south-1.amazonaws.com/dev/vehicles/all';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$idToken'
        },
      ).timeout(Duration(seconds: 8));
      //print(response.body);
      //var responseJson = HttpResponseHandler(response);
      final responseJson = HttpResponseHandler().returnResponse(response);
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(response.body);
      final List<Vehicle> loadedVehicles = [];
      final List<Vehicle> loadedHostVehicles = [];
      //var accessId = _cognitoCredentials.accessKeyId.toString();
      print('USER EMAIL at Fetch : $userEmail');
      responseJson.forEach(
        (vehicleId, vehiData) {
          print(vehiData['hostId'].toString());
          if (vehiData['hostId'].toString() == userEmail) {
            loadedHostVehicles.add(
              Vehicle(
                  vehicleId: vehicleId.toString(),
                  vehicleDescription: vehiData['vehicleDescription'].toString(),
                  pricePerDay:
                      double.parse(vehiData['vehicleDayPrice'].toString()),
                  vehicleTitle: vehiData['vehicleName'],
                  isFavourite: vehiData['isVehicleFavourite'] == 'true',
                  imageUrl: vehiData['vehicleProfileImageUrl'].toString()),
            );
          }
          loadedVehicles.add(
            Vehicle(
                vehicleId: vehiData['vehicleId'].toString(),
                hostId: vehiData['hostId'].toString(),
                hostName: vehiData['hostName'].toString(),
                hostPhoneNumber: vehiData['hostPhoneNumber'].toString(),
                vehicleType: vehiData['vehicleType'].toString(),
                vehicleNumOfSeats:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehicleKmPerL:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehiclePickupLocation:
                    vehiData['vehiclePickupLocation'].toString(),
                vehicleReturnLocation:
                    vehiData['vehicleReturnLocation'].toString(),
                vehicleAvaliableStartDate:
                    vehiData['vehicleAvaliableStartDate'].toString(),
                vehicleAvaliableEndDate:
                    vehiData['vehicleAvaliableEndDate'].toString(),
                vehicleDescription: vehiData['vehicleDescription'].toString(),
                vehicleRegNumber: vehiData['vehicleRegNumber'].toString(),
                vehicleTag1: vehiData['vehicleTag1'].toString(),
                vehicleTag2: vehiData['vehicleTag2'].toString(),
                vehicleTag3: vehiData['vehicleTag3'].toString(),
                vehicleImageUrl1: vehiData['vehicleImageUrl1'].toString(),
                vehicleImageUrl2: vehiData['vehicleImageUrl2'].toString(),
                vehicleImageUrl3: vehiData['vehicleImageUrl3'].toString(),
                pricePerDay:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehicleTitle: vehiData['vehicleName'],
                isFavourite: vehiData['isVehicleFavourite'] == 'true',
                imageUrl: vehiData['vehicleProfileImageUrl'].toString()),
          );
        },
      );

      //Store fetched items.
      _hostItems = loadedHostVehicles;
      _items = loadedVehicles;
      
      notifyListeners();
    } on SocketException catch (error) {
      print('SocketException Occurred(1) : $error');
      throw new HttpException('No internet');
      //notifyListeners();
    } catch (error) {
      print('Regualr error (1) : $error');
      throw (error);
      //notifyListeners();
    }
    notifyListeners();
  }


//Get the vehicles hosted by owner.
Future<void> fetchHostedVehicles() async {
    print('idToken @ fetchAndSetVehicles: ' + idToken);
    final url =
        'https://ao83dvqxaf.execute-api.ap-south-1.amazonaws.com/dev/host';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$idToken'
        },
      ).timeout(Duration(seconds: 8));
      //print(response.body);
      //var responseJson = HttpResponseHandler(response);
      final responseJson = HttpResponseHandler().returnResponse(response);
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(response.body);
      final List<Vehicle> loadedVehicles = [];
      final List<Vehicle> loadedHostVehicles = [];
      //var accessId = _cognitoCredentials.accessKeyId.toString();
      print('USER EMAIL at Fetch : $userEmail');
      responseJson.forEach(
        (vehicleId, vehiData) {
          print(vehiData['hostId'].toString());
          if (vehiData['hostId'].toString() == userEmail) {
            loadedHostVehicles.add(
              Vehicle(
                  vehicleId: vehicleId.toString(),
                  vehicleDescription: vehiData['vehicleDescription'].toString(),
                  pricePerDay:
                      double.parse(vehiData['vehicleDayPrice'].toString()),
                  vehicleTitle: vehiData['vehicleName'],
                  isFavourite: vehiData['isVehicleFavourite'] == 'true',
                  imageUrl: vehiData['vehicleProfileImageUrl'].toString()),
            );
          }
          loadedVehicles.add(
            Vehicle(
                vehicleId: vehiData['vehicleId'].toString(),
                hostId: vehiData['hostId'].toString(),
                hostName: vehiData['hostName'].toString(),
                hostPhoneNumber: vehiData['hostPhoneNumber'].toString(),
                vehicleType: vehiData['vehicleType'].toString(),
                vehicleNumOfSeats:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehicleKmPerL:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehiclePickupLocation:
                    vehiData['vehiclePickupLocation'].toString(),
                vehicleReturnLocation:
                    vehiData['vehicleReturnLocation'].toString(),
                vehicleAvaliableStartDate:
                    vehiData['vehicleAvaliableStartDate'].toString(),
                vehicleAvaliableEndDate:
                    vehiData['vehicleAvaliableEndDate'].toString(),
                vehicleDescription: vehiData['vehicleDescription'].toString(),
                vehicleRegNumber: vehiData['vehicleRegNumber'].toString(),
                vehicleTag1: vehiData['vehicleTag1'].toString(),
                vehicleTag2: vehiData['vehicleTag2'].toString(),
                vehicleTag3: vehiData['vehicleTag3'].toString(),
                vehicleImageUrl1: vehiData['vehicleImageUrl1'].toString(),
                vehicleImageUrl2: vehiData['vehicleImageUrl2'].toString(),
                vehicleImageUrl3: vehiData['vehicleImageUrl3'].toString(),
                pricePerDay:
                    double.parse(vehiData['vehicleDayPrice'].toString()),
                vehicleTitle: vehiData['vehicleName'],
                isFavourite: vehiData['isVehicleFavourite'] == 'true',
                imageUrl: vehiData['vehicleProfileImageUrl'].toString()),
          );
        },
      );
      _hostItems = loadedHostVehicles;
      _items = loadedVehicles;
      print('HOSTED VEHICLE');
      print(_items);
      //print('Hello RefreshIndicator');
      notifyListeners();
    } on SocketException catch (error) {
      print('SocketException Occurred(1) : $error');
      throw new HttpException('No internet');
      //notifyListeners();
    } catch (error) {
      print('Regualr error (1) : $error');
      throw (error);
      //notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchAVehicleDetail(String id) async {
    final url =
        'https://ao83dvqxaf.execute-api.ap-south-1.amazonaws.com/dev/$id';
    //final url = 'https://gonow-v5.firebaseio.com/vehicles$id.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Vehicle> loadedVehicles = [];

      loadedVehicles.add(
        Vehicle(
            vehicleId: extractedData['vehicleId'].toString(),
            hostId: extractedData['hostId'].toString(),
            hostName: extractedData['hostName'].toString(),
            hostPhoneNumber: extractedData['hostPhoneNumber'].toString(),
            vehicleType: extractedData['vehicleType'].toString(),
            vehicleNumOfSeats:
                double.parse(extractedData['vehicleDayPrice'].toString()),
            vehicleKmPerL:
                double.parse(extractedData['vehicleDayPrice'].toString()),
            vehiclePickupLocation:
                extractedData['vehiclePickupLocation'].toString(),
            vehicleReturnLocation:
                extractedData['vehicleReturnLocation'].toString(),
            vehicleAvaliableStartDate:
                extractedData['vehicleAvaliableStartDate'].toString(),
            vehicleAvaliableEndDate:
                extractedData['vehicleAvaliableEndDate'].toString(),
            vehicleDescription: extractedData['vehicleDescription'].toString(),
            vehicleRegNumber: extractedData['vehicleRegNumber'].toString(),
            vehicleTag1: extractedData['vehicleTag1'].toString(),
            vehicleTag2: extractedData['vehicleTag2'].toString(),
            vehicleTag3: extractedData['vehicleTag3'].toString(),
            vehicleImageUrl1: extractedData['vehicleImageUrl1'].toString(),
            vehicleImageUrl2: extractedData['vehicleImageUrl2'].toString(),
            vehicleImageUrl3: extractedData['vehicleImageUrl3'].toString(),
            pricePerDay:
                double.parse(extractedData['vehicleDayPrice'].toString()),
            vehicleTitle: extractedData['vehicleName'],
            isFavourite: extractedData['isVehicleFavourite'] == 'true',
            imageUrl: extractedData['vehicleProfileImageUrl'].toString()),
      );

      _singleItem = loadedVehicles;
      //print(jsonDecode(response.body));
      print('Hello RefreshIndicator');
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //Add a new vehicle to server
  Future<void> addVehicle(Vehicle vehicle) async {
    print('IDENTIYID @ addVehicle : ' + identityId);
    //print('Vehicle to Upload ::: ' );
    //print(vehicle);
    const url =
        'https://ao83dvqxaf.execute-api.ap-south-1.amazonaws.com/dev/host';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$idToken'
        },
        body: json.encode(
          {
            "vehicleId": "AUTO",
            "hostId": "This is the spot for the identity id.",
            "hostName": "Atlas",
            "hostPhoneNumber": "LOve YOU",
            "vehicleName": vehicle.vehicleTitle,
            "vehicleType": "Cardh",
            "vehicleNumOfSeats": 5,
            "vehicleKmPerL": 5.32,
            "vehicleDayPrice": vehicle.pricePerDay,
            "vehiclePickupLocation": "NOyeyeeNE",
            "vehicleReturnLocation": "NOeyeyNE",
            "vehicleAvaliableStartDate": "27 DEC y2019",
            "vehicleAvaliableEndDate": "5 JAN 2020",
            "vehicleDescription": vehicle.vehicleDescription,
            "vehicleRegNumber": "r3rcxce3313",
            "isVehicleFavourite": true,
            "vehicleTag1": "reliyeyeable",
            "vehicleTag2": "reeyetro",
            "vehicleTag3": "fasyeyet",
            "vehicleProfileImageUrl":
                'https://upload.wikimedia.org/wikipedia/en/9/95/Test_image.jpg',
            "vehicleImageUrl1":
                "https://homepages.cae.wisc.edu/~ece533/images/mountain.png",
            "vehicleImageUrl2":
                "https://homepages.cae.wisc.edu/~ece533/images/serrano.png",
            "vehicleImageUrl3":
                "https://homepages.cae.wisc.edu/~ece533/images/tulips.png",
            "vehicleAvailability": true,
            "vehicleTripId": "NONE"
          },
        ),
      );
      print(response.toString());
      print(json.decode(response.body));
      final newVehicle = Vehicle(
        vehicleTitle: vehicle.vehicleTitle,
        vehicleDescription: vehicle.vehicleDescription,
        pricePerDay: vehicle.pricePerDay,
        imageUrl: vehicle.imageUrl,
        vehicleId: json.decode(response.body.toString()),
      );
      _items.add(newVehicle);
      //_items.add(value);
      notifyListeners();
    } catch (error) {
      print('error caught');
      //passes error to the edit vehicle page
      print(error);
      throw error;
      //notifyListeners();
    }
    /*
    }).catchError((error) {
      print('error caught');
      //passes error to the edit vehicle page
      throw error;
      //notifyListeners();
    });
    */
  }

  Future<void> addVehicle2(Vehicle vehicle) async {
    const url = 'https://gonow-v5.firebaseio.com/vehicles.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': vehicle.vehicleTitle,
          'description': vehicle.vehicleDescription,
          'imageUrl': vehicle.imageUrl,
          'price': vehicle.pricePerDay,
          'isFavouite': vehicle.isFavourite,
        }),
      );

      //print(json.decode(response.body));
      final newVehicle = Vehicle(
        vehicleTitle: vehicle.vehicleTitle,
        vehicleDescription: vehicle.vehicleDescription,
        pricePerDay: vehicle.pricePerDay,
        imageUrl: vehicle.imageUrl,
        vehicleId: json.decode(response.body)['name'],
      );
      _items.add(newVehicle);
      //_items.add(value);
      notifyListeners();
    } catch (error) {
      print('error caught');
      //passes error to the edit vehicle page
      print(error);
      throw error;
      //notifyListeners();
    }
    /*
    }).catchError((error) {
      print('error caught');
      //passes error to the edit vehicle page
      throw error;
      //notifyListeners();
    });
    */
  }

  Future<void> updateVehicle(String id, Vehicle forUpdateVehicle) async {
    final vehiIndex = _items.indexWhere((vehi) => vehi.vehicleId == id);
    if (vehiIndex >= 0) {
      final url = 'https://gonow-v5.firebaseio.com/vehicles/$id.json';
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': forUpdateVehicle.vehicleTitle,
              'description': forUpdateVehicle.vehicleDescription,
              'price': forUpdateVehicle.pricePerDay,
              'imageUrl': forUpdateVehicle.imageUrl,
              //'isFavourite': forUpdateVehicle.isFavourite,
            },
          ),
        );
      } catch (error) {
        print(
          json.decode(error),
        );
      }

      _items[vehiIndex] = forUpdateVehicle;
      notifyListeners();
    }
    print('updateVehicle in vehicles provider');
  }

  Future<void> deleteVehicle(String id) async {
    final url =
        'https://ao83dvqxaf.execute-api.ap-south-1.amazonaws.com/dev/vehicle/$id';

    final existingVehicleIndex =
        _items.indexWhere((vehi) => vehi.vehicleId == id);
    var existingVehicle = _items[existingVehicleIndex];
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      _items.removeAt(existingVehicleIndex);
      _hostItems.removeAt(existingVehicleIndex);
      print(response);
      notifyListeners();
    } catch (e) {
      _items.insert(existingVehicleIndex, existingVehicle);
      throw HttpException('Could not delete vehicle. Please try again');
    }

    existingVehicle = null;
    notifyListeners();
  }
}
