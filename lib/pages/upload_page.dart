import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_ui/models/cat_model.dart';
import 'package:cat_ui/services/cat_http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../models/uploads.dart';

class Upload_Page extends StatefulWidget {
  const Upload_Page({Key? key}) : super(key: key);

  @override
  State<Upload_Page> createState() => _Upload_PageState();
}

class _Upload_PageState extends State<Upload_Page> {
  List<Uploads> uploads = [];
  File? imageFile;
  bool isLoadMore = false;
  bool isLoading =true;
  ImagePicker picker = ImagePicker();
  var image;
  bool isUploading = false;
  bool isLoadingUploads = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetUploads();
  }

  ///simple ALert Dialog
  Future _asyncSimpleDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Picker'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
            getMyImage(ImageSource.gallery).then((value){
              _apiUploadImage(value);
              setState(() {
                isLoadMore = true;
              });
            });
            Navigator.of(context).pop();
          },
                child: const Text('Gallery'),
              ),
              SizedBox(
                height: 10,
              ),
              SimpleDialogOption(
                onPressed: () {
          getMyImage(ImageSource.camera).then((value){
            _apiUploadImage(value);
          });
          Navigator.of(context).pop();
          },
                child: const Text('Camera'),
              ),
            ],
          );
        });
  }


  void _apiGetUploads() async {
    await CatHttp.GET(CatHttp.API_GET_UPLOADS, CatHttp.paramsPage(0))
        .then((value) => {
              setState(() {
                uploads = uploadsFromJson(value!);
                imageFile = null;
                isLoadMore =false;
              }),
            });
  }

  void deletePost(String id,int index){
    CatHttp.DELETE(CatHttp.API_GET_UPLOADS+id,CatHttp.paramEmpty()).then((value){
      setState(() {
        uploads.removeAt(index);
      });
    });
  }



  void _apiUploadImage(File file) async {
    setState(() {
      isUploading = true;
    });
    await CatHttp.MULTIPART(
            CatHttp.API_UPLOAD, file.path, CatHttp.bodyUpload())
        .then((response) => {
          print(response),
              showResponse(response),
            });
  }

  void showResponse(String? response) {
    setState(() {
      if (response != null) {
        _apiGetUploads();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploading Images'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                _asyncSimpleDialog(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() {});
          }
          return true;
        },
        child : SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MasonryGridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: uploads.length,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(),
                                          imageUrl: uploads[index].url,
                                          errorWidget: (context, url, error) =>
                                              Container(),
                                        )),
                                    onTap: () {},
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      PopupMenuButton(
                                          itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                                child: Text("Save")
                                            ),
                                            PopupMenuItem(
                                              child: Text("Delete"),
                                              onTap: (){
                                               deletePost(uploads[index].id, index);
                                               print("O`chdi");
                                              },
                                            ),
                                          ],
                                        icon: Icon(Icons.more_horiz),
                                      )
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        isLoadMore
                            ? Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Lottie.asset("assets/load.json",
                                width: 30, height: 30),
                          ),
                        )
                            : SizedBox.shrink(),
                      ],
                    ),

                  ],
                ),
              ),
      ),
    );
  }

  Future getMyImage(ImageSource source) async {
    File? file;

    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
        file = File(pickedImage.path);
      }
    });
  return file;
  }

}
