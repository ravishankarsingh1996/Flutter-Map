import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_fab.dart';

class MyMap extends StatefulWidget {
  MyMap({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController mapController;
  MapType mapType = MapType.normal;
  bool isCurrentPosition = false;
  bool isLocationPermission;

  MapType onChangeMapType() {
    if (mapType == MapType.satellite) {
      return mapType = MapType.normal;
    } else {
      return mapType = MapType.satellite;
    }
  }

  onLocationLatLangChanged() {
    if (isCurrentPosition)
      return LatLng(37.4219999, -122.0862462);
    else
      return LatLng(48.8589507, 2.2770205);
  }

  @override
  void initState() {
    checkLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget fancyFab = FancyFab(
      onPressed: (int type) {
        switch (type) {
          case 0:
            if (isCurrentPosition)
              isCurrentPosition = false;
            else
              isCurrentPosition = true;
            mapController.updateMapOptions(GoogleMapOptions(
                cameraPosition:
                    CameraPosition(target: onLocationLatLangChanged())));
            break;
          case 1:
            mapController
                .updateMapOptions(GoogleMapOptions(mapType: onChangeMapType()));
            break;
          case 2:
            checkLocationPermission();
            if (isLocationPermission) {
              mapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(28.6129, 77.2295),
                zoom: 20.0,
                tilt: 50.0,
                bearing: 45.0,
              )));
              mapController.addMarker(MarkerOptions(
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                position: LatLng(28.6129, 77.2295),
                infoWindowText: InfoWindowText(
                    "India Gate", "New Delhi, India."),
              ));
            }
            break;
        }
      },
      icon: Icons.details,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 80,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(color: Colors.white)),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.zoom_in),
                    onPressed: () {
                      if (mapController != null) {
                        mapController.animateCamera(CameraUpdate.zoomIn());
                      }
                    },
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(color: Colors.white)),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.zoom_out),
                      onPressed: () {
                        if (mapController != null) {
                          mapController.animateCamera(CameraUpdate.zoomOut());
                        }
                      },
                    ))
              ],
            ),
          )
        ],
      ),
      floatingActionButton: fancyFab,
    );
  }

  void checkLocationPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    switch (permission) {
      case PermissionStatus.denied:
      case PermissionStatus.disabled:
      case PermissionStatus.restricted:
      case PermissionStatus.unknown:
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.location]);
        break;
      case PermissionStatus.granted:
        isLocationPermission = true;
        break;
    }
  }
}
