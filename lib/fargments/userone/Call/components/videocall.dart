import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hookezy/s/countdown_timer.dart';
import 'package:hookezy/s/model/get_user_profile_model.dart';
import 'package:hookezy/s/network.dart';
import 'package:hookezy/s/utils/app.dart';
import 'package:hookezy/s/utils/helper.dart';
import 'package:hookezy/screens/purchase_coins/components/body_purchase_coins.dart';

import '../../../../constants.dart';
import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role = ClientRole.Broadcaster;
  String accessToken;
  int coins;
  bool isVideoEnable;
  /// Creates a call page with given channel name.
  CallPage({Key key, this.channelName,this.accessToken,this.coins,this.isVideoEnable}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  Timer _timer;
  int start = 10;
  bool showTimer = true;
  GetUserProfileModel getUserProfileModel;
  String username;
  bool isError = false;
  bool isLoading = true;
  bool coindLess = false;
  int duration = 0;
  int preserveLast = 0;
  int reserved = 0;

  void fetchCoins(){
    setState(() {
      isLoading = true;
      isError = false;
    });
    SHelper.getUserId().then((value) {
      setState(() {
        username = value;
      });
      return ApiRepository.getUserProfile(int.parse(value));
    }).then((value) {
      setState(() {
        isError = false;
        isLoading = false;
        getUserProfileModel = value;
        coindLess = getUserProfileModel.coinss < widget.coins ? true : false;
      });

      if(coindLess == false)initialize();
      if(coindLess == false)startTimer();
      coindLess == true ? showDialog(context: context, barrierDismissible:false,builder: (BuildContext context) => erroDialog()) : null;
    }).catchError((error){
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _timer.cancel();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    fetchCoins();
    //initialize();

}

  void deductCoins(int coins){
    ApiRepository.deductCoins(coins,"425").then((value) {
      setState(() {
        getUserProfileModel.coinss = getUserProfileModel.coinss -  widget.coins;
        coindLess = getUserProfileModel.coinss < widget.coins;
      });
      print("65675757 ${getUserProfileModel.coinss} ${widget.coins} ${getUserProfileModel.coinss < widget.coins}");
      if(coindLess)_engine.destroy();
      coindLess == true ? showDialog(context: context, barrierDismissible:false,builder: (BuildContext context) => erroDialog()) : null;
      if(_engine != null )_engine.enableAudio();
      print("tyrtrtrt ${getUserProfileModel.coinss}");
      //deductCoins(preserveLast);
      Navigator.pop(context);
    }).catchError((error){

    });
  }

  void disableChannel(){
    _engine.enableAudio();
    _engine.disableVideo();
  }

  void startTimer() {
    int starts = 0;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
            setState(() {
              duration++;
              preserveLast = (duration / 60).truncate();
            });
            // if(preserveLast > reserved){
            //   //deductCoins(widget.coins);
            // }

      },
    );
  }

  

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel("${widget.accessToken}", widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(AppConstant.AGORA_APP_ID);
    if(!widget.isVideoEnable)await _engine.disableVideo();
    widget.isVideoEnable ? await _engine.enableVideo() : await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(formatHHMMSS(duration),style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color: Colors.green),),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: () => _onCallEnd(context),
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    //if(_engine != null )_engine.enableAudio();
    //print("tyrtrtrt ${getUserProfileModel.coinss}");
    deductCoins(preserveLast);
    //Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();

  }

  void _on30SeconsVideo(){
    _engine.enableVideo();
  }

  void runsTimer(){
    CountdownTimer(
      endTime: AppConstant.VIDEO_TIMER,
      onEnd: (){
        _on30SeconsVideo();
      },
    );
  }

  Widget runTimer() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Center(
          child: CountDownTimer(
            secondsRemaining: AppConstant.VIDEO_TIMER,
            whenTimeExpires: (){
              _on30SeconsVideo();
              setState(() {
                showTimer = false;
              });
            },
            countDownTimerStyle: TextStyle(
                color: Colors.red,
                fontSize: 17.0,
                height: 1.2
            ),
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hookezy'),
        backgroundColor: pink,
      ),
      backgroundColor: Colors.black,
      body: uiPayload(),
    );
  }

  Widget uiPayload() {
    if(isError){
      return ErrorScreen(onRefresh: (){fetchCoins();},);
    }else if(isLoading){
      return ProgressLoader(title: "Fetching Data...",);
    }else{
      return Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            //_panel(),
            videoSection(),
            Text(formatHHMMSS(duration),),
            _toolbar(),
          ],
        ),
      );
    }
  }

  Widget videoSection(){
    if(!widget.isVideoEnable){
      return showTimer == true ? runTimer() : Container();
    }else{
      return Container();
    }
  }

  Widget erroDialog() => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
    child: Container(
      height: 300.0,
      width: 300.0,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.all(15.0),
            child: Text('Looks Like you are Out of coins', style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
          ),

          Padding(padding: EdgeInsets.only(top: 30.0)),
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
              child: Text('Cancel!', style: TextStyle(color: Colors.purple, fontSize: 18.0),)),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PurchaseCoinsBody(getUserProfileModel: getUserProfileModel,)));
          },
              child: Text('Recharge!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
        ],
      ),
    ),
  );

}
