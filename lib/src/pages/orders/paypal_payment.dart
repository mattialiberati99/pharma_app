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
import '../../providers/user_provider.dart';

class PayPalPaymentWidget extends ConsumerStatefulWidget {
  const PayPalPaymentWidget({super.key});

  @override
  ConsumerState<PayPalPaymentWidget> createState() =>
      _PayPalPaymentWidgetState();
}

class _PayPalPaymentWidgetState extends ConsumerState<PayPalPaymentWidget> {
  late String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController controllerGlobal;
  late Order _order = Order();

  @override
  void initState() {
    super.initState();
    final String _apiToken = 'api_token=${currentUser.value.apiToken}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((order) {
        _order = order;
      }).catchError((error) {
        logger.error("Error fetching order: $error");
      });
    });

    selectedUrl =
        '${GlobalConfiguration().getValue('base_url')}payments/paypal/express-checkout?$_apiToken&${_order.toPaypalMap()}';
  }

  Future<Order> _asyncMethod() async {
    final cartProv = ref.read(cartProvider);
    Order _order = Order();
    _order.foodOrders = <FarmacoOrder>[];
    // fixare data consegna
    _order.consegna = DateTime.now();
    _order.importo = cartProv.total.toStringAsFixed(2);
    _order.user = currentUser.value;
    _order.note = 'note';
    _order.farmaciaId =
        int.tryParse(cartProv.carts.first.product!.farmacia!.id!);
    OrderStatus _orderStatus = OrderStatus();
    _orderStatus.id = OrderStatus.received;
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = cartProv.deliveryAddress;
    _order.sconto = cartProv.sconto;
    return _order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            initialUrl: selectedUrl,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.future.then((value) => controllerGlobal = value);
              _controller.complete(webViewController);
              //_controller.future.catchError(onError);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress: $progress%)");
            },
            onPageStarted: (String url) {
              print("Page started loading: $url");
              setState(() {
                _isLoading = true;
              });
              print("printing urls " + url.toString());
              _redirect(url);
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                _isLoading = false;
              });
              _redirect(url);
            },
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _redirect(String url) {
    print("redirect");
    if (_canRedirect) {
      bool _isSuccess = url.contains('success') &&
          url.contains("${GlobalConfiguration().getValue('base_url')}");
      bool _isFailed = url.contains('fail') &&
          url.contains("${GlobalConfiguration().getValue('base_url')}");
      bool _isCancel = url.contains('cancel') &&
          url.contains("${GlobalConfiguration().getValue('base_url')}");
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
        Navigator.of(context).pushReplacementNamed(
          '/OrderSuccess',
        );
      } else if (_isFailed || _isCancel) {
        print("failed");
      } else {
        print("Encountered problem");
      }
    }
  }
}
