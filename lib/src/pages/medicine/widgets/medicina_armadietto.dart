import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/farmaco.dart';
import '../../../providers/armadietto_provider.dart';

class MedicinaArmadietto extends StatelessWidget {
  final Farmaco farmaco;
  final DateTime scadenza;
  const MedicinaArmadietto(this.farmaco, this.scadenza, {super.key});

  @override
  Widget build(BuildContext context) {
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
        Provider.of<ArmadiettoProvider>(context, listen: false)
            .removeWithId(farmaco.id!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image(
              image: NetworkImage(farmaco.image!.url!),
            ),
            title: const Text('Nome'),
            subtitle: Text(farmaco.name!),
            trailing: Text(scadenza as String),
          ),
        ),
      ),
    );
  }
}
