import 'package:flutter/material.dart';

import '../data/countries.dart';
import '../models/country.dart';

Future<Country?> showCountryPicker(BuildContext context, Country selected) {
  final TextEditingController searchCtrl = TextEditingController();
  List<Country> filtered = kCountries;

  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          void applyFilter(String query) {
            final q = query.toLowerCase();
            setState(() {
              filtered = kCountries
                  .where((c) => c.name.toLowerCase().contains(q) || c.dialCode.contains(q))
                  .toList();
            });
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Choose your country or region',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchCtrl,
                    onChanged: applyFilter,
                    decoration: InputDecoration(
                      hintText: 'Search for a country or region',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isSelected = c.dialCode == selected.dialCode && c.name == selected.name;
                        return ListTile(
                          leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            c.name,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            c.dialCode,
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Color(0xFF7B51B7))
                              : null,
                          onTap: () => Navigator.pop(context, c),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}












