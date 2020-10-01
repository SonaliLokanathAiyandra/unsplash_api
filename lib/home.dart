import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'file:///D:/FlutterProgramming/imagedisplayer/lib/widget/custom.dart';
import 'file:///D:/FlutterProgramming/imagedisplayer/lib/widget/tabButton.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {
  List data;
  int _selectedPage = 0;
  PageController _pageController;


  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  void initState() {
    this.getjsondata();
    _pageController = PageController();
    super.initState();
  }

  ///unsplash api
  Future<String> getjsondata() async {
    var response = await http.get('https://api.unsplash.com/search/photos?per_page=80&client_id=FyCPbQz6UTyaSC1ZAfsETiyUnSNgl2VCfTOlG_smvuo&query=nature');
      var jsondata = json.decode(response.body);
      setState(() {
        data = jsondata['results'];

      });
      return 'success';
    }

    ///loading image from gallery
  Future<File> imageFile;
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.cyan[100],
          appBar: AppBar(
            backgroundColor: Colors.black,

            title: Center(child: Text('UNSPLASH API')),
          ),
            body:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
              padding: EdgeInsets.fromLTRB(0.0,5.0,0.0,5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: "API",
                    pageNumber: 0,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(0);
                    },
                  ),
                  TabButton(
                    text:'LOCAL',
                    pageNumber: 1,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(1);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
              onPageChanged: (int page) {
               setState(() {
            _selectedPage = page;
          });
        },
    controller: _pageController,
     children: [
       Container(
            child:
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: data == null ? 0:data.length ,
                itemBuilder: (BuildContext context, int index) {
              return Stack(
                    children: <Widget>[
                         Container(
                          height: 800,
                            decoration: BoxDecoration
                              (borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                              child:
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,20,10.0,20.0),
                                child: Image.network(
                                  data[index]['urls']['small'],
                                  fit:BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
              ),
              ],
              );
            }
            ),
          ),
       Container(
         child: Center(
         child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
         showImage(),
    RaisedButton(
    child: Text("Select Image from Gallery"),
    onPressed: () {
    pickImageFromGallery(ImageSource.gallery);
    },
    ),
    ],
    ),
    ),
       )
    ],
    ),
    ),
          ],
        ),
    ),

    );
  }
}