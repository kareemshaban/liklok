import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../helpers/zego_handler/internal/internal.dart';
import '../../../shared/styles/colors.dart';
import 'music2_modal.dart';

class MusicsModal extends StatefulWidget {
  final ZegoExpressEngine zegoEngine;
  final ZegoMediaPlayer audioPlayer;

  const MusicsModal({
    super.key,
    required this.zegoEngine,
    required this.audioPlayer,
  });

  @override
  State<MusicsModal> createState() => _MusicsModalState();
}

class _MusicsModalState extends State<MusicsModal> {
  List<FileSystemEntity> musicFiles = [];
  List<String> musicFilesLength = [];

  late RtcEngine _engine;
  bool _isStartedAudioMixing = false;

  // bool _loopback = true;
  // bool _replace = false;
  // int  _cycle = 1;
  // double _startPos = 1000;
  int playedIndex = -1;
  Timer? positionTimer;
  double progress = 0.0;
  double max = 0.0;
  double min = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.audioPlayer.getTotalDuration().then((duration) {
      setState(() {
        max = duration.toDouble();
      });
    });
    positionTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      final currentPos = await widget.audioPlayer.getCurrentProgress();
      if(mounted){
        setState(() {
          progress = currentPos.toDouble();
        });
      }
    });

    requestPermissions();
    getData();
  }

  Future<void> requestPermissions() async {
    if (!Platform.isAndroid) {
      print('Not running on Android');
      return;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    PermissionStatus? audioStatus;
    PermissionStatus? mediaAudioStatus;

    if (sdkInt >= 33) {
      mediaAudioStatus = await Permission.audio.request();
    } else if (sdkInt >= 30) {
      audioStatus = await Permission.audio.request();
    } else {
      audioStatus = await Permission.audio.request();
    }

    final granted = [
      audioStatus?.isGranted,
      mediaAudioStatus?.isGranted,
    ].where((x) => x == true).isNotEmpty;

    if (granted) {
      print('Permissions granted ✅');
    } else {
      print('Some permissions denied ❌');

      if (await Permission.audio.isPermanentlyDenied) {
        print("User permanently denied permission. Opening app settings...");
        openAppSettings();
      }
    }
  }

  Future<void> getProgress() async {
    final current = await widget.audioPlayer.getCurrentProgress();
    final total = await widget.audioPlayer.getTotalDuration();

    if (!mounted) return;

    if (current <= 0) return;

    setState(() {
      progress = current.toDouble().clamp(0, total.toDouble());
      max = total.toDouble();
      min = 0;
      _isStartedAudioMixing = true;
    });
  }

  @override
  @override
  void dispose() {
    positionTimer?.cancel();
    super.dispose();
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
      ...files.where(
        (file) =>
            file.path.toLowerCase().endsWith('.mp3') ||
            file.path.toLowerCase().endsWith('.m4a'),
      ),
    ];

    if (this.mounted) {
      setState(() {
        musicFiles = MF;
      });
    }
  }

  Future<void> startAudioMixing(String path, int index) async {
    try {
      await widget.audioPlayer.stop();

      await widget.audioPlayer.loadResource(path);

      widget.audioPlayer.enableAux(true);

      widget.audioPlayer.setVolume(100);

      await widget.audioPlayer.start();

      print("🎶 BGM started for all users: $path");

      setState(() {
        _isStartedAudioMixing = true;
        playedIndex = index;
      });
      getProgress();
    } catch (e) {
      print("⚠️ Error starting BGM: $e");
    }
  }

  Future<void> stopAudioMixing() async {
    await widget.audioPlayer.stop();

    if (mounted) {
      setState(() {
        _isStartedAudioMixing = false;
      });
    }

    print("⏹️ BGM stopped for all users");
  }

  Future<void> pauseAudioMixing() async {
    await widget.audioPlayer.pause();

    if (mounted) {
      setState(() {
        _isStartedAudioMixing = false;
      });
    }

    print("⏸️ BGM paused");
  }

  Future<void> resumeAudioMixing() async {
    await widget.audioPlayer.resume();

    if (mounted) {
      setState(() {
        _isStartedAudioMixing = true;
      });
    }

    print("▶️ BGM resumed");
  }

  Future<void> nextAudioMixing() async {
    if (musicFiles.isEmpty) return;

    await stopAudioMixing();

    if (playedIndex + 1 < musicFiles.length) {
      await startAudioMixing(musicFiles[playedIndex + 1].path, playedIndex + 1);
    } else {
      print("🚫 No next track");
    }
  }

  Future<void> prevAudioMixing() async {
    if (musicFiles.isEmpty) return;

    await stopAudioMixing();

    if (playedIndex - 1 >= 0) {
      await startAudioMixing(musicFiles[playedIndex - 1].path, playedIndex - 1);
    } else {
      print("🚫 No previous track");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * .7,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(15.0),
          ),
          border: Border(
            top: BorderSide(width: 4.0, color: MyColors.secondaryColor),
          ),
        ),
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
                      builder: (ctx) => Music2BottomSheet(),
                    );
                  },
                  icon: Icon(Icons.add_circle_outline, color: Colors.black),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: musicFiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if (playedIndex == index) {
                        if (_isStartedAudioMixing) {
                          await pauseAudioMixing();
                        } else {
                          await resumeAudioMixing();
                        }
                      } else {
                        if (_isStartedAudioMixing) {
                          await stopAudioMixing();
                        }
                        await startAudioMixing(musicFiles[index].path, index);
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
                                              : Colors.black,
                                        ),
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
                                      start: 5.0,
                                      end: 5.0,
                                    ),
                                    child: Text(
                                      getLength(musicFiles[index].path),
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black,
                                    width: 1,
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      start: 5.0,
                                      end: 5.0,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.time,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    getDate(musicFiles[index].path),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_forever_sharp,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                File(musicFiles[index].path).deleteSync();
                                stopAudioMixing();
                                setState(() {
                                  _isStartedAudioMixing = false;
                                  playedIndex = -1;
                                });
                                getData();
                              },
                            ),
                          ),
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
                    width: 2.0,
                    color: MyColors.lightUnSelectedColor,
                  ),
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
                                stopAudioMixing();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.power_settings_new_outlined,
                                size: 30.0,
                              ),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                prevAudioMixing();
                              },
                              icon: Icon(Icons.skip_previous, size: 30.0),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _isStartedAudioMixing
                                ? IconButton(
                                    onPressed: () {
                                      pauseAudioMixing();
                                    },
                                    icon: Icon(Icons.pause, size: 30.0),
                                    color: Colors.black,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      resumeAudioMixing();
                                    },
                                    icon: Icon(Icons.play_arrow, size: 30.0),
                                    color: Colors.black,
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                nextAudioMixing();
                              },
                              icon: Icon(Icons.skip_next_rounded, size: 30.0),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.volume_down, size: 30.0),
                              color: Colors.black,
                            ),
                            PopupMenuButton(
                              position: PopupMenuPosition.over,
                              shadowColor: MyColors.unSelectedColor,
                              elevation: 4.0,
                              color: MyColors.darkColor,
                              icon: Container(),
                              onSelected: (int result) async {
                                widget.audioPlayer.setVolume(result);
                              },
                              itemBuilder: (BuildContext context) =>
                                  volumeBuilder(),
                            ),
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
                            Slider(
                              value: progress.clamp(min, max),
                              min: min,
                              max: max,
                              onChanged: (val) async {
                                await widget.audioPlayer.seekTo((val - 1000).toInt());
                                setState(() {
                                  progress = val;
                                });
                              },
                              thumbColor: MyColors.secondaryColor,
                              activeColor: MyColors.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Music2BottomSheet() => MusicsModal2(
    zegoEngine: widget.zegoEngine,
    audioPlayer: widget.audioPlayer,
  );
}

getDate(file) {
  return File(file).lastModifiedSync().toString();
}

getLength(file) {
  int bytes = File(file).lengthSync();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i];
}

List<PopupMenuEntry<int>> volumeBuilder() {
  return [
    PopupMenuItem<int>(
      value: 100,
      child: Text('100%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 70,
      child: Text('70%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 50,
      child: Text('50%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 30,
      child: Text('30%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 20,
      child: Text('20%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 10,
      child: Text('10%', style: TextStyle(color: Colors.black)),
    ),
    PopupMenuItem<int>(
      value: 0,
      child: Text('0%', style: TextStyle(color: Colors.black)),
    ),
  ];
}
