import 'dart:math';

import 'package:flutter/material.dart';

import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';

class SizeSelector extends StatefulWidget {
  final List<Extra> sizes;
  final Function(Extra size)? onSelect;
  const SizeSelector({Key? key, required this.sizes, required this.onSelect}) : super(key: key);
  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return widget.sizes.isNotEmpty?
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Padding(
           padding: const EdgeInsets.only(bottom: 8.0),
           child: Text(
             "Taglia"
           ),
         ),
         SizedBox(
           height: 45,
           child: ListView.builder(
               padding: EdgeInsets.zero,
               itemCount: widget.sizes.length,
               scrollDirection: Axis.horizontal,
               itemBuilder: (context, index) => Padding(
                 padding: const EdgeInsets.only(right: 8.0),
                 child: ChoiceChip(
                   selectedColor: AppColors.primary,
                   backgroundColor: AppColors.primary.withOpacity(0.1),
                   label: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(widget.sizes[index].name!,
                     style: ExtraTextStyles.smallBlack,),
                   ),
                   selected: current == index,
                   onSelected: (bool selected) {
                      setState(() {
                        current = selected ? index : 0;
                        widget.onSelect!(widget.sizes[current]);
                      });
                   },
                 ),
               )),
         ),
       ],
     ):Container();
  }
}
