import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/product_detail/widgets/addition_tile.dart';

import '../../../models/extra.dart';

class AdditionsSelector extends StatefulWidget {
  final int selectedIndex;
  final List<Extra> additions;
  final Function(Extra e)? onAdd;
  final Function(Extra e)? onRemove;

  const AdditionsSelector(
      {Key? key,
      this.onAdd,
      this.onRemove,
      required this.selectedIndex,
      required this.additions})
      : super(key: key);

  @override
  State<AdditionsSelector> createState() => _AdditionsSelectorState();
}

class _AdditionsSelectorState extends State<AdditionsSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text("Aggiungi ingredienti",
              style: context.textTheme.bodyText1
                  ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height:
              context.onSmallScreen ? context.mqh * 0.15 : context.mqh * 0.3,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AdditionTile(
                    onAdd: (e) => widget.onAdd!(e)?.call(),
                    onRemove: (e) => widget.onRemove!(e)?.call(),
                    addition: widget.additions[index],
                    indexKey: widget.selectedIndex,
                  ),
                  childCount: widget.additions.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
