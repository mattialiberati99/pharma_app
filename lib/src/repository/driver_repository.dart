import 'dart:convert';
import 'dart:io';

import 'package:pharma_app/src/models/shipping.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../helpers/helper.dart';
import '../models/media.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../models/driver.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../providers/user_provider.dart';
import 'package:dio/dio.dart' as dio;

/// Loads the driver from api using the token
Future<Driver?> load(User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}drivers/${user.id}?api_token=${user.apiToken}';
  final client = http.Client();
  final response = await client.get(
    Uri.parse(url),
  );
  logger.info('loadDriver: $url');
  if (response.statusCode == 200) {
    return Driver.fromJSON(json.decode(response.body)['data']);
  } else {
    logger.error(
        CustomTrace(StackTrace.current, message: response.body).toString());
    throw Exception(response.body);
  }
}

Future<Driver?> create(Driver driver) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  String api_url = GlobalConfiguration().getValue('api_base_url');
  final String url = '${api_url}drivers?$_apiToken';
  final client = http.Client();

  logger.info(url);
  logger.info(json.encode(driver.toMap()));
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(driver.toMap()),
  );

  currentDriver.value = Driver.fromJSON(json.decode(response.body)['data']);

  return currentDriver.value;
}

Future<Driver?> update(Driver driver) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  String api_url = GlobalConfiguration().getValue('api_base_url');
  final String url = '${api_url}set_data/${currentDriver.value!.id}?$_apiToken';
  final client = http.Client();

  logger.info(url);
  logger.info(json.encode(driver.toMap()));
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(driver.toMap()),
  );

  currentDriver.value = Driver.fromJSON(json.decode(response.body)['data']);

  return currentDriver.value;
}

Future<int> getDriverCount() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return 0;
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}drivers/count?';
  Map<String, dynamic> _queryParams = {};
  _queryParams['api_token'] = '${_user.apiToken}';

  Uri uri = Uri.parse(url);
  uri = uri.replace(queryParameters: _queryParams);
  logger.info(uri);
  final client = http.Client();
  final streamedRest = await client.get(uri);
  final data = jsonDecode(streamedRest.body)['data'];
  return data as int;
}

// Future<List<DriverPayout>> listDriverPayouts() async{
//   final String _apiToken = 'api_token=${currentUser.value.apiToken}';
//   final String url = '${GlobalConfiguration().getValue('api_base_url')}payouts/${currentUser.value.id}?$_apiToken';
//   final client = new http.Client();
//   try{
//     final response = await client.get(
//       url,
//     );
//     print(url);
//     final responseJson = json.decode(response.body);
//     return (responseJson["data"] as List)
//         .map((p) => DriverPayout.fromJSON(p))
//         .toList();
//   } catch (e) {
//     print(e);
//     return [new DriverPayout.fromJSON({})];
//   }
// }

Future<void> logout() async {
  currentDriver.value = Driver.fromJSON({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('driver_token');
}

Future<Media?> addIDImage(String path) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}drivers/image?api_token=${currentUser.value.apiToken}';

  var uri = Uri.parse(url);
  var dioRequest = dio.Dio();
  // create multipart request
  dio.FormData formData = dio.FormData.fromMap({
    "driver_id": currentDriver.value!.id,
    "file":
        await dio.MultipartFile.fromFile(path, filename: path.split('/').last)
  });
  logger.info(uri);
  var response = await dioRequest.post(url, data: formData);
  // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
  logger.info(response.statusCode);
  logger.info(response.data.toString());
  if (response.statusCode == 200) {
    return Media.fromJson(response.data['data']);
  } else {
    return null;
  }
}

Future<void> removeIDImage(Media media) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}drivers/image/${media.id}?$_apiToken';
  final client = http.Client();
  try {
    await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return;
  } catch (e) {
    logger.error(CustomTrace(StackTrace.current, message: url));
    return;
  }
}

/// get driver reviews, added &with=user to get user object for image
Future<Stream<Review>> getDriverReviews(String id) async {
  final String url =
      '${GlobalConfiguration().getValue('base_url')}api/driver_reviews?orderBy=updated_at&sortedBy=desc&search=driver_id:$id&with=user';
  try {
    final client = http.Client();
    logger.info('getDriverReviews: $url');
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    logger.error(CustomTrace(StackTrace.current, message: url).toString());
    return Stream.value(Review.fromJSON({}));
  }
}

Future<Review?> addDriverReview(
    Review review, int driverId, int shippingId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}driver_reviews?api_token=${currentUser.value.apiToken}';

  var uri = Uri.parse(url);
  var dioRequest = dio.Dio();
  var uuid = const Uuid();

  // create multipart request
  var request = http.MultipartRequest("POST", uri);
  logger.info('addReviewUri: $uri');
  dio.FormData formData;
  if (review.imagePath == null) {
    formData = dio.FormData.fromMap({
      "driver_id": driverId,
      "username": currentUser.value.name,
      "order_id": shippingId,
      "review": review.review,
      "rate": review.rate,
      "user_id": currentUser.value.id,
    });
  } else {
    formData = dio.FormData.fromMap({
      "driver_id": driverId,
      "username": review.username,
      "order_id": shippingId,
      "review": review.review,
      "rate": review.rate,
      "uuid": uuid.v4(),
      "field": "image",
      "file": await dio.MultipartFile.fromFile(review.imagePath!,
          filename: review.imagePath!.split('/').last),
      "user_id": currentUser.value.id,
    });
  }

  var response = await dioRequest.post(url, data: formData);
  // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
  logger.info('addDriverReview Status Code: ${response.statusCode}');
  if (response.statusCode == 200) {
    return Review.fromJSON(response.data["data"]);
  } else {
    return null;
  }
}
