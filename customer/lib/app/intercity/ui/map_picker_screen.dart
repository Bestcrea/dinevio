import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../state/intercity_controller.dart';
import '../models/intercity_models.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IntercityController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select location",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: vm.mapCenter, zoom: 14),
            onTap: (latLng) => setState(() => _picked = latLng),
            markers: _picked != null
                ? {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _picked!,
                    )
                  }
                : {},
            myLocationEnabled: true,
            compassEnabled: false,
            zoomControlsEnabled: false,
          ),
          Center(
            child: IgnorePointer(
              child: Icon(Icons.location_on,
                  size: 42, color: Colors.redAccent.withOpacity(0.85)),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _picked == null
                  ? null
                  : () {
                      vm.setDestination(
                        AddressModel(
                          title: "Selected location",
                          full: "Custom pin",
                          location: LocationPoint(
                              lat: _picked!.latitude, lng: _picked!.longitude),
                        ),
                      );
                      Navigator.pop(context);
                    },
              child: const Text("Use this location",
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          )
        ],
      ),
    );
  }
}
