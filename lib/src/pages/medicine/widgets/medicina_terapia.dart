import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screenReminder.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../models/farmaco.dart';
import '../../../providers/terapia_provider.dart';

part 'medicina_terapia.g.dart';

@JsonSerializable()
class MedicinaTerapia extends ConsumerWidget {
  final Farmaco farmaco;
  final String nomeTerapia;
  final List<int> giorni;
  final String durata;
  final String quantita;
  final String orario;
  const MedicinaTerapia(
    this.farmaco,
    this.nomeTerapia,
    this.giorni,
    this.durata,
    this.quantita,
    this.orario,
  );

  factory MedicinaTerapia.fromJson(Map<String, dynamic> json) =>
      _$MedicinaTerapiaFromJson(json);

  Map<String, dynamic> toJson() => _$MedicinaTerapiaToJson(this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terapiaProv = ref.read(terapiaProvider);

    return Container(
      width: 366,
      height: 198,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image(
                    width: 124,
                    height: 170,
                    image: NetworkImage(farmaco.image!.url!)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nome ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 140, 149, 149),
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: context.mqw * 0.25,
                      ),
                      DropdownButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'rimuovi',
                            child: Container(
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Rimuovi',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == 'rimuovi') {
                            terapiaProv.remove(this);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    farmaco.name!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Terapia ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 140, 149, 149),
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    nomeTerapia,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Prossima dose ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 140, 149, 149),
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    orario,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
    /*   return Dismissible(
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
        Provider.of<TerapiaProvider>(context, listen: false)
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
            trailing: Text(durata as String),
          ),
        ),
      ),
    );*/
  }
}
