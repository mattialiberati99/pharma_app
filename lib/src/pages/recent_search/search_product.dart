import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pharma_app/src/components/search_bar/filter_search_bar.dart';
import 'package:pharma_app/src/components/search_bar/home_search_bar.dart';
import 'package:pharma_app/src/components/search_bar/shop_search_bar.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../components/search_bar/pre_home_search_bar.dart';
import '../../components/search_bar/search_cat.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22)),
            child: Container(
              width: context.mqw,
              height: 237,
              color: AppColors.primary,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('Home');
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 40.0, left: 30),
                      child: Text(
                        'Cerca Prodotto',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40.0, left: 16),
                      width: 354,
                      child: SearchBarFilter(
                        route: 'Product',
                      ),
                    )
                  ]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Ricerche recenti',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Elimina',
                      style: TextStyle(color: Colors.red),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
