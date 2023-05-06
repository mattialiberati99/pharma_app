import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          //TODO colore bordo
          border: Border.all(color: const Color(0XFFE8E8E8), width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.mqw * 0.80,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Luisa Bianchi",
                    style: context.textTheme.bodyText1?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff555555)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "15 giugno 2022",
                      style: context.textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                          color: const Color(
                              0xff737373)), //TODO aggiungere ai colori second text color
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: _StarsRow(
                      rate: 4,
                    ), //TODO prende in ingresso il rate
                  ),
                  Text(
                    "Consegna rapida e nei tempi, tutto come da descrizione. Prodotti ottimi",
                    style: context.textTheme.bodyText1?.copyWith(
                        fontSize: 14, color: const Color(0xff737373)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    //TODO aggiungere ai colori second text color
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

//TODO prende in ingresso l'id della review o la review
class _StarsRow extends StatelessWidget {
  final double rate;
  const _StarsRow({
    Key? key,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
            5,
            (index) => index <= rate - 1
                ? const Icon(Icons.star, size: 18, color: Color(0xFFFFB24D))
                : const Icon(Icons.star_border,
                    size: 18, color: Color(0xFFFFB24D))));
  }
}
