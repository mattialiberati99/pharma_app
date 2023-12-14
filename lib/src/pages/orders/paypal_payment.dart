import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pharma_app/src/pages/orders/widgets/ordinePagato.dart';
import 'package:pharma_app/src/providers/acquistiRecenti_provider.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/app_config.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../repository/settings_repository.dart';
import '../cart/check.dart';

class PaypalScreen extends ConsumerStatefulWidget {
  const PaypalScreen({super.key});

  @override
  ConsumerState createState() => _PaypalScreenState();
}

class _PaypalScreenState extends ConsumerState<PaypalScreen> {
  late String _apiToken;
  late String selectedUrl;
  late String _params;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final cartProv = ref.read(cartProvider);
    final acquistiRecentiProv = ref.read(acquistiRecentiProvider);

    setState(() {
      _params = "";
      _params += "user_id=${currentUser.value.id}";
      _params += "&delivery_fee=${cartProv.delivery_fee}";
      _params += "&delivery_address_id= ${deliveryAddress.value.id}";
      _params += "&importo=${cartProv.total}";
      _params += "&sconto=${cartProv.sconto}";
    });

    _apiToken = 'api_token=${currentUser.value.apiToken}';
    selectedUrl =
        '${GlobalConfiguration().getValue('base_url')}payments/paypal/process-transaction?$_apiToken&$_params';
    print("selected url: $selectedUrl");
    // #docregion platform_features
    const params = PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('payments/paypal/success-transaction')) {
              Future.delayed(const Duration(seconds: 0), () async {
                final orders = await ref
                    .read(cartProvider)
                    .proceedOrder(context, 'PayPal');
                if (orders != null && orders.isNotEmpty) {
                  for (int i = 0; i < orders.length; i++) {
                    acquistiRecentiProv
                        .saveAcquistiRecenti(orders[i].foodOrders[i].product!);
                  }
                }
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdinePagato(),
                ),
              );

              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(selectedUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Paga con PayPal"),
        foregroundColor: Colors.blue[900],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[900]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: WebViewWidget(controller: _controller)),
            ),
            _isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
