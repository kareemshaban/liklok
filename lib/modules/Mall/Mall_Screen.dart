import 'dart:io';
import 'package:LikLok/helpers/MallHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Mall/Components/friends_modal_screen.dart';
import 'package:LikLok/modules/MyDesigns/My_Designs_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/DesignServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../models/Category.dart';
import '../Loading/loadig_screen.dart';
import 'package:http/http.dart' as http;

class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen>  with TickerProviderStateMixin   {
  AppUser? user ;
  MallHelper? helper ;
  List<File> imageFile = [];
  int? selectedCategory  ;
  int? selectedDesign  ;
  int tabsCount = 0 ;
  TabController? _tabController ;
  List<Widget> tabs = [] ;
  List<Widget> views = [] ;
  String preview_img = "" ;
  SVGAAnimationController? animationController;
  bool loading = false ;
  List<Category>?   categories  = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.animationController = SVGAAnimationController(vsync: this);
  //  this.loadAnimation();
    getData();

  }
  void loadAnimation(img_url) async {
    final videoItem = await SVGAParser.shared.decodeFromURL(img_url);
    this.animationController!.videoItem = videoItem;
    this
        .animationController
        !.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => this.animationController!.videoItem = null);

    animationController!.addStatusListener((status) {
      print(status);
    });
  }
  Future<void> loadImage() async {
    for(var i =0 ; i < helper!.designs!.length ; i++){
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, helper!.designs![i].icon);
      final file = File(filePath);

      if (await file.exists()){
        List<File> temp = [];
        temp = imageFile ;
       temp.add(file);
       setState((){
          imageFile = temp ;
        });
        updateImage(file,helper!);
      } else {
        await downloadImage(file , helper!);
        setState(() {
          imageFile.add(file);
        });
      }
    }
  }

  Future<void> downloadImage(File file , MallHelper helper) async {
    for(var i = 0 ; i < helper.designs!.length  ; i++){
      final response = await http.get(Uri.parse('${ASSETSBASEURL + 'Designs/' + helper.designs![i].icon}'));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        List<File> temp = [];
        temp = imageFile ;
        temp.add(file);
        setState((){
          imageFile = temp ;
        });
      }
    }
    print(imageFile) ;
  }

  Future<void> updateImage(File file , MallHelper helper) async {
    for(var i = 0 ; i < helper.designs!.length  ; i++){
      final response = await http.get(Uri.parse('${ASSETSBASEURL + 'Designs/' + helper.designs![i].icon}'));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        List<File> temp = [];
        temp = imageFile ;
        temp.add(file);
        setState((){
          imageFile = temp ;
        });
      }
    }
    print(imageFile);
  }
  getData() async{
    setState(() {
      loading = true ;
    });
    // FUNCTION FILL LIST<FILE> FROM CASH
    helper = await DesignServices().getAllCatsAndDesigns();
    DesignServices().helperSetter(helper!);

    setState(() {
      categories = helper!.categories ;
      categories!.sort((a, b) => a.order.compareTo(b.order));
      user = AppUserServices().userGetter();
      selectedCategory = categories![0].id ;
      tabsCount = categories!.length ;
      _tabController = new TabController(vsync: this, length: tabsCount);
      _tabController!.addListener((){
        setState(() {
          if(_tabController!.index < categories!.length  ){
            selectedCategory = categories![_tabController!.index].id ;
          } else {
            selectedCategory = 0 ;
          }

        });

      });

      getCats();
      getTabs();

    });
    setState(() {
      loading = false ;
    });
  }
  Future<void> _refresh()async{
   await getData() ;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        backgroundColor: MyColors.solidDarkColor,
        title: Text("mall_title".tr , style: TextStyle(color: Colors.black , fontSize: 22.0),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyDesignScreen()));
              },
              icon: const Icon(
                Icons.store,
                color: Colors.black,
                size: 30.0,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          child: loading ? Loading(): (
          tabsCount > 0 ?  Stack(
            children: [
              Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height:40.0,
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.center,
                        isScrollable: true ,
                        unselectedLabelColor: Colors.grey,
                        labelColor: MyColors.darkColor,
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0), // Creates border
                            color: MyColors.primaryColor ),
                        labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),
                        tabs:  tabs,
                      )
                    ),
                    const SizedBox(height: 10.0,),
        
                    Expanded(child: TabBarView(children: views ,   controller: _tabController,
                    )),
        
        
                  ],
                ),
              Center(
               // child: animationController!.videoItem != null ? SVGAImage(animationController!) : Container(),
                 child: preview_img != "" ?  SVGAEasyPlayer( resUrl: preview_img) : Container(),
              )
            ],
          ) : Container()
          ),
        ),
      ),
    );
  }
  getCats(){
    List<Widget> t = [] ;
    Widget tab = Container();
    tab = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 5.0),
      child: Tab(text: 'relations'.tr ),
    );
    t.add(tab);
    setState(() {
      tabs = t ;
    });
    for(var i = 0 ; i < categories!.length -1 ; i++){
        tab = Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 5.0),
         child: Tab(text: categories![i].name ),
       );
      t.add(tab);
      setState(() {
        tabs = t ;
      });
    }

  }
  Widget countryListSpacer() => SizedBox(width: 10.0,);

  Widget catListItem(index) => categories!.isNotEmpty ?  GestureDetector(
    onTap: (){
      setState(() {
        selectedCategory = categories![index].id;
        print(selectedCategory);
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 10),
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(25.0) ,
          color: categories![index].id == selectedCategory ? MyColors.primaryColor : MyColors.lightUnSelectedColor),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(categories![index].name , style:
          TextStyle(color: categories![index].id == selectedCategory ? MyColors.darkColor :MyColors.whiteColor ,
              fontSize: 13.0 , fontWeight: FontWeight.bold),)
        ],),
    ),
  ) : Container();

  Widget designListItem(design) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() {
        selectedDesign = design!.id ;
        print(selectedDesign);
      });
      showModalBottomSheet(
          context: context,
          builder: (ctx) => DesignBottomSheet(design));
    },
    child: Container(
      decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(15.0) ,
      border: selectedDesign == design.id ? Border.all(color: MyColors.primaryColor , width: 3.0) : Border.all(color: Colors.transparent)),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),
              child: Center(
                 child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + design.icon))//Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + design.icon),),
                // child: SVGASimpleImage(
                //     resUrl: "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                Text(design.name , style: TextStyle(color: Colors.black , fontSize: 15.0),),
                SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                    SizedBox(width: 5.0,),
                    Text(design.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0 , fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 3.0,),
              ],
            ),
          ),
        ],
      ),
    ),
  );


  Widget relationListItem(design) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() {
        selectedDesign = design!.id ;
      });
      showModalBottomSheet(
          context: context,
          builder: (ctx) => RelationBottomSheet(design));
    },
    child: Container(
      decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(15.0) ,
          border: selectedDesign == design.id ? Border.all(color: MyColors.primaryColor , width: 3.0) : Border.all(color: Colors.transparent)),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),
              child: Center(
                  child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'RelationsMotion/' + design.motion_icon))//Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + design.icon),),
                // child: SVGASimpleImage(
                //     resUrl: "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                Text(design.name , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                    SizedBox(width: 5.0,),
                    Text(design.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0 , fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 3.0,),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  getTabs() {
    print('my selectedCategory is '+ selectedCategory.toString());
    List<Widget> t = [] ;
      Widget tab = getRelationTab();
      t.add(tab);
    for(var i = 0 ; i < categories!.length - 1 ; i++){
      // if(i < categories!.length ){
        Widget tab = getTab(categories![i].id);
        t.add(tab);
      // } else {
      //   Widget tab = getRelationTab();
      //   t.add(tab);
      // }

    }
    setState(() {
      views = t ;
    });
  }
  Widget getTab(catId) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: MyColors.primaryColor,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: .7,
            children: helper!.designs!.where((element) => element.category_id == catId).map((design ) => designListItem(design)).toList() ,
          ),
        ),
      ),
    ],
  );

  Widget getRelationTab() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: MyColors.primaryColor,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: .7,
            children: helper!.relations!.toList().map((relation ) => relationListItem(relation)).toList() ,
          ),
        ),
      ),
    ],
  );



  Widget DesignBottomSheet( design) => Container(
    height: 310.0,
      decoration: BoxDecoration(color: MyColors.solidDarkColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15.0) , topLeft: Radius.circular(15.0))),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  color: MyColors.solidDarkColor,
                  child: Center(
                    child: (design!.category_id == 3 || design!.category_id == 5) ? Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + design.icon))
                      : design!.category_id == 4 ?

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                          backgroundImage: user?.img != "" ? (user!.img.startsWith('https') ? CachedNetworkImageProvider(user!.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}'))  :    null,
                          radius: 65.0,
                          child: user?.img== "" ?
                          Text(user!.name.toUpperCase().substring(0 , 1) +
                              (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                            style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                        ),
                        SizedBox(height: 200.0, width: 200.0, child: SVGAEasyPlayer( resUrl: ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon +'?raw=true')),
                      ],
                    ) :

                    SVGAEasyPlayer( resUrl: ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon +'?raw=true'),
                  // /  SVGASimpleImage( resUrl: "https://chat.gifty-store.com/images/Designs/Motion/1703720610motion_icon.svga" ),
                  ),
                ),
                (design!.category_id == 3 || design!.category_id == 5) ? Container(
                  width: 40.0,
                  height: 40.0,

                  decoration: BoxDecoration(color: Colors.black12 , borderRadius: BorderRadius.circular(10.0)),
                  child:  IconButton(onPressed: (){
                    setState(() {
                       var img =  ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon ;
                       preview(img , design);
                    });
                  },  icon: Icon(Icons.remove_red_eye_outlined , color: Colors.white,))
                ): Container(),
              ],
            ),
          ),
          SizedBox(height: 5.0,),

          Container(
            color: MyColors.solidDarkColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(design.name , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            Text(design!.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),)                      ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(start: 3.0),
                        decoration: BoxDecoration(color: Colors.black12 , borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            SizedBox(width: 5.0,),
                            Text(user!.gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0 , fontWeight: FontWeight.bold),),
                            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.primaryColor, size: 20.0,)  )
                          ],
                        ),
                      ),
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                purchaseDesign(design);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                                child: Text("mall_purchase".tr , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),),
                              ),
                            ),
                            // SizedBox(width: 10.0,),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                            //   decoration: BoxDecoration(color: MyColors.blueColor , borderRadius: BorderRadius.circular(20.0)),
                            //   child: Text("Send" , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),),
                            // ),
                          ],
                        ),
                      )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )

  );


  Widget RelationBottomSheet( design) => Container(
      height: 310.0,
      decoration: BoxDecoration(color: MyColors.solidDarkColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15.0) , topLeft: Radius.circular(15.0))),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  color: MyColors.solidDarkColor,
                  child: Center(
                      child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Relations/' + design.icon))
             

                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 5.0,),

          Container(
            color: MyColors.solidDarkColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(design.name , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            Text(design!.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),)                      ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(start: 3.0),
                        decoration: BoxDecoration(color: Colors.black12 , borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            SizedBox(width: 5.0,),
                            Text(user!.gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0 , fontWeight: FontWeight.bold),),
                            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.primaryColor, size: 20.0,)  )
                          ],
                        ),
                      ),
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                purchaseRelation(design);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                                child: Text("gift_send".tr , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),),
                              ),
                            ),

                          ],
                        ),
                      )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )

  );

  preview(img , design) async{
    Navigator.pop(context);
      setState(() {
        preview_img = img ;
      });
     await Future.delayed(Duration(seconds: 10));
      setState(() {
        preview_img = "" ;
      });
    showModalBottomSheet(
        context: context,
        builder: (ctx) => DesignBottomSheet(design));



    // Navigator.pop(context);
    // final videoItem = await SVGAParser.shared.decodeFromURL(img);
    // this.animationController!.videoItem = videoItem;
    // this
    //     .animationController
    // !.repeat()
    // .whenComplete(() => this.animationController!.videoItem = null);
    //  await Future.delayed(Duration(seconds: 8));
    // animationController!.stop();
    // this.animationController!.videoItem = null ;
    // showModalBottomSheet(
    //     context: context,
    //     builder: (ctx) => DesignBottomSheet(design));

  }

  purchaseDesign(design) async{
    if( NumberFormat().parse(user!.gold) >= NumberFormat().parse(design.price) ){
      await DesignServices().purchaseDesign(user!.id, user!.id, design!.id);
      Navigator.pop(context);
      AppUser? res = await AppUserServices().getUser(user!.id);
      setState(() {
        user = res ;
      });
      AppUserServices().searchUser(user);
    } else {
      Fluttertoast.showToast(
          msg: "mall_msg".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }

  }
  purchaseRelation(design){
    if( NumberFormat().parse(user!.gold) >= NumberFormat().parse(design.price) ){
      Navigator.pop(context);
      showModalBottomSheet(
          isScrollControlled: true ,
          context: context,
          builder: (ctx) => FriendsModalScreen(relation_id: design.id , relation_name: design.name,));
    } else {
      Fluttertoast.showToast(
          msg: "mall_msg".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
  }


}
