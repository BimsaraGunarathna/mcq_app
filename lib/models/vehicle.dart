import 'package:flutter/foundation.dart';

class Vehicle with ChangeNotifier{
  final String vehicleId;
  final String vehicleTitle;
  final String vehicleDescription;
  final double pricePerDay;
  final String imageUrl;
  final String hostId;
  final String hostName;
  final String hostPhoneNumber;
  final String vehicleType;
  final double vehicleNumOfSeats;
  final double vehicleKmPerL;
  final String vehiclePickupLocation;
  final String vehicleReturnLocation;
  final String vehicleAvaliableStartDate;
  final String vehicleAvaliableEndDate;
  final String vehicleRegNumber;
  final String vehicleTag1;
  final String vehicleTag2;
  final String vehicleTag3;
  final String vehicleImageUrl1;
  final String vehicleImageUrl2;
  final String vehicleImageUrl3;
  final bool vehicleAvailability;
  final String vehicleTripId;

  bool isFavourite;

  //Later added.
  final String vehicleModel;
  final String vehicleOdometer;
  final String vehicleTransmission;
  final String vehicleLocation;
  final bool isVehiclePersonalOrCommercial;

Vehicle ({
  @required this.vehicleId,
  @required this.vehicleTitle,
  @required this.vehicleDescription,
  @required this.pricePerDay,
  this.imageUrl,
  this.isFavourite = false,
  
  //Host Details
  this.hostId,
  this.hostName,
  this.hostPhoneNumber,

  //Vehicle Details
  this.vehicleType,
  this.vehicleNumOfSeats,
  this.vehicleKmPerL,
  this.vehiclePickupLocation,
  this.vehicleReturnLocation,
  this.vehicleAvaliableStartDate,
  this.vehicleAvaliableEndDate,
  this.vehicleRegNumber,
  this.vehicleTag1,
  this.vehicleTag2,
  this.vehicleTag3,
  this.vehicleImageUrl1,
  this.vehicleImageUrl2,
  this.vehicleImageUrl3,
  this.vehicleAvailability,
  this.vehicleTripId,

  //Later added.
  this.vehicleModel,
  this.vehicleOdometer,
  this.vehicleTransmission,
  this.vehicleLocation,
  this.isVehiclePersonalOrCommercial,

});

void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
}

}