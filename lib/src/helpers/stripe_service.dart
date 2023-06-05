import 'package:http/http.dart' as http;

class StripeService {
  String secretKet = "";
  String publishableKey =
      "pk_test_51NDs6qFvHRNXODVcSwP6uFRE7hdajXcCwVzwN70aExyxYbviPmjfVgWDGbCedtCg7iGgj3Rsg3RTyNmeNOh5Kd2R00yk3IZGzY";

  static Future<dynamic> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    String lineItems = "";
    int index = 0;

    productItems.forEach(
      (val) {
        var productPrice = (val["productPrice"] * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name]=${val['productName']}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$productPrice";
        lineItems +=
            "&line_items[$index][price_data][product_data][currency]=EUR";
        lineItems += "&line_items[$index][qty]=${val['qty'].toString()}";

        index++;
      },
    );
  }
}
