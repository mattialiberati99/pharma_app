import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pharma_app/src/repository/user_repository.dart';

import '../helpers/helper.dart';
import '../models/faq_category.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

Future<List<FaqCategory>> getFaqCategories() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}faq_categories?${_apiToken}with=faqs';

  final client = new http.Client();
  final streamedRest = await client.get(Uri.parse(url));
  final data = jsonDecode(streamedRest.body)['data'];
  return (data as List).map((data) {
    return FaqCategory.fromJSON(data);
  }).toList();
}
