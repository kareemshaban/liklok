import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../helpers/zego_handler/internal/internal.dart';
import '../../../shared/styles/colors.dart';
import 'musics_modal.dart';
import 'package:path/path.dart' as path;
import 'package:device_info_plus/device_info_plus.dart';

class MusicsModal2 extends StatefulWidget {
  final ZegoExpressEngine zegoEngine;
  final ZegoMediaPlayer audioPlayer;

  const MusicsModal2({
    super.key,
    required this.zegoEngine,
    required this.audioPlayer,
  });

  @override
  State<MusicsModal2> createState() => _MusicsModalState2();
}

class _MusicsModalState2 extends State<MusicsModal2> {
  bool isCheked = false;

  List<bool> selected = [];

  final FileManagerController controller = FileManagerController();
  List<File> _mp3Files = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    //initlist();
  }

  void initlist() async {
    Directory? dir = await getExternalStorageDirectory();
    List<FileSystemEntity> files;
    files = dir!.listSync(recursive: true, followLinks: false);
    print('files');
    print(files);
  }

  Future<void> requestPermissions() async {
    if (!Platform.isAndroid) {
      print('Not running on Android');
      return;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    PermissionStatus? storageStatus;
    PermissionStatus? manageStorageStatus;
    PermissionStatus? audioStatus;
    PermissionStatus? mediaImagesStatus;
    PermissionStatus? mediaVideoStatus;
    PermissionStatus? mediaAudioStatus;

    if (sdkInt >= 33) {
      mediaImagesStatus = await Permission.photos.request();
      mediaVideoStatus = await Permission.videos.request();
      mediaAudioStatus = await Permission.audio.request();
    } else if (sdkInt >= 30) {
      manageStorageStatus = await Permission.manageExternalStorage.request();
      audioStatus = await Permission.audio.request();
    } else {
      storageStatus = await Permission.storage.request();
      audioStatus = await Permission.audio.request();
    }

    final granted = [
      storageStatus?.isGranted,
      manageStorageStatus?.isGranted,
      audioStatus?.isGranted,
      mediaImagesStatus?.isGranted,
      mediaVideoStatus?.isGranted,
      mediaAudioStatus?.isGranted,
    ].where((x) => x == true).isNotEmpty;

    if (granted) {
      print('Permissions granted ✅');
    } else {
      print('Some permissions denied ❌');

      if (await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied ||
          await Permission.photos.isPermanentlyDenied ||
          await Permission.videos.isPermanentlyDenied ||
          await Permission.audio.isPermanentlyDenied) {
        print("User permanently denied permission. Opening app settings...");
        openAppSettings();
      }
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
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => MusicsBottomSheet(),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.black,
                    size: 25.0,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'musics2_model_add_music'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    initlist();
                  },
                  icon: Icon(Icons.sync, color: Colors.black, size: 25.0),
                ),
              ],
            ),
            FileManager(
              loadingScreen: Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor),
              ),
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities = snapshot ?? [];
                List<FileSystemEntity> dirs = [];
                List<FileSystemEntity> allFiles =
                    []; //entities.where((element) =>FileManager.isDirectory(element) ).toList();
                List<FileSystemEntity> musicFiles = [];

                dirs = entities
                    .where((element) => FileManager.isDirectory(element))
                    .toList();
                allFiles = entities
                    .where((element) => FileManager.isFile(element))
                    .toList();
                dirs.forEach((element) {
                  Directory dr = element as Directory;
                  if (!dr.path.contains('Android')) {
                    List<FileSystemEntity> files = dr.listSync(
                      followLinks: true,
                      recursive: true,
                    );
                    allFiles = [
                      ...allFiles,
                      ...files.where((element) => FileManager.isFile(element)),
                    ];
                  }
                });
                musicFiles = [
                  ...allFiles.where(
                    (file) =>
                        file.path.toLowerCase().endsWith('.mp3') ||
                        file.path.toLowerCase().contains('m4a'),
                  ),
                ];
                // musicFiles = [...allFiles];
                if (selected.length == 0) {
                  musicFiles.forEach((element) {
                    selected.add(false);
                  });
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: musicFiles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.white.withAlpha(50),
                        height: 80.0,
                        padding: EdgeInsetsDirectional.only(start: 10.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.only(
                                    end: 10.0,
                                  ),
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
                                          FileManager.basename(
                                            musicFiles[index],
                                          ),
                                          style: TextStyle(color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.clock,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: 5.0,
                                        end: 5.0,
                                      ),
                                      child: Text(
                                        '01:20',
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
                                        Icons.save_outlined,
                                        size: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '2024-01-18 20',
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    activeColor: MyColors.primaryColor,
                                    value: selected[index],
                                    onChanged: (d) {
                                      List<bool> new_sel = [...selected];
                                      new_sel[index] = d!;
                                      setState(() {
                                        selected = new_sel;
                                      });
                                      if (d) {
                                        copyFile(musicFiles, index);
                                      }

                                      print('selected');
                                      print(selected);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.black.withAlpha(50),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget MusicsBottomSheet() => MusicsModal(
    zegoEngine: widget.zegoEngine,
    audioPlayer: widget.audioPlayer,
  );
}

copyFile(musicFiles, index) async {
  Directory? appDocDir = await getApplicationDocumentsDirectory();
  String newPath =
      appDocDir.path + '/' + FileManager.basename(musicFiles[index]);
  File _image = new File(musicFiles[index].path);
  print('newFile');
  print(_image);
  File newImage = await _image!.copy(newPath);
  print('newFilenewFile');
  print(newImage);
}
