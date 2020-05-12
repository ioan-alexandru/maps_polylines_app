import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoordinates;
  GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(apiKey: 'APIKEY');
  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: onMapCreated,
        polylines: polyline,
        initialCameraPosition: CameraPosition(
          target: LatLng(40.6782, -73.9442),
          zoom: 14,
        ),
        mapType: MapType.normal,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      polyline.add(Polyline(
          polylineId: PolylineId('route driving'),
          visible: true,
          points: routeCoordinates,
          width: 4,
          color: Colors.blue,
          startCap: Cap.squareCap,
          endCap: Cap.roundCap));
    });
  }

  getCoordinates() async {
    var permissions =
        await Permission.requestPermissions([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askPermissions =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoordinates = await _googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(40.6782, -73.9442),
          destination: LatLng(40.6944, -73.9212),
          mode: RouteMode.driving);
    }
  }
}
