import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';

class ColorSelector extends StatefulWidget {
  final List<Extra> colors;
  final Function(Extra color)? onSelect;
  const ColorSelector({Key? key, required this.colors, required this.onSelect}) : super(key: key);
  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return widget.colors.isNotEmpty?
     Container(
      padding: EdgeInsets.only(top: 16),
        height: 102,
        //color: Colors.red,
        //padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Colori"
              ),
            ),
            SizedBox(
              height: 36,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                        height: 40,
                        width: 50,
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () => setState(() {
                            current = index;
                            widget.onSelect!(widget.colors[current]);
                          }),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: current == index
                                    ? AppColors.primary
                                    : AppColors.gray6),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.colors[index].color,
                              ),
                              clipBehavior: Clip.antiAlias,
                            ),
                          ),
                        ),
                      )),
            ),
          ],
        )):Container();
  }
}
