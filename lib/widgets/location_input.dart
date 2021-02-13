import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../models/place.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;

  LocationInput(this.onSelectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation _place;

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();
    setState(() {
      _place = PlaceLocation(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        address: 'Some address',
      );
    });
    widget.onSelectLocation(_place);
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(_place.latitude, _place.longitude),
        zoom: 18.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_place.latitude, _place.longitude),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 35,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _place == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : _buildMap(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
