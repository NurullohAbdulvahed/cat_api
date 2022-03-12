import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_ui/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

import '../models/breed_model.dart';
import '../models/cat_model.dart';
import '../services/cat_http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  int pageNumber = 0;
  bool isLoadMore = false;
  List<Cat> catList = [];
  List<Breed> breedList = [];
  String data = "";
  String searchText = "";
  final ScrollController _scrollController = ScrollController();

  List catCategoryName = [
    "Russian",
    "Persian",
    "Spain",
    "Uzb",
    "American",
    "Russian",
    "Persian",
    "Spain",
    "Uzb",
    "American",
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void searchCategory() {
    setState(() {
      isLoadMore = true;
      pageNumber += 1;
    });
    CatHttp.GET(CatHttp.API_PHOTO_LIST, CatHttp.paramsSearch((pageNumber)))
        .then((value) => {
              print(value),
              catList.addAll(List.from(CatHttp.parseCatList(value!))),
              setState(() {
                isLoadMore = false;
                isLoading = false;
              }),
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            searchCategory();
            setState(() {});
          }
          return true;
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : SingleChildScrollView(
              child: Stack(
          children: [
              // isLoading
              //     ? Center(
              //         child: CircularProgressIndicator.adaptive(
              //           valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              //         ),
              //       )
              //     :
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MasonryGridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: catList.length,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(),
                                    imageUrl: catList[index].url!,
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  )),
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            isLoadMore
                ? Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Lottie.asset("assets/load.json",
                        width: 30, height: 30),
                  ),
                )
                : SizedBox.shrink()
          ],
        ),
            ),
      ),
    );
  }

// Container buildStory(int index) {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 10),
//     child: Column(
//       children: [
//         ///images
//         Container(
//           height: 80,
//           width: 80,
//           child: GestureDetector(
//             child: Container(
//               margin: const EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: (breedList[index].image == null &&
//                           breedList[index].image?.url == null)
//                       ? NetworkImage(breedList[index].image!.url!)
//                       : NetworkImage(catList[index].url!),
//                 ),
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.purple, width: 2),
//               borderRadius: BorderRadius.circular(30)),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//
//         ///text
//         Text(
//           breedList[index].name!,
//           style: TextStyle(color: Colors.grey),
//         )
//       ],
//     ),
//   );
// }
}
