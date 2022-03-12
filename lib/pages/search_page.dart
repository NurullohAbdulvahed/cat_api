import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_ui/models/breed_model.dart';
import 'package:cat_ui/services/cat_http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  static const String id = "SearchPage";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Breed> breedList = [];
  String search = "";
  int pageNumber = 0;
  bool isLoadMore = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCatBreeds();
  }

  void getCatBreeds() {
    setState(() {
      isLoadMore = true;
    });
    CatHttp.GET(CatHttp.API_BREEDS_ALL, CatHttp.paramEmpty()).then((value) {
      if (value != null) {
        breedList.addAll(List<Breed>.from(CatHttp.parseBreed(value)).where(
                (element) =>
            ((element.image != null) && (element.image?.url != null))));
        print("Length : " + breedList.length.toString());
      } else {
        print("Null Response");
      }
      setState(() {
        isLoadMore = false;
      });
    });
  }

  void parsingBreed() {
    CatHttp.GET(CatHttp.API_BREED, CatHttp.paramEmpty()).then((value) => {
      breedList.addAll(List.from(CatHttp.parseBreed(value!))),
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade300),
                child: TextField(
                  controller: textEditingController,
                  onChanged: (text) {
                    setState(() {
                      search = text;
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: ("Search Cats"),
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),
          ),
        ),
        body: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoadMore &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              getCatBreeds();
              setState(() {});
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MasonryGridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: (search.isEmpty)
                        ? breedList.length
                        : breedList
                            .where((element) => element.name!
                                .toLowerCase()
                                .contains(search.toLowerCase()))
                            .toList()
                            .length,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      List temp = List.from(breedList.where((element) => element
                          .name!
                          .toLowerCase()
                          .contains(search.toLowerCase()))).toList();

                      return buildColumn(temp[index]);
                    },
                  ),
                ),
                isLoadMore ? Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Lottie.asset("assets/load.json",width: 30,height: 30),
                  ),
                ) : SizedBox.shrink()
              ],
            ),
          ),
        ));
  }

  Column buildColumn(Breed breed) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: CachedNetworkImage(
                placeholder: (context, url) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: breed.image!.width!.toDouble() / breed.image!.height!.toDouble(),
                      child: Container(
                        color: Colors.grey.shade300,
                      ),
                    )
                ),
                imageUrl: breed.image!.url!,
                errorWidget: (context, url, error) => Container(),
              )),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailPage(breed: breed,)));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Text(breed.name!)
      ],
    );
  }
}
