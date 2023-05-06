// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// class SliderShowFullmages extends StatefulWidget {
//   final List listImagesModel;
//   final int current;
//
//   const SliderShowFullmages({Key? key, required this.listImagesModel, required this.current}) : super(key: key);
//
//   @override
//   _SliderShowFullmagesState createState() => _SliderShowFullmagesState();
// }
//
// class _SliderShowFullmagesState extends State<SliderShowFullmages> {
//   int _current = 0;
//   bool _stateChange = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _current = (_stateChange == false) ? widget.current : _current;
//     return new Container(
//         color: Colors.transparent,
//         child: new Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               //title: const Text('Transaction Detail'),
//             ),
//             body: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   CarouselSlider(
//                     options: CarouselOptions(
//                       autoPlay: false,
//                       height: MediaQuery.of(context).size.height / 1.3,
//                       viewportFraction: 1.0,
//                       onPageChanged: (index, data) {
//                         setState(() {
//                           _stateChange = true;
//                           _current = index;
//                         });
//                       },
//                       initialPage: widget.current,
//                       enableInfiniteScroll: false,
//                     ),
//                     items: map<Widget>(widget.listImagesModel, (index, url) {
//                       return PhotoView(
//                         imageProvider: NetworkImage(url),
//                         minScale: 0.3,
//                         maxScale: 3.0,
//                       );
//                     }),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: map<Widget>(widget.listImagesModel, (index, url) {
//                       return Container(
//                         width: 10.0,
//                         height: 9.0,
//                         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: (_current == index) ? Colors.redAccent : Colors.grey,
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             )));
//   }
// }
