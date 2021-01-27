import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:norway_app/models/distanceModel.dart';
import 'package:progress_hud/progress_hud.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Support support;
  ProgressHUD progressHUD;
  @override
  Widget build(BuildContext context) {
    if (support == null) {
      support = Support(this.context, updateState, showProgressDialog);
      progressHUD = new ProgressHUD(
        backgroundColor: Colors.black12,
        color: Colors.blueAccent,
        containerColor: Colors.transparent,
        borderRadius: 5.0,
        text: '',
        loading: true,
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              support.statusBarContainer(),
              support.actionBarContainer(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    support.bodyContainer()
                  ],
                ),
              ),
              support.safeAreaContainer()
            ],
          ),
          progressHUD
        ],
      ),
    );
  }
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void showProgressDialog(bool value) {
    setState(() {
      if (value) {
        progressHUD.state.show();
      } else {
        progressHUD.state.dismiss();
      }
    });
  }
}

class Support{

  BuildContext context;
  Function updateState, showProgressDialog;
  Support(this.context, this.updateState, showProgressDialog){
    Timer(Duration(milliseconds: 1000), (){
      showProgressDialog(false);
    });
    createList();
  }

  Widget statusBarContainer(){
    return Container(
      height: MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueAccent,
    );
  }

  Widget safeAreaContainer(){
    return Container(
      height: MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueAccent,
    );
  }

  Widget actionBarContainer(){
    return Container(
      alignment: Alignment.center,
      height: 55,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueAccent,
      child: Text(
        'TASK',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
        ),
      ),
    );
  }

  List<ModelDistance> distanceList = [];
  List<ModelDistance> distanceList2;
  GoogleMapController googleMapController;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Widget bodyContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Unsorted List'),
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemBuilder: list2,
                    itemCount: distanceList2.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                ],
              ),
            ),
              Expanded(
                child: Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sorted List'),
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemBuilder: list,
                      itemCount: distanceList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  ],
                ),
              ),)

          ],),
          SizedBox(height: 100),
          mapContainer()
        ],
      ),
    );
  }

  void createList(){
      distanceList.add(ModelDistance('A', 'B', 12));
      distanceList.add(ModelDistance('A', 'C', 18));
      distanceList.add(ModelDistance('A', 'D', 8));
      distanceList.add(ModelDistance('A', 'E', 24));
      distanceList.add(ModelDistance('Z', 'X', 5));
      distanceList.add(ModelDistance('Z', 'Y', 15));
      distanceList2 = [...distanceList];

      var map2 = Map.fromIterable(distanceList, value: (e) => e.distance);
      print(map2);
      distanceList.sort((a, b) => (b.distance).compareTo(a.distance));


      var map1 = Map.fromIterable(distanceList, value: (e) => e.distance);
      print(map1);


  }

  Widget list(BuildContext context, int index){
    return Container(
      margin: EdgeInsets.all(5),
      child: Text(
        distanceList[index].distance.toString(),
        style: TextStyle(
          fontSize: 15
        ),
      ),
    );
  }

  Widget list2(BuildContext context, int index){
    return Container(
      margin: EdgeInsets.all(5),
      child: Text(
        distanceList2[index].distance.toString(),
        style: TextStyle(
          fontSize: 15
        ),
      ),
    );
  }

  Widget mapContainer() {
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

