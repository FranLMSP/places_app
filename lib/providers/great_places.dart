import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image, PlaceLocation place) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: place,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(DBHelper.userPlacesTable, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData(DBHelper.userPlacesTable);
    _items = dataList.map((item) => Place(
      id: item['id'],
      title: item['title'],
      image: File(item['image']),
      location: PlaceLocation(
        latitude: item['latitude'],
        longitude: item['longitude'],
        address: item['address'],
      ),
    )).toList();
    notifyListeners();
  }
}