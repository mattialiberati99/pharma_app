import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/components/footer_actions.dart';

import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';

import 'package:pharma_app/src/pages/product_detail/widgets/additions_selector.dart';
import 'package:pharma_app/src/pages/product_detail/widgets/mixture_selector.dart';
import 'package:pharma_app/src/providers/current_additions_notifier.dart';

import '../../helpers/app_config.dart';
import '../../models/extra.dart';
import '../../providers/cart_provider.dart';

class EditRecipePage extends ConsumerStatefulWidget {
  final Farmaco product;
  final int quantity;
  const EditRecipePage(
      {Key? key, required this.product, required this.quantity})
      : super(key: key);

  @override
  ConsumerState<EditRecipePage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<EditRecipePage> {
  int _selected = 0;
  late int _baseQuantity;
  final pageController = PageController(initialPage: 0);
  final additionsController = ScrollController();

  @override
  void initState() {
    super.initState();
    _baseQuantity = widget.quantity;
  }

  @override
  void dispose() {
    pageController.dispose();
    additionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    final currentAdditions = ref.watch(currentAdditionsNotifier);
    final totalAdditions =
        ref.watch(currentAdditionsNotifier.notifier).getTotal();

    bool canProceed = totalAdditions != 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      bottomNavigationBar: FooterActions(
          firstLabel: '${context.loc.action_btn_add} ${totalAdditions.toEUR()}',
          secondLabel: context.loc.action_btn_back_to_menu,
          firstAction: () {
            currentAdditions.forEach((key, value) {
              if (ref
                  .watch(currentAdditionsNotifier.notifier)
                  .hasNoBaseExtra(key, widget.product)) {
                cartProv.add(
                    widget.product,
                    1,
                    ref
                        .watch(currentAdditionsNotifier.notifier)
                        .getExtrasOf(key));
                _baseQuantity -= 1;
              }
            });
            if (_baseQuantity > 0) {
              cartProv.add(widget.product, _baseQuantity, []);
            }
            Navigator.of(context).pop();
          },
          secondAction: () => Navigator.of(context).pop()),
      //TODO stringhe
      appBar: CustomAppBar(
        title: "Modifica Ricetta",
        onPop: () => ref.read(currentAdditionsNotifier.notifier).clear(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: widget.quantity,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    padding: const EdgeInsets.all(8.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withOpacity(0.02),
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.product.name!,
                          style: context.textTheme.bodyText1?.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.all(context.onSmallScreen ? 0 : 8.0),
                          child: Text('${index + 1}',
                              style: context.textTheme.subtitle1),
                        ),
                        Text(
                          ref
                                      .watch(currentAdditionsNotifier.notifier)
                                      .getCurrentTotal(index) !=
                                  0
                              ? '${widget.product.price!.toEUR()} + ${ref.watch(currentAdditionsNotifier.notifier).getCurrentTotal(index).toEUR()}'
                              : widget.product.price!.toEUR(),
                          style: context.textTheme.bodyText1?.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    selected: _selected == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selected = (selected ? index : 0);
                        pageController.jumpToPage(index);
                        // duration: const Duration(milliseconds: 200),
                        // curve: Curves.easeInOut);
                        print('Selezione: $_selected');
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              itemCount: widget.quantity,
              onPageChanged: (index) {
                setState(() {
                  _selected = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: context.mqw * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product.mixtures.isNotEmpty)
                        MixtureSelector(
                          mixtures: widget.product.mixtures,
                          onSelect: (Extra extra) {
                            ref
                                .read(currentAdditionsNotifier.notifier)
                                .update(_selected, extra);
                            setState(() {});
                          },
                        ),
                      if (widget.product.additions.isNotEmpty)
                        AdditionsSelector(
                          additions: widget.product.additions,
                          selectedIndex: _selected,
                          onAdd: (Extra extra) {
                            ref
                                .read(currentAdditionsNotifier.notifier)
                                .add(_selected, extra);
                            setState(
                                () {}); // per aggiornare il totale extra su ogni chip selezionato
                          },
                          onRemove: (Extra extra) {
                            ref
                                .read(currentAdditionsNotifier.notifier)
                                .remove(_selected, extra);
                            setState(
                                () {}); // per aggiornare il totale extra su ogni chip selezionato
                          },
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
