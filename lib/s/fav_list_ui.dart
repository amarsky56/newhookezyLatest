import 'package:flutter/material.dart';
import 'package:hookezy/fargments/usertwo/view_user/components/body_viewuser.dart';
import 'package:hookezy/s/model/fav_list_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';


class FavList extends StatefulWidget {
  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  bool isError = false;
  bool isLoading = true;
  FavListModel favListModel;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text("Favourite List"),
        ),
        body: uiPayload()
    );

  }


  Widget uiPayload() {
    if(isError){
      return ErrorScreen(onRefresh: (){return  fetchList();},);
    }else {
      return Stack(
        children: [
          l(),
          isLoading == true ? ProgressLoader(title: "PLease wait...",) : Container()
        ],
      );
    }
  }

  Widget l(){
    if(favListModel != null){
      return favListModel.categories.isNotEmpty ? lView() : noCOntentAvailable();
    }else{
      return Container();
    }
  }


  Widget noCOntentAvailable() => Container(
    child: Center(child: Text("No Data Available",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),),
  );

  @override
  void initState() {
    // TODO: implement initState
    fetchList();
    super.initState();
  }


  void fetchList(){
    setState(() {
      isLoading = true;
      isError = false;
    });
    ApiRepository.getFav().then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        favListModel = value;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
        favListModel = null;
      });
    });
  }

  void unblock(int id,int index){
    setState(() {
      isLoading = true;
    });
    ApiRepository.addToFav(id).then((value) {
      //print("${value}");
      setState(() {
        isLoading = false;
        favListModel.categories.removeAt(index);
      });

    }).catchError((error){
      setState(() {
        isLoading = false;
      });
    });
  }



  Widget lView() => ListView.builder(
      itemCount: favListModel.categories.length,
      itemBuilder: (context,index){
        return itemView(favListModel.categories[index],index);
      });




  Widget itemView(Category model,int index) => GestureDetector(
    onTap: (){
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>ViewUserBody(id: model.id,)));
    },
    child: Container(
      margin: EdgeInsets.all(10.0),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SNetWorkImage(
                height: 80,
                width: 80,
                url: model.image,
              ),
              SizedBox(width: 10.0,),
              Text(model.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  return unblock(model.id, index);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Center(child: Text("Remove",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
