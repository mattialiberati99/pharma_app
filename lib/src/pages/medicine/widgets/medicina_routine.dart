import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screenReminder.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sizer/sizer.dart';

import '../../../models/farmaco.dart';
import '../../../providers/routine_provider.dart';

part 'medicina_routine.g.dart';

@JsonSerializable()
class MedicinaRoutine extends ConsumerWidget {
  final Farmaco farmaco;
  final String nomeRoutine;
  final List<int> giorni;
  final String durata;
  final String quantita;
  final String orario;
  const MedicinaRoutine(
    this.farmaco,
    this.nomeRoutine,
    this.giorni,
    this.durata,
    this.quantita,
    this.orario,
  );

  factory MedicinaRoutine.fromJson(Map<String, dynamic> json) =>
      _$MedicinaRoutineFromJson(json);

  Map<String, dynamic> toJson() => _$MedicinaRoutineToJson(this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineProv = ref.read(routineProvider);

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
                  image: NetworkImage(farmaco.image!.url!),
                ),
              ),
              const SizedBox(
                  width: 8), 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nome ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 140, 149, 149),
                            fontSize: 10.sp,
                          ),
                        ),
                        const Spacer(), // Use Spacer to push the DropdownButton to the right.
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
                                    SizedBox(width: 5),
                                    Text('Rimuovi',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == 'rimuovi') {
                              routineProv.remove(this);
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      farmaco.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      'Routine ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 140, 149, 149),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.4.h), // Add spacing.
                    Text(
                      nomeRoutine,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.1.h),
                    Text(
                      'Prossima dose ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 140, 149, 149),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      orario,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
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
        Provider.of<RoutineProvider>(context, listen: false)
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
