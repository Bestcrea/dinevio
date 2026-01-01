import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/intercity_controller.dart';
import 'map_picker_screen.dart';

class IntercityCustomizeScreen extends StatelessWidget {
  const IntercityCustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IntercityController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Customize your ride",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () {},
              child: const Text("Me",
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _RouteInputs(vm: vm),
            const SizedBox(height: 16),
            const _SavedAddresses(),
            const SizedBox(height: 16),
            _QuickActions(vm: vm),
            const SizedBox(height: 16),
            _RecentList(vm: vm),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        vm.canContinue ? Colors.black : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: vm.canContinue ? () {} : null,
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInputs extends StatelessWidget {
  const _RouteInputs({required this.vm});
  final IntercityController vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _InputTile(
            label: "Choose starting point",
            value: vm.originLabel ?? "Detecting current location...",
            dotColor: const Color(0xFF7E3FF2),
            onTap: () async => vm.setOriginFromCurrent(),
          ),
          const SizedBox(height: 10),
          _InputTile(
            label: "Destination",
            value: vm.destinationLabel ?? "Add destination",
            dotColor: Colors.black,
            onTap: () => _openDestSheet(context),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _openDestSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scroll) {
          final c = context.watch<IntercityController>();
          return Column(
            children: [
              Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter destination",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: c.search,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scroll,
                  itemCount: c.predictions.length,
                  itemBuilder: (context, i) {
                    final p = c.predictions[i];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(p.title,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(p.full),
                      onTap: () async {
                        await c.pickPrediction(p);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InputTile extends StatelessWidget {
  const _InputTile({
    required this.label,
    required this.value,
    required this.dotColor,
    required this.onTap,
  });
  final String label;
  final String value;
  final Color dotColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.black87),
              ],
            ),
          ),
          Positioned(
            left: 6,
            top: 26,
            bottom: -26,
            child: Container(
              width: 2,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedAddresses extends StatelessWidget {
  const _SavedAddresses();

  @override
  Widget build(BuildContext context) {
    final chips = ["Add home", "Add work", "Other"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Saved addresses",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text("Easily access your favorite locations.",
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: chips
                .map((c) => Chip(
                      backgroundColor: Colors.grey.shade200,
                      label: Text(c,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.vm});
  final IntercityController vm;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        "Current location",
        Icons.my_location,
        () async => vm.setOriginFromCurrent()
      ),
      (
        "Select location on the map",
        Icons.map_outlined,
        () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const MapPickerScreen()));
        }
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Column(
            children: actions
                .map(
                  (a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(a.$2, color: Colors.black),
                    title: Text(a.$1,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: a.$3,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList({required this.vm});
  final IntercityController vm;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          itemCount: vm.recent.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final item = vm.recent[i];
            return ListTile(
              leading:
                  const Icon(Icons.location_on_outlined, color: Colors.black87),
              title: Text(item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(item.full,
                  style: const TextStyle(color: Colors.black54)),
              trailing: Icon(
                item.isFavorite ? Icons.star : Icons.star_border,
                color: item.isFavorite ? Colors.amber : Colors.black45,
              ),
              onTap: () {
                vm.setDestination(item);
              },
            );
          },
        ),
      ),
    );
  }
}
