import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/app_config.dart';
import '../helpers/flat_button.dart';

class GenericDialog extends StatelessWidget {
  final String? title;
  final String ?message;
  final String? imagePath;
  final String? buttonText;
  final Widget? accept;
  final Widget? cancel;
  //final VoidCallback? onClose;

  final bool? showDefaultActions;

  final OffertaMode? tipologia;

  final Widget? action;


  const GenericDialog({
    super.key,
    this.title = '',
    this.message = '',
    this.imagePath = 'assets/img/exclamation.svg',
    //this.onClose,
    this.buttonText,
    this.showDefaultActions = true,
    this.tipologia,
    this.accept,
    this.cancel,
    this.action,

  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0,
        child: contentBox(context),
      ),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text( tipologia != null ? buildTitle() : title!,
                textAlign: TextAlign.center,
                style: ExtraTextStyles.mediumPrimarySemiBold,
              ),
              const SizedBox(height: 16),
              Text( tipologia != null ? buildMessage() : message!,
                textAlign: TextAlign.center,
                style: ExtraTextStyles.mediumGrey,
              ),
              const SizedBox(height: 16),
              if (action != null) action!,
              if (showDefaultActions != null && showDefaultActions!)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ELIMINA', style: ExtraTextStyles.mediumColorBold(Colors.red),)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('ANNULLA', style: ExtraTextStyles.mediumColorBold(Colors.green))),
                ],
              ),

            ],
          ),
        ),
        Positioned(
          top: -50,
          child: SvgPicture.asset(
            imagePath!,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: -60,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: AppColors.error),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

      ],
    );
  }

  String buildTitle() {
    switch (tipologia) {
      case OffertaMode.inviata:
        return 'La tua proposta è stata inoltrata con successo!';
      case OffertaMode.accettata:
        return 'La tua offerta è stata accettata!';
      case OffertaMode.rifiutata:
        return 'Ops! La tua offerta è stata rifiutata';
      default:
        return '';
    }
  }

  String buildMessage() {
    switch (tipologia) {
      case OffertaMode.inviata:
        return 'Attendi la conferma del pagamento e potrai contattare l\'interessato.';
      case OffertaMode.accettata:
        return 'Il bringer scelto ti aiuterà a consegnare il tuo pacco.';
      case OffertaMode.rifiutata:
        return 'ma niente paura, ci sono tanti altri bringers che aspoettano solo te!';
      default:
        return '';
    }
  }
}

enum OffertaMode{
  inviata,
  accettata,
  rifiutata
}