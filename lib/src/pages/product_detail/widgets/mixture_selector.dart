import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../components/custom_check_box.dart';
import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';

class MixtureSelector extends StatefulWidget {
  final List<Extra> mixtures;
  final Function(Extra addition)? onSelect;
  const MixtureSelector(
      {Key? key, required this.mixtures, required this.onSelect})
      : super(key: key);
  @override
  State<MixtureSelector> createState() => _MixtureSelectorState();
}

class _MixtureSelectorState extends State<MixtureSelector> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return widget.mixtures.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text("Tipo di impasto",
                    style: context.textTheme.bodyText1
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                  widget.mixtures.length,
                  (index) => SizedBox(
                    width: 125,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomCheckbox(
                            size: 25,
                            value: current == index,
                            type: CheckboxType.circle,
                            activeIcon: null,
                            activeBorderColor: AppColors.primary,
                            activeBgColor: AppColors.gray6,
                            activeBorderWidth: 5,
                            inactiveBorderColor: Colors.transparent,
                            onChanged: (value) {
                              widget.onSelect!(widget.mixtures[index])?.call();
                              setState(() {
                                current = index;
                              });
                            },
                          ),
                        ),
                        Text(widget.mixtures[index].name!),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
