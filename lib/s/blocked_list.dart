import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookezy/s/model/blocked_list_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/helper.dart';


class BlockedListUI extends StatefulWidget {
  @override
  _BlockedListUIState createState() => _BlockedListUIState();
}

class _BlockedListUIState extends State<BlockedListUI> {

  bool isError = false;
  bool isLoading = true;
  BlockedListModel blockedListModel;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Blocked List"),
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
    if(blockedListModel != null){
      return blockedListModel.blockedArray.isNotEmpty ? lView() : noCOntentAvailable();
    }else{
      return Container();
    }
  }


  Widget noCOntentAvailable() => Container(
    child: Center(child: Text("No User Blocked",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),),
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
    ApiRepository.getBlockedList().then((value) {
      setState(() {
        isLoading = false;
        isError = false;
        blockedListModel = value;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
        blockedListModel = null;
      });
    });
  }



  Widget lView() => ListView.builder(
      itemCount: blockedListModel.blockedArray.length,
      itemBuilder: (context,index){
        return itemView(blockedListModel.blockedArray[index],index);
      });


  void unblock(int id,int index){
    setState(() {
      isLoading = true;
    });
    ApiRepository.unBlockCall(id).then((value) {
      //print("${value}");
      setState(() {
        isLoading = false;
        blockedListModel.blockedArray.removeAt(index);
      });

    }).catchError((error){
      setState(() {
        isLoading = false;
      });
    });
  }


  Widget itemView(BlockedArray model,int index) => Container(
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
                return unblock(model.userId, index);
              },
              child: Container(
                height: 40,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Center(child: Text("Unblock",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),),
              ),
            )
          ],
        )
      ],
    ),
  );

}
