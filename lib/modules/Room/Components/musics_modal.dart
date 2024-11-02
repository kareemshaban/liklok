import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:audio_duration/audio_duration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/styles/colors.dart';
import 'music2_modal.dart';

class MusicsModal extends StatefulWidget {
  const MusicsModal({super.key});

  @override
  State<MusicsModal> createState() => _MusicsModalState();
}

class _MusicsModalState extends State<MusicsModal> {
  List<FileSystemEntity> musicFiles = [];
  List<String> musicFilesLength = [];

  late RtcEngine _engine;
  bool _isStartedAudioMixing = false;
  bool _loopback = false;
  bool _replace = false;
  double _cycle = 1.0;
  double _startPos = 1000;
  int playedIndex = -1;
  double progress = 1000 ;
  double min = 1000 ;
  double max = 1000 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    setState(() {
      if(mounted){
        _engine = ChatRoomService.engine!;
      }
    });
    getProgress();
    getData();
    _engine.registerEventHandler(
        RtcEngineEventHandler(
            onAudioMixingFinished: () {
              print('onAudioMixingFinished');
              print(min);
              print(max);
              if (this.mounted) {
                setState(() {
                  progress = 1000 ;

                  _isStartedAudioMixing = false;

                });
              }

            },
            onAudioMixingPositionChanged: (val) {
              if (this.mounted) {
                setState(() {
                  progress = double.parse(val.toString()) ;
                });
              }

            },
            onAudioMixingStateChanged: (AudioMixingStateType stateType , AudioMixingReasonType reasonType){

          }
        )
    );
  }
  requestPermissions() async{
    // Request permission to access the device's storage
    var status = await Permission.storage.request();
    var status2 =  await  Permission.manageExternalStorage.request();
    var status3 = await Permission.audio.request();
    if (status.isGranted || status2.isGranted || status3.isGranted) {
      // Permission granted, you can now proceed with file access

    } else {
      Fluttertoast.showToast(
          msg: 'music_error_permissions'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0);
           Navigator.pop(context);
      // Permission denied
      // Handle the situation where the user denied permission
    }

  }
  getProgress() async {
    int mm = await _engine.getAudioMixingCurrentPosition()  ;
    int mx = await _engine.getAudioMixingDuration()  ;

    setState(() {
      if(mounted){
        progress = mm > 0 ?  double.parse(mm.toString()) : 1000;
        max = mx > 0 ? double.parse(mx.toString()) : 1000;
        _isStartedAudioMixing =  mm > 0 ;
        playedIndex = mm > 0 ? ChatRoomService.musicPlayedIndex : -1 ;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //_engine.stopAudioMixing();
  }

  getData() async {

    Directory? appDocDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> allFiles;
    List<FileSystemEntity> files;
    List<String> lengths = [];
    allFiles = appDocDir.listSync(recursive: true, followLinks: false);
    files = [...allFiles.where((element) => FileManager.isFile(element))];
    List<FileSystemEntity> MF = [];
    MF = [
      ...files.where((file) =>
          file.path.toLowerCase().endsWith('.mp3') ||
          file.path.toLowerCase().endsWith('.m4a'))
    ];
    

    
    
    if (this.mounted){
      setState(() {
        musicFiles = MF;
      });

    }

  }

  Future<void> _startAudioMixing(p, index) async {
    await _engine.startAudioMixing(
      filePath: p,
      loopback: _loopback,
      cycle: _cycle.toInt(),
      startPos: _startPos.toInt(),
    );

    int mm = await _engine.getAudioMixingDuration() ;
    if (this.mounted){
      setState(() {
        _isStartedAudioMixing = true;
        playedIndex = index;
        ChatRoomService.musicPlayedIndex = index ;
        max = mm > 0 ? double.parse(mm.toString()) : 10000;
      });
      await Future.delayed(Duration(seconds: 2)) ;
       mm = await _engine.getAudioMixingDuration() ;
      max = mm > 0 ? double.parse(mm.toString()) : 10000;

    }



  }

  Future<void> _stopAudioMixing() async {
    await _engine.stopAudioMixing();
    if (this.mounted) {
      setState(() {
        _isStartedAudioMixing = false;
      });
    }
  }

  Future<void> _pauseAudioMixing() async {
    await _engine.pauseAudioMixing();
    if (this.mounted) {
      setState(() {
        _isStartedAudioMixing = false;


      });
    }
  }

  Future<void> _resumeAudioMixing() async {
    await _engine.resumeAudioMixing();
    if (this.mounted) {
      setState(() {
        _isStartedAudioMixing = true;
      });
    }

  }


  Future<void> _nextAudioMixing() async {
    await _engine.stopAudioMixing();
    if (this.mounted) {
      setState(() {
        _isStartedAudioMixing = false;
      });
    }


    if (musicFiles.length > playedIndex + 1) {
      print('_startAudioMixing');
      _startAudioMixing(musicFiles[playedIndex + 1].path, playedIndex + 1);
    }
  }

  Future<void> _prevAudioMixing() async {
    await _engine.stopAudioMixing();
    if (this.mounted) {
      setState(() {
        _isStartedAudioMixing = false;
      });
    }

    if (playedIndex - 1 >= 0) {
      print('_startAudioMixing');
      _startAudioMixing(musicFiles[playedIndex - 1].path, playedIndex - 1);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(15.0)),
          border: Border(
            top: BorderSide(width: 4.0, color: MyColors.secondaryColor),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'musics_model_my_music'.tr,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) => Music2BottomSheet());
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ))
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: musicFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if(playedIndex == index){
                      if(_isStartedAudioMixing){
                        _pauseAudioMixing();
                      } else {
                        _resumeAudioMixing();
                      }

                    } else {
                      _startAudioMixing(musicFiles[index].path, index);
                    }

                  },
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    height: 80.0,
                    padding: EdgeInsetsDirectional.only(start: 10.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.only(end: 10.0),
                              height: 50.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image(
                                image: AssetImage('assets/images/mp3.png'),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 200.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      FileManager.basename(musicFiles[index]),
                                      style: TextStyle(
                                          color: index == playedIndex
                                              ? MyColors.primaryColor
                                              : Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                   Icons.save_outlined,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 5.0, end: 5.0),
                                  child: Text(getLength(musicFiles[index].path)
                                    ,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black),
                                  ),
                                ),
                                Container(
                                  color: Colors.black,
                                  width: 1,
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 5.0, end: 5.0),
                                  child: Icon(
                                    CupertinoIcons.time,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  getDate(musicFiles[index].path),
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                )
                              ],
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        Expanded(child: IconButton(icon: Icon(Icons.delete_forever_sharp , color: Colors.red,), onPressed: () {
                            File(musicFiles[index].path).deleteSync();
                            _stopAudioMixing();
                            setState(() {
                              _isStartedAudioMixing = false;
                              playedIndex = -1 ;
                            });
                            getData();
                        }, ))
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black.withAlpha(50),
              ),
            ),
          ),
          Container(
            height: 100.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(100),
              border: Border(
                top: BorderSide(
                    width: 2.0, color: MyColors.lightUnSelectedColor),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _stopAudioMixing();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.power_settings_new_outlined,
                              size: 30.0,
                            ),
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _prevAudioMixing();
                            },
                            icon: Icon(
                              Icons.skip_previous,
                              size: 30.0,
                            ),
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _isStartedAudioMixing
                              ? IconButton(
                                  onPressed: () {
                                    _pauseAudioMixing();
                                  },
                                  icon: Icon(
                                    Icons.pause,
                                    size: 30.0,
                                  ),
                                  color: Colors.black,
                                )
                              : IconButton(
                                  onPressed: () {
                                    _resumeAudioMixing();
                                  },
                                  icon: Icon(
                                    Icons.play_arrow,
                                    size: 30.0,
                                  ),
                                  color: Colors.black,
                                )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _nextAudioMixing();
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 30.0,
                            ),
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {

                            },
                            icon: Icon(
                              Icons.volume_down,
                              size: 30.0,
                            ),
                            color: Colors.black,
                          ),
                            PopupMenuButton(
                            position: PopupMenuPosition.over,
                            shadowColor: MyColors.unSelectedColor,
                            elevation: 4.0,

                            color: MyColors.darkColor,
                            icon: Container(),
                            onSelected: (int result) async {

                               await _engine.adjustAudioMixingPlayoutVolume(result);
                               await _engine.adjustAudioMixingPublishVolume(result);
                            },
                            itemBuilder: (BuildContext context) => volumeBuilder()
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          // Text(progress.toString() , style: TextStyle(color: MyColors.primaryColor),),
                          Slider(value:  progress , min: min , max: max, onChanged:  (val) async{
                            await _engine.setAudioMixingPosition( (val - 1000).toInt() );
                            setState(() {
                                 progress = val ;

                            });
                          } , thumbColor: MyColors.secondaryColor, activeColor: MyColors.secondaryColor,)
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget Music2BottomSheet() => MusicsModal2();

getDate(file) {
   return File(file).lastModifiedSync().toString();

}
getLength(file) {
  int bytes =  File(file).lengthSync();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i];

}

List<PopupMenuEntry<int>> volumeBuilder() {
  return
    [
      PopupMenuItem<int>(
        value: 100,
        child: Text('100%' , style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 70,
        child: Text('70%' , style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 50,
        child: Text('50%', style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 30,
        child: Text('30%', style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 20,
        child: Text('20%', style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 10,
        child: Text('10%', style: TextStyle(color: Colors.black),),
      ),
      PopupMenuItem<int>(
        value: 0,
        child: Text('0%', style: TextStyle(color: Colors.black),),
      ),
    ];



}
