import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class ReviewsBars extends StatelessWidget {
  const ReviewsBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.mqw * 0.80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              //TODO legge da provider il numero delle recensioni con x stelle (value)
              _LinearIndicator(
                leftContent: "5 stelle",
                rightContent: "84%",
                value: 0.84,
              ),
              _LinearIndicator(
                  leftContent: "4 stelle", rightContent: "64%", value: 0.64),
              _LinearIndicator(
                  leftContent: "3 stelle", rightContent: "35%", value: 0.35),
              _LinearIndicator(
                  leftContent: "2 stelle", rightContent: "24%", value: 0.24),
              _LinearIndicator(
                  leftContent: "1 stelle", rightContent: "12%", value: 0.12)
            ],
          )),
    );
  }
}

class _LinearIndicator extends StatelessWidget {
  final String leftContent;
  final String rightContent;

  final double value;

  const _LinearIndicator({
    Key? key,
    required this.leftContent,
    required this.rightContent,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            leftContent,
            style: context.textTheme.subtitle2
                ?.copyWith(color: const Color(0xFF333333)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 12),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(),
                    decoration: const ShapeDecoration(
                      // TODO colore
                      color: Color(0XFFF2F2F2),
                      shape: StadiumBorder(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18)),
                        child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: const Color(0XFFF2F2F2),
                            minHeight: 16,
                            color: context.colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(rightContent,
              style: context.textTheme.subtitle2
                  ?.copyWith(color: const Color(0xFF333333))),
        ],
      ),
    );
  }
}
