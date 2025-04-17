import 'dart:async';
import 'dart:io';

import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/WalletServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


const String _kConsumableId1 = 'get_8000_coins';
const String _kConsumableId2 = 'get_40000_coins';
const String _kConsumableId3 = 'get_160000_coins';
const String _kConsumableId4 = 'get_400000_coins';
const String _kConsumableId5 = 'get_800000_coins';
const List<String> _kProductIds = <String>[
  _kConsumableId1,
  _kConsumableId2,
  _kConsumableId3,
  _kConsumableId4,
  _kConsumableId5
];


class GoogleProductsScreen extends StatefulWidget {
  const GoogleProductsScreen({super.key});

  @override
  State<GoogleProductsScreen> createState() => _GoogleProductsScreenState();
}

class _GoogleProductsScreenState extends State<GoogleProductsScreen> {


  AppUser? user;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  List<String> _notFoundIds = <String>[];
  List<String> _consumables = <String>[];

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }


    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());


    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products.sort((a, b) => double.parse(a.title.substring(0 , a.title.indexOf('(LIKLOK)'))).
        compareTo(double.parse(b.title.substring(0 , b.title.indexOf('(LIKLOK)')))));
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products.sort((a, b) => double.parse(a.title.substring(0 , a.title.indexOf('(LIKLOK)'))).
        compareTo(double.parse(b.title.substring(0 , b.title.indexOf('(LIKLOK)')))));
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
       _products = productDetailResponse.productDetails  ;
      _products.sort((a, b) => double.parse(a.title.substring(0 , a.title.indexOf('(LIKLOK)'))).
       compareTo(double.parse(b.title.substring(0 , b.title.indexOf('(LIKLOK)')))));
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = [];
      _purchasePending = false;
      _loading = false;
    });

  }


  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase
        .purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          _subscription.cancel();
        }, onError: (Object error) {
          // handle error here.
        });
    initStoreInfo();
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("Google Pay", style: TextStyle(color: Colors.black),),
      ),
      body: !_loading  ? Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: ListView.separated(itemBuilder: (context, index) => productListItem(index) , separatorBuilder: (context, index) => itemSperatorBuilder(), itemCount: _products.length)
      ) : Loading(),
    );
  }



  purchaseItem(index) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _products[index]);
    InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam ,  autoConsume: true);
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // showPendingUI();

      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // handleError

        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // charge user
            chargeUserAndCompeletePurchase(purchaseDetails);
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }


  Widget productListItem(index) =>  GestureDetector(
        onTap: () {
           purchaseItem(index);
        },
        child: Row(
        children: [
        Image(image: getProductImag(_products[index].id),
        width: 50.0,
        height: 50.0,),

        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(_products[index].title.substring(0 , _products[index].title.indexOf('(LIKLOK)')), style: TextStyle(color: MyColors.whiteColor,
        fontSize: 18.0,
        fontWeight: FontWeight.bold),),
        Text(_products[index].id.tr, style: TextStyle(
        color: MyColors.unSelectedColor, fontSize: 8.0),)
        ],
        ),
        Expanded(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        margin: EdgeInsets.symmetric(horizontal: 5.0),

        decoration: BoxDecoration(color: MyColors.primaryColor
            .withOpacity(.7), borderRadius: BorderRadius
            .circular(15.0)),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image(image: AssetImage(
        'assets/images/google-pay.png'),
        width: 35.0,
        height: 35.0,),
        SizedBox(width: 5.0,),
        Text( (_products[index].price.toString().replaceAll(',','')).toString() , style: TextStyle(
        color: Colors.white, fontSize: 12.0),)

        ],
        ),

        ),
        ],
        ),
        )

        ],
        ),
  );

  Widget itemSperatorBuilder() => Container(height: 0.5, width: MediaQuery.sizeOf(context).width *.9, color: MyColors.unSelectedColor, margin: EdgeInsets.all(5),);
  ImageProvider getProductImag(String id) {

    if (id == _kConsumableId1) {
      return  AssetImage('assets/images/G1.png');
    } else if(id == _kConsumableId2){
      return  AssetImage('assets/images/G5.png');
    }
    else if(id == _kConsumableId3){
      return  AssetImage('assets/images/G20.png');
    }
    else if(id == _kConsumableId4){
      return  AssetImage('assets/images/G50.png');
    }
    else if(id == _kConsumableId5){
      return  AssetImage('assets/images/G100.png');
    }
    else return AssetImage('assets/images/G1.png');

  }

  chargeUserAndCompeletePurchase( PurchaseDetails purchaseDetails) async{
    String gold = "0" ;
    if (purchaseDetails.productID == _kConsumableId1) {
      gold = "8000";
    } else if(purchaseDetails.productID == _kConsumableId2){
      gold = "40000";
    }
    else if(purchaseDetails.productID == _kConsumableId3){
      gold = "160000";
    }
    else if(purchaseDetails.productID == _kConsumableId4){
      gold = "400000";
    }
    else if(purchaseDetails.productID == _kConsumableId5){
      gold = "800000";
    }
    else
      gold = "0";
    await WalletServices().chargeWallet(user!.id , gold , 'GOOGLE_CHARGE');
    await _inAppPurchase.completePurchase(purchaseDetails);


  }


}
