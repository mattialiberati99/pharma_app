import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/components/section_header.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/filters/widgets/history_search_tile.dart';

import '../../components/custom_check_box.dart';
import '../../components/footer_actions.dart';
import '../../components/search_bar/filter_search_bar.dart';
import '../../providers/filter_provider.dart';

class Filters extends ConsumerStatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  ConsumerState<Filters> createState() => _FiltersState();
}

class _FiltersState extends ConsumerState<Filters> {
  @override
  Widget build(BuildContext context) {
    final filterProv = ref.watch(filterProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const FooterActions(
        firstLabel: "IMPOSTA",
      ),
      //TODO stringhe
      appBar: const CustomAppBar(title: "Filtri"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //TODO stringa
              const SizedBox(height: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  //TODO colore bordo
                  border:
                      Border.all(color: const Color(0XFFE8E8E8), width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: context.mqw * 0.80, maxHeight: 350),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 23.5, right: 23.5, bottom: 20),
                          child: SearchBarFilter(),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: false,
                              itemCount: filterProv.types.length,
                              itemBuilder: (BuildContext context, index) =>
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 35, right: 35.0, bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          filterProv.types.keys
                                              .elementAt(index)
                                              .name!,
                                          style: context.textTheme.bodyText1
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xff555555)),
                                        ),
                                        CustomCheckbox(
                                          type: CheckboxType.circle,
                                          size: 25,
                                          inactiveBorderColor:
                                              Colors.transparent,
                                          inactiveIcon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          activeIcon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          value: filterProv.types.values
                                              .elementAt(index),
                                          onChanged: (selected) => setState(() {
                                            filterProv.types[filterProv
                                                .types.keys
                                                .elementAt(index)] = selected;
                                          }),
                                        )
                                      ],
                                    ),
                                  )),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.mqw * 0.80),
                  child: const SectionHeader(
                      title: "Ricerche recenti", subTitle: "pulisci tutto")),
              const SizedBox(
                height: 35,
              ),
              //TODO verrà popolato da un builder
              HistorySearchTile(
                title: "pizza margherita",
                onTap: () {},
              ),
              HistorySearchTile(
                title: "scarpe donna",
                onTap: () {},
              ),
              HistorySearchTile(
                title: "frutteria",
                onTap: () {},
              ),
              HistorySearchTile(
                title: "restaurant",
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
