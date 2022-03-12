import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_ui/models/breed_model.dart';
import 'package:cat_ui/models/cat_model.dart';
import 'package:cat_ui/services/cat_http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailPage extends StatefulWidget {
  static String id = "DetailPage";
  Breed breed;

  DetailPage({Key? key,required this.breed})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoadMore = false;
  bool isLoading = true;
  int selected = 0;
  String imagesPinterest = "";
  List<Cat> pinterestList = [];
  int pinterestListLength = 0;
  String searchText = "For You";

  @override
  void initState() {
    super.initState();
    _apiGetPinterest();

  }

  void _apiGetPinterest() {
    CatHttp.GET(CatHttp.API_PHOTO_LIST, CatHttp.paramEmpty())
        .then((value) => {
      pinterestList =
          List.from(CatHttp.parseCatList(value!)),
      isLoading = false,
      setState(() {}),
    });
  }

  void searchCategory(String category) {
    setState(() {
      isLoadMore = true;
    });
    CatHttp.GET(
        CatHttp.API_PHOTO_LIST,
        CatHttp.paramsSearch((pinterestList.length ~/ 10) + 1))
        .then((value) => {
      pinterestList
          .addAll(List.from(CatHttp.parseBreed(value!))),
      setState(() {
        isLoadMore = false;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Column(
              children: [

                Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 5,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      Container(),
                                  imageUrl: widget.breed.image!.url!,
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                ),
                              )),
                        ],
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            widget.breed.name!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(height: 10,),
                          ///Country
                          Row(
                            children: [
                              Icon(Icons.location_on_sharp),
                              SizedBox(width: 5,),
                              Text(widget.breed.origin!)
                            ],
                          ),
                          SizedBox(height: 10,),


                          ///Live_span
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 80,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.breed.adaptability.toString() + " years",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Age",style: TextStyle(color: Colors.grey),)
                                  ],
                                ),

                              ),
                              Container(
                                height: 80,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.breed.lifeSpan! + " years",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Life Span",style: TextStyle(color: Colors.grey),)
                                  ],
                                ),

                              ),
                              Container(
                                height: 80,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.breed.weight!.imperial + " kg",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Weight",style: TextStyle(color: Colors.grey),)
                                  ],
                                ),

                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Text("Cat Story",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 10,),
                          ///Description
                          Text(widget.breed.description!),

                          ///Wikipedia
                          Container(
                            alignment: Alignment.topRight,
                            child: MaterialButton(
                              shape: StadiumBorder(),
                              color: Colors.orange,
                              onPressed:()=> launch(widget.breed.wikipediaUrl!),
                              child: Text("Wikipedia"),
                            ),
                          ),
                        ],
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "More like this",
                            style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: MasonryGridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: pinterestList.length,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18.0),
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                               Container(),
                                            imageUrl:widget.breed.image!.url!,
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}
