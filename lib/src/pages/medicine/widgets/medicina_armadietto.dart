import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/farmaco.dart';
import '../../../providers/armadietto_provider.dart';

part 'medicina_armadietto.g.dart';

@JsonSerializable()
class MedicinaArmadietto extends ConsumerWidget {
  final Farmaco farmaco;
  final String scadenza;
  const MedicinaArmadietto(this.farmaco, this.scadenza);

  factory MedicinaArmadietto.fromJson(Map<String, dynamic> json) =>
      _$MedicinaArmadiettoFromJson(json);

  Map<String, dynamic> toJson() => _$MedicinaArmadiettoToJson(this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //String data = DateFormat('dd-MM-yyyy').format(scadenza);

    return Dismissible(
      key: ValueKey(farmaco),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ref.watch(armadiettoProvider).removeWithId(farmaco.id!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
              leading: Image(
                image: NetworkImage(farmaco.image!.url!),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nome',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(farmaco.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Scadenza medicinale',
                      style: TextStyle(color: Color.fromARGB(234, 255, 20, 3))),
                  Text(scadenza,
                      style: const TextStyle(
                          color: Color.fromARGB(234, 255, 20, 3))),
                ],
              )),
        ),
      ),
    );
  }
}
