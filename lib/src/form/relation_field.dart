import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Selector dinámico que carga datos de una colección de Firestore
class RelationField extends StatelessWidget {
  final String label;
  final String collection;
  final String displayField;
  final String? selectedId;
  final void Function(String id, String displayValue) onSelected;

  RelationField({
    super.key,
    required this.label,
    required this.collection,
    required this.displayField,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ REGLA: Parámetro posicional
        if (label.isNotEmpty) TextBody(label),

        Space(PADDING_SMALL_SIZE),

        if (collection.isEmpty || displayField.isEmpty)
          TextCaption("Error: Colección o campo no definidos", color: COLOR_ERROR)
        else
          FutureBuilder<QuerySnapshot>(
            // Consumimos Firebase directamente desde el widget de librería
            future: FirebaseFirestore.instance.collection(collection).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: FIELD_HEIGHT,
                  decoration: BoxDecorationCustom(radiusSmall: true),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextCaption("Cargando opciones..."),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              // Buscamos el nombre del item seleccionado para el botón del dropdown
              String currentName = "Seleccionar...";
              for (int i = 0; i < docs.length; i++) {
                if (docs[i].id == selectedId) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  currentName = data[displayField]?.toString() ?? docs[i].id;
                }
              }

              return DropdownCustom<QueryDocumentSnapshot>(
                items: docs,
                hintText: currentName,
                tooltip: "Seleccionar $label",
                getName: (doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data[displayField]?.toString() ?? doc.id;
                },
                onChanged: (doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String val = data[displayField]?.toString() ?? doc.id;
                  onSelected(doc.id, val);
                },
              );
            },
          ),
        Space(PADDING_SIZE),
      ],
    );
  }
}