import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool haveNoImage = true;
  File image;
  String text = "Getting Result";
  final imagepicker = ImagePicker();

  Future<Map<String, dynamic>> fetchResponse(File image) async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://max-image-caption-generator-test.2886795288-80-host02nc.environments.katacoda.com/model/predict"));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic> responseData = json.decode(response.body);
      parseResponse(responseData);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  parseResponse(var response) {
    //collectiing results and passing to text widget
    String result = "";
    var predections = response["predictions"];
    for (var i in predections) {
      var caption = i["caption"];
      var probability = i["probability"];
          result = result + '${caption}: ${probability}\n\n';
    }

    setState(() {
      text = result;
    });
  }

  pickImage() async {
    var pickedImage = await imagepicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
        haveNoImage = false;
      });
      var res = fetchResponse(image);
    }
  }

  captureImage() async {
    var pickedImage = await imagepicker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
        haveNoImage = false;
      });
      var res = fetchResponse(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: haveNoImage
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Container(
                            width: 250,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                            ),
                          ),
                          Text("Image Caption Generator", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           Text("Pick An Image or Chose from Gallery", style: TextStyle(fontSize: 14),),

                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: .5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_front_outlined),
                                        Text(
                                          "Live Camera",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: .5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Icon(Icons
                                            .photo_size_select_actual_outlined),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    captureImage();
                                  },
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: .5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_alt_outlined),
                                        Text(
                                          "Camera",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            height: 300,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        setState(() {
                                          text = "Getting Result ... ";
                                          haveNoImage = true;
                                        });
                                      }),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(image, fit: BoxFit.fill),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
