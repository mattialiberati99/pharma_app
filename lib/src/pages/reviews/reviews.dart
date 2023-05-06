import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharma_app/src/components/action_buttons.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/reviews/widget/review_item.dart';
import 'package:pharma_app/src/pages/reviews/widget/reviews_bars.dart';

import '../../components/custom_app_bar.dart';
import '../../components/footer_actions.dart';
import '../login/widgets/CustomTextFormField.dart';

class Reviews extends StatelessWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Recensioni",
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: FooterActions(
        firstLabel: "SCRIVI UNA RECENSIONE", //TODO stringhe
        firstAction: () => _showRatingDialog(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.mqw * 0.08),
            child: Column(
              children: const [
                //TODO stringa
                ReviewsBars(),
                SizedBox(height: 20),
                ReviewItem(),
                ReviewItem(),
                ReviewItem(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showRatingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18))),
          titleTextStyle: context.textTheme.subtitle1?.copyWith(
            fontSize: 24,
            color: Colors.black,
          ),
          title: const Text('SCRIVI UNA RECENSIONE'), //TODO stringhe
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const RatingSelectionBar(),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    textInputType: TextInputType.text,
                    validator: () {},
                    hint: 'Testo recensione...'),
              ],
            ),
          ),
          actions: [
            ActionButtons(
                topPadding: 0,
                firstLabel: "INVIA",
                firstAction: () {},
                secondAction: () => Navigator.pop(context))
          ],
        );
      },
    );
  }
}

class RatingSelectionBar extends StatefulWidget {
  const RatingSelectionBar({
    Key? key,
  }) : super(key: key);

  @override
  State<RatingSelectionBar> createState() => _RatingSelectionBarState();
}

class _RatingSelectionBarState extends State<RatingSelectionBar> {
  var _rate = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            5,
            (index) => IconButton(
                onPressed: () {
                  setState(() {
                    _rate = index + 1;
                  });
                  if (kDebugMode) {
                    print(_rate);
                  }
                },
                icon: index <= _rate - 1
                    ? const Icon(Icons.star, size: 30, color: Color(0xFFFFB24D))
                    : const Icon(Icons.star,
                        size: 30, color: Color(0xFFE0E0E0)) //TODO colore grey 5
                )));
  }
}
