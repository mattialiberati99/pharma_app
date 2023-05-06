import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../providers/home_cuisines_provider.dart';
import '../../preHome/widgets/drop_chip.dart';

class HomeCuisineFilter extends ConsumerStatefulWidget {
  final String? cuisineSelected;
  final Function onCuisineSelected;

  const HomeCuisineFilter({
    this.cuisineSelected,
    required this.onCuisineSelected,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeCuisineFilter> createState() => _HomeCategoryFilterState();
}

class _HomeCategoryFilterState extends ConsumerState<HomeCuisineFilter> {
  bool showAll = true;

  @override
  Widget build(BuildContext context) {
    final homeCuisines = ref.watch(homeSubCuisinesProvider);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Categorie',
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 28, 31, 30),
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Vedi tutti',
                style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 28, 31, 30),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150, minWidth: 400),
          child: AsyncValueWidget(
            value: homeCuisines,
            data: (subCuisines) => ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                width: 50,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: subCuisines.length,
              itemBuilder: (_, index) {
                final label = subCuisines[index].name;
                final cuisine = subCuisines[index];

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        child: Container(
                          color: Colors.white,
                          height: 98,
                          width: 75,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropChip(
                                    selected:
                                        widget.cuisineSelected == cuisine.id,
                                    iconPath: index != 0
                                        ? subCuisines[index].image!.url!
                                        : 'http://ctechdev.ddns.net:8000/tac_backend/storage/app/public/257/tutto.svg',
                                    size: context.mqw * 0.127,
                                    iconSize: context.mqw * 0.06,
                                    unSelectedColor: context.colorScheme.primary
                                        .withOpacity(0.10),
                                    onSelected: () => {
                                          widget.onCuisineSelected(cuisine),
                                          showAll = false
                                        }),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  index != 0 ? label! : "Tutto",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyText1?.copyWith(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 9, 15, 71)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
