import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/intercity_models.dart';
import '../services/location_service.dart';
import '../services/places_service.dart';
import '../services/local_storage_service.dart';

class IntercityController extends ChangeNotifier {
  IntercityController(this._loc, this._places, this._store, this.apiKey);
  final LocationService _loc;
  final PlacesService _places;
  final LocalStorageService _store;
  final String apiKey;

  LocationPoint? origin;
  String? originLabel;
  LocationPoint? destination;
  String? destinationLabel;
  bool loading = false;
  LatLng mapCenter = const LatLng(33.5731, -7.5898); // fallback Casablanca
  List<AddressModel> recent = [];
  List<AddressModel> predictions = [];

  Future<void> init() async {
    loading = true;
    notifyListeners();
    recent = await _store.loadRecent();
    final pos = await _loc.currentPosition();
    if (pos != null) {
      origin = LocationPoint(lat: pos.latitude, lng: pos.longitude);
      mapCenter = origin!.latLng;
      originLabel = await _places.reverseGeocode(origin!);
    }
    loading = false;
    notifyListeners();
  }

  Future<void> search(String input) async {
    predictions = await _places.autocomplete(input);
    notifyListeners();
  }

  Future<void> pickPrediction(AddressModel addr) async {
    if (addr.location.placeId == null) return;
    final loc = await _places.placeDetails(addr.location.placeId!);
    if (loc == null) return;
    destination = loc;
    destinationLabel = addr.full;
    _addRecent(AddressModel(title: addr.title, full: addr.full, location: loc));
    notifyListeners();
  }

  Future<void> setOriginFromCurrent() async {
    final Position? pos = await _loc.currentPosition();
    if (pos == null) return;
    origin = LocationPoint(lat: pos.latitude, lng: pos.longitude);
    originLabel = await _places.reverseGeocode(origin!);
    notifyListeners();
  }

  void setDestination(AddressModel addr) {
    destination = addr.location;
    destinationLabel = addr.full;
    _addRecent(addr);
    notifyListeners();
  }

  void _addRecent(AddressModel addr) {
    recent = [addr, ...recent.where((e) => e.full != addr.full)].take(6).toList();
    _store.saveRecent(recent);
  }

  bool get canContinue => origin != null && destination != null;
}

