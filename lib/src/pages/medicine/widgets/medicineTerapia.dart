import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screenReminder.dart';
import 'package:provider/provider.dart';

import '../../../models/farmaco.dart';
import '../../../providers/terapia_provider.dart';

class MedicinaTerapia extends StatelessWidget {
  final Farmaco farmaco;
  final String nomeTerapia;
  final List<int> giorni;
  final String durata;
  final String quantita;
  final String orario;
  const MedicinaTerapia(this.farmaco, this.nomeTerapia, this.giorni,
      this.durata, this.quantita, this.orario,
      {super.key});

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'Nome ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 140, 149, 149),
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: context.mqw * 0.45,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenReminder(
                                        farmaco,
                                        nomeTerapia,
                                        giorni,
                                        durata,
                                        quantita,
                                        orario)));
                          },
                          icon: Icon(Icons.more_vert))
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
