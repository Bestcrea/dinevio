import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/intercity_controller.dart';

class DestinationSheet extends StatefulWidget {
  const DestinationSheet({super.key});

  @override
  State<DestinationSheet> createState() => _DestinationSheetState();
}

class _DestinationSheetState extends State<DestinationSheet> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IntercityController>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              onChanged: vm.search,
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
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: vm.predictions.length,
                itemBuilder: (context, i) {
                  final p = vm.predictions[i];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(p.full),
                    onTap: () async {
                      await vm.pickPrediction(p);
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

