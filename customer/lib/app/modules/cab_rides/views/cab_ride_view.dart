import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CabRideView extends StatefulWidget {
  const CabRideView({super.key});

  @override
  State<CabRideView> createState() => _CabRideViewState();
}

class _CabRideViewState extends State<CabRideView> {
  final Completer<GoogleMapController> _mapController = Completer();
  final ValueNotifier<int> _selectedRide = ValueNotifier<int>(0);
  final ValueNotifier<double> _fare = ValueNotifier<double>(35);
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  double _mapBottomPadding = 0;
  double _lastExtent = 0.35;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.5883, -7.6114), // Casablanca
    zoom: 12.5,
  );

  final List<RideType> _rideTypes = const [
    RideType(
      title: 'Ride',
      subtitle: '4 • 3 min',
      asset: 'assets/rides/ride4.png',
    ),
    RideType(
      title: 'Comfort',
      subtitle: '4 • 3 min',
      asset: 'assets/rides/comfort4.png',
    ),
    RideType(
      title: 'Moto',
      subtitle: '1 • 3 min',
      asset: 'assets/rides/moto.png',
    ),
    RideType(
      title: 'Taxi',
      subtitle: '4 • 3 min',
      asset: 'assets/rides/taxi.png',
    ),
    RideType(
      title: 'Intercity',
      subtitle: 'City to city',
      asset: 'assets/rides/citytocity.png',
    ),
    RideType(
      title: 'Courier',
      subtitle: 'Delivery',
      asset: 'assets/rides/courries.png',
    ),
    RideType(
      title: 'Freight',
      subtitle: 'Heavy loads',
      asset: 'assets/rides/freight.png',
    ),
  ];

  @override
  void dispose() {
    _selectedRide.dispose();
    _fare.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _MapWidget(
            controllerCompleter: _mapController,
            initialCamera: _initialCameraPosition,
            bottomPadding: _mapBottomPadding,
          ),
          const _CenteredPin(),
          const _PickupOverlay(),
          const _MenuButton(),
          const _LocateButton(),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              final extent = notification.extent;
              final size = MediaQuery.of(notification.context).size;
              final padding = (extent * size.height * 0.55)
                  .clamp(0, size.height)
                  .toDouble();
              if (padding != _mapBottomPadding) {
                setState(() => _mapBottomPadding = padding);
              }
              final snapped = ((extent - 0.30).abs() < 0.01 ||
                      (extent - 0.35).abs() < 0.01 ||
                      (extent - 0.90).abs() < 0.01) &&
                  (extent - _lastExtent).abs() > 0.01;
              if (snapped) {
                HapticFeedback.lightImpact();
              }
              _lastExtent = extent;
              return false;
            },
            child: _RideSheet(
              rideTypes: _rideTypes,
              selectedRide: _selectedRide,
              fare: _fare,
              sheetController: _sheetController,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapWidget extends StatelessWidget {
  const _MapWidget({
    required this.controllerCompleter,
    required this.initialCamera,
    required this.bottomPadding,
  });

  final Completer<GoogleMapController> controllerCompleter;
  final CameraPosition initialCamera;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialCamera,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      padding: EdgeInsets.only(bottom: bottomPadding),
      onMapCreated: (controller) {
        if (!controllerCompleter.isCompleted) {
          controllerCompleter.complete(controller);
        }
        controller.setMapStyle(_mapPoiOffStyle);
      },
      markers: const {},
    );
  }
}

class _CenteredPin extends StatelessWidget {
  const _CenteredPin();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.35),
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 2,
              height: 26,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickupOverlay extends StatelessWidget {
  const _PickupOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 48,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Pickup point',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: const SizedBox(
              height: 48,
              width: 48,
              child: Icon(Icons.menu, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocateButton extends StatelessWidget {
  const _LocateButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: const SizedBox(
              height: 56,
              width: 56,
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _RideSheet extends StatelessWidget {
  const _RideSheet({
    required this.rideTypes,
    required this.selectedRide,
    required this.fare,
    required this.sheetController,
  });

  final List<RideType> rideTypes;
  final ValueNotifier<int> selectedRide;
  final ValueNotifier<double> fare;
  final DraggableScrollableController sheetController;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: 0.35,
      minChildSize: 0.30,
      maxChildSize: 0.90,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SearchSection(),
                  const SizedBox(height: 16),
                  _RideTypeSlider(
                    rideTypes: rideTypes,
                    selectedRide: selectedRide,
                  ),
                  const SizedBox(height: 16),
                  _PriceSelector(fare: fare),
                  const SizedBox(height: 16),
                  _FindDriverButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Where to & for how much?',
            hintStyle: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black87),
            filled: true,
            fillColor: const Color(0xFFF5F5F7),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () {},
        ),
        const SizedBox(height: 14),
        _RecentDestination(
          icon: Icons.access_time,
          title: 'Avenue du 7ème Art',
          subtitle: 'Marrakesh',
        ),
        _RecentDestination(
          icon: Icons.place_outlined,
          title: 'Marrakesh Menara Airport',
          subtitle: '',
        ),
        _RecentDestination(
          icon: Icons.place_outlined,
          title: 'Jamaa El-Fna',
          subtitle: '',
        ),
        _RecentDestination(
          icon: Icons.place_outlined,
          title: 'Gare routière de Marrakech',
          subtitle: '',
        ),
      ],
    );
  }
}

class _RecentDestination extends StatelessWidget {
  const _RecentDestination({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RideTypeSlider extends StatefulWidget {
  const _RideTypeSlider({
    required this.rideTypes,
    required this.selectedRide,
  });

  final List<RideType> rideTypes;
  final ValueNotifier<int> selectedRide;

  @override
  State<_RideTypeSlider> createState() => _RideTypeSliderState();
}

class _RideTypeSliderState extends State<_RideTypeSlider> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.24);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ValueListenableBuilder<int>(
        valueListenable: widget.selectedRide,
        builder: (context, selected, _) {
          return PageView.builder(
            controller: _controller,
            itemCount: widget.rideTypes.length,
            padEnds: false,
            itemBuilder: (context, index) {
              final ride = widget.rideTypes[index];
              final isSelected = selected == index;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.selectedRide.value = index;
                },
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  scale: isSelected ? 1.05 : 1.0,
                  child: _RideCard(
                    rideType: ride,
                    isSelected: isSelected,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.rideType,
    required this.isSelected,
  });

  final RideType rideType;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF8E0) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFFB4FF2B) : Colors.grey.shade200,
          width: isSelected ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                rideType.asset,
                fit: BoxFit.contain,
                height: 46,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rideType.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            rideType.subtitle,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSelector extends StatelessWidget {
  const _PriceSelector({required this.fare});

  final ValueNotifier<double> fare;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fare,
      builder: (context, value, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(
                    icon: Icons.remove,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      final next = (fare.value - 1).clamp(0, 10000).toDouble();
                      fare.value = next;
                    },
                  ),
                  Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: Text(
                          'DH ${value.toStringAsFixed(0)}',
                          key: ValueKey(value),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recommended fare',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  _CircleIconButton(
                    icon: Icons.add,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      fare.value = fare.value + 1;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Auto-accept offer',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: false,
                    onChanged: (_) {},
                    activeColor: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 54,
          width: 54,
          child: Icon(
            icon,
            color: Colors.black,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _FindDriverButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB4FF2B),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Find a driver',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class RideType {
  final String title;
  final String subtitle;
  final String asset;

  const RideType({
    required this.title,
    required this.subtitle,
    required this.asset,
  });
}

const String _mapPoiOffStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [{ "visibility": "off" }]
  }
]
''';
