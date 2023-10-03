import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pharma_app/src/models/food_order.dart';
import 'package:pharma_app/src/repository/settings_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../providers/cart_provider.dart';
import '../../providers/paypal_provider.dart';
import '../../providers/user_provider.dart';

class PayPalPaymentWidget extends ConsumerStatefulWidget {
  const PayPalPaymentWidget({super.key});

  @override
  ConsumerState<PayPalPaymentWidget> createState() =>
      _PayPalPaymentWidgetState();
}

class _PayPalPaymentWidgetState extends ConsumerState<PayPalPaymentWidget> {
  late String _apiToken;
  @override
  void initState() {
    _apiToken = 'api_token=${currentUser.value.apiToken}';
  }

  @override
  Widget build(BuildContext context) {
    final paypalProv = ref.watch(paypalProvider);
    paypalProv.url =
        '${GlobalConfiguration().getValue('base_url')}payments/paypal/express-checkout?$_apiToken&${paypalProv.order.toPaypalMap()}';
    logger.info(paypalProv.url);
    return Scaffold(
      //key: paypalProv.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).paypal_payment,
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: paypalProv.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              paypalProv.webView = controller;
            },
            onPageStarted: (String url) {
              print("Page started loading: $url");
              setState(() {
                paypalProv.url = url;
              });
              if (url ==
                  "${GlobalConfiguration().getValue('base_url')}payments/paypal") {
                Navigator.of(context).pushReplacementNamed(
                  'OrderSuccess',
                );
              }
            },
            onPageFinished: (String url) {
              setState(() {
                paypalProv.progress = 1;
              });
            },
          ),
          paypalProv.progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
