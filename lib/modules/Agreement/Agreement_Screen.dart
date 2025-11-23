import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Agreement_Screen extends StatefulWidget {
  const Agreement_Screen({super.key});

  @override
  State<Agreement_Screen> createState() => _Agreement_ScreenState();
}

class _Agreement_ScreenState extends State<Agreement_Screen> {

  String local = '' ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocal();
  }

  getLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? l = await prefs.getString('local_lang') ;
    if(l == null) l = 'en' ;
    if(l == '') l = 'en' ;
    setState(() {
      local = l! ;
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("agreement_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5.0,),
                Text("agreement_user_agreement".tr,style: TextStyle(color: Colors.black,fontSize: 20.0),),
                SizedBox(height: 20.0,),
                Column(
                  children: [
                    local == 'en' ?    Text(style: TextStyle(color: Colors.black),''' LikLok User Agreement
Welcome to LikLok (the “Platform” or “APP”). The Platform is provided and controlled by LikLok. (“LikLok”, “we” or “us”) This Terms of Service ("Terms") was written in English (US). This Terms is the legitimate agreement by and between You and LikLok. To the extent any translated version of Terms agreement conflicts against the English version, this English version prevails.
1. Special Notices
1.1 This LikLok User Agreement (this “Agreement”) governs your usage of our services, (hereinafter, “Services”) including LikLok App, a Audio streaming application and social network developed by us. For the purposes of this Agreement, you and LikLok will be jointly referred to as the “Parties” and respectively as a “Party”.
1.2 By using our Services, or by clicking on "Sign Up" during the registration process, you agree to all terms of this Agreement. We, at our sole discretion, may revise this Agreement from time to time, and the current version will be found at the following link: About us>User Agreement. By continuing to avail our Services, you agree to be bound by the revised Agreement.
1.3 You may only use our Service if you are 16 years or older, and if you are not subject to statutory age limit to enter into this Agreement according to the applicable laws and regulations in your country. If you are below the aforementioned minimum age, you may only use LikLok if your guardian has provided us with valid consent for you to use LikLok . You may not falsely claim you have reached the minimum age.
1.4 You shall be solely responsible for the safekeeping of your LikLok account and password. All behaviors and activities conducted through your LikLok account will be deemed as your behaviors and activities for which you shall be solely responsible.
2. Services Content
2.1.We reserve the right to change the content of our Services from time to time, at our discretion, with or without notice.
2.2 Some of the Services provided by LikLok require payment. For paid-for Services, LikLok will give you explicit notice in advance and you may only access such Services if you agree to and pay the relevant charges. If you choose to decline to pay the relevant charges, LikLok shall not be bound to provide such paid-for Services to you.
2.3 LikLok needs to perform scheduled or unscheduled repairs and maintenance. If such situations cause an interruption of paid-for Services for a reasonable duration, LikLok shall not bear any liability to you and/or to any third parties. However, LikLok shall provide notice to you as soon as possible.
2.4 LikLok has the right to suspend, terminate or restrict provision of the Services under this Agreement at any time and is not obligated to bear any liability to you or any third party, if any of the following events occur:
2.4.1 You are under the minimum age in order to receive LikLok services;
2.4.2 You violate the Terms of Use stipulated in this Agreement;
2.4.3 You fail to make a payment for using paid-for Services.
2.5 EXCEPT FOR THE EXPRESS REPRESENTATIONS AND WARRANTIES SET FORTH IN THIS AGREEMENT, LikLok MAKES NO WARRANTY IN CONNECTION WITH THE SUBJECT MATTER OF THIS AGREEMENT AND LikLok HEREBY DISCLAIMS ANY AND ALL OTHER WARRANTIES, WHETHER STATUTORY, EXPRESS OR IMPLIED, INCLUDING ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND ANY IMPLIED WARRANTIES ARISING FROM COURSE OF DEALING OR PERFORMANCE, REGARDING SUCH SUBJECT MATTER.
3. Privacy
You acknowledge that you have read and fully understand our Privacy Policy, which describes how we handle the data you provide to us or generated when you use our Services. If you have any question, please contact us at:  support@liklok.live
4. Virtual Items
4.1 You can only buy virtual golds (“Golds”) and virtual gifts (Gifits), send Gifts to others, receive Gifts with monetary value, earn virtual diamonds ("Diamonds").
4.2 The price of the Golds will be displayed at the point of purchase. All charges and payments for Golds will be made in the currency specified at the point of purchase through the relevant payment mechanism. Currency exchange settlements, foreign transaction fees and payment channel fees, if any, are based on your agreement with the applicable payment provider.
4.3 You will be responsible for the payment of any Golds purchased by you. Once your purchase has been completed, your user account will be credited with Golds. Golds can be used to purchase Gifts. Golds cannot be exchanged for cash, or legal tender, or currency of any state, region, or any political entity, or any other form of credit. Golds can only be used on LikLok and as part of our Services, and cannot be combined or used in conjunction with other promotions, coupons, discounts or special offers, except those designated by us.
4.4 Except as otherwise set out in this Agreement, all sales of Golds and Gifts are final, and we do not offer refunds for any purchased Golds and Gifts. Golds and Gifts cannot be converted into or exchanged for cash, or be refunded or reimbursed by us for any reason.
5. Terminating Services
You may terminate LikLok Services and this Agreement by revoking your LikLok account. You may contact us at: support@liklok.live
6. Disclaimers
6.1 You shall be fully responsible for any risks involved in using LikLok Services. Any use or reliance on LikLok Services will be at your own risk.
6.2 Under no circumstance does LikLok guarantee that the Services will satisfy your requirements, or guarantee that the Services will be uninterrupted. The timeliness, security and accuracy of the Services are also not guaranteed. You acknowledge and agree that the Services is provided by LikLok on an “as is” basis. LikLok make no representations or warranties of any kind express or implied as to the operation and the providing of such Services or any part thereof. LikLok shall not be liable in any way for the quality, timeliness, accuracy or completeness of the Services and shall not be responsible for any consequences which may arise from your use of such Services.
6.3 LikLok does not guarantee the accuracy and integrity of any external links that may be accessible by using the Services and/or any external links that have been placed for the convenience of you. LikLok shall not be responsible for the content of any linked site or any link contained in a linked site, and LikLok shall not be held responsible or liable, directly or indirectly, for any loss or damage in connection with the use of the Services by you. Moreover, LikLok shall not bear any responsibility for the content of any web page that you are directed via an external link that is not under the control of LikLok .
6.4 LikLok shall not bear any liability for the interruption of or other inadequacies in the Services caused by circumstances of force majeure, or that are otherwise beyond the control of LikLok . However, as far as possible, LikLok shall reasonably attempt to minimize the resulting losses of and impact upon you.
7. Other Terms
7.1 This Agreement constitutes the entire agreement of agreed items and other relevant matters between both parties. Other than as stipulated by this Agreement, no other rights are vested in either Party to this Agreement.
7.2 If any provision of this Agreement is rendered void or unenforceable by competent authorities, in whole or in part, for any reason, the remaining provisions of this Agreement shall remain valid and binding.
7.3 The headings within this Agreement have been set for the sake of convenience, and shall be disregarded in the interpretation of this Agreement.
8. Governing Law
These Terms of Service and any separate agreements whereby we provide you Services shall be governed by and construed in accordance with the laws of HK.
9. Contact us
9.1 Email: support@liklok.live
9.2 WebSite: https://www.iklok.live
9.3 App: LikLok'''): Text(style: TextStyle(color: Colors.black) ,  '''   اتفاقية المستخدم LikLok
مرحبًا بك في الدخول إلى الدردشة ("المنصة" أو "التطبيق"). يتم توفير النظام الأساسي والتحكم فيه بواسطة LikLok. ("ادخل إلى الدردشة" أو "نحن" أو "لنا") تمت كتابة شروط الخدمة هذه ("الشروط") باللغة العربية (الولايات المتحدة). هذه الشروط هي الاتفاقية الشرعية بينك وبين LikLok. إلى الحد الذي تتعارض فيه أي نسخة مترجمة من اتفاقية الشروط مع النسخة العربية، فإن هذه النسخة العربية هي التي تسود.
1. الإشعارات الخاصة
1.1 تحكم اتفاقية مستخدم LikLok (هذه "الاتفاقية") استخدامك لخدماتنا (المشار إليها فيما بعد بـ "الخدمات") بما في ذلك تطبيق LikLok وتطبيق تدفق الصوت والشبكة الاجتماعية التي طورناها. ولأغراض هذه الاتفاقية، ستتم الإشارة إليك أنت وLikLok بشكل مشترك باسم "الأطراف" وعلى التوالي باسم "الطرف".
1.2 باستخدام خدماتنا، أو بالنقر فوق "التسجيل" أثناء عملية التسجيل، فإنك توافق على جميع شروط هذه الاتفاقية. يجوز لنا، وفقًا لتقديرنا الخاص، مراجعة هذه الاتفاقية من وقت لآخر، وسيتم العثور على الإصدار الحالي على الرابط التالي: من نحن>اتفاقية المستخدم. من خلال الاستمرار في الاستفادة من خدماتنا، فإنك توافق على الالتزام بالاتفاقية المعدلة.
1.3 لا يجوز لك استخدام خدمتنا إلا إذا كان عمرك 16 عامًا أو أكبر، وإذا لم تكن خاضعًا للحد القانوني للسن لإبرام هذه الاتفاقية وفقًا للقوانين واللوائح المعمول بها في بلدك. إذا كان عمرك أقل من الحد الأدنى المذكور أعلاه، فلا يجوز لك استخدام LikLok إلا إذا قدم لنا ولي أمرك موافقة صالحة لاستخدام LikLok. لا يجوز لك الادعاء كذباً بأنك قد بلغت الحد الأدنى للسن.
1.4 ستكون وحدك المسؤول عن الحفاظ على حساب LikLok وكلمة المرور الخاصين بك. سيتم اعتبار جميع السلوكيات والأنشطة التي تتم من خلال حساب LikLok الخاص بك بمثابة سلوكيات وأنشطتك التي ستكون مسؤولاً عنها وحدك.
2. محتوى الخدمات
2.1. نحتفظ بالحق في تغيير محتوى خدماتنا من وقت لآخر، وفقًا لتقديرنا، مع أو بدون إشعار.
2.2 تتطلب بعض الخدمات التي تقدمها LikLok الدفع. بالنسبة للخدمات المدفوعة، ستقدم لك خدمة LikLok إشعارًا صريحًا مسبقًا ولا يجوز لك الوصول إلى هذه الخدمات إلا إذا وافقت على الرسوم ذات الصلة ودفعتها. إذا اخترت رفض دفع الرسوم ذات الصلة، فلن تكون شركة LikLok ملزمة بتقديم هذه الخدمات المدفوعة لك.
2.3 يحتاج برنامج LikLok إلى إجراء الإصلاحات والصيانة المجدولة أو غير المجدولة. إذا تسببت مثل هذه المواقف في انقطاع الخدمات المدفوعة لمدة معقولة، فلن تتحمل LikLok أي مسؤولية تجاهك و/أو تجاه أي طرف ثالث. ومع ذلك، يجب على LikLok تقديم إشعار لك في أقرب وقت ممكن.
2.4 يحق لـ LikLok تعليق أو إنهاء أو تقييد تقديم الخدمات بموجب هذه الاتفاقية في أي وقت وغير ملزم بتحمل أي مسؤولية تجاهك أو تجاه أي طرف ثالث، في حالة حدوث أي من الأحداث التالية:
2.4.1 أنت أقل من الحد الأدنى للسن لتلقي خدمات LikLok؛
2.4.2 أنك تنتهك شروط الاستخدام المنصوص عليها في هذه الاتفاقية؛
2.4.3 فشلك في إجراء الدفع مقابل استخدام الخدمات المدفوعة.
2.5 باستثناء الإقرارات والضمانات الصريحة المنصوص عليها في هذه الاتفاقية، لا تقدم شركة LikLok أي ضمان فيما يتعلق بموضوع هذه الاتفاقية، وتخلي شركة LikLok مسؤوليتها عن أي وجميع الضمانات الأخرى، سواء كانت قانونية أو صريحة أو ضمنية، بما في ذلك جميع الضمانات الضمنية ضمانات إد الملكية، وعدم الانتهاك، وقابلية التسويق، والملاءمة لغرض معين وأي ضمانات ضمنية تنشأ عن سياق التعامل أو الأداء، فيما يتعلق بهذه المسألة الموضوعية.
3. الخصوصية
أنت تقر بأنك قرأت وفهمت سياسة الخصوصية الخاصة بنا بشكل كامل، والتي تصف كيفية تعاملنا مع البيانات التي تقدمها لنا أو التي يتم إنشاؤها عند استخدام خدماتنا. إذا كان لديك أي سؤال، يرجى الاتصال بنا على:  support@liklok.live
4. العناصر الافتراضية
4.1 يمكنك فقط شراء القطع الذهبية الافتراضية ("الذهبيات") والهدايا الافتراضية (الهدايا)، وإرسال الهدايا للآخرين، وتلقي الهدايا ذات القيمة النقدية، وكسب الماسات الافتراضية ("الماسات").
4.2 سيتم عرض سعر الذهب عند نقطة الشراء. سيتم سداد جميع الرسوم والمدفوعات الخاصة بالذهبيات بالعملة المحددة عند نقطة الشراء من خلال آلية الدفع ذات الصلة. تعتمد تسويات صرف العملات ورسوم المعاملات الأجنبية ورسوم قناة الدفع، إن وجدت، على اتفاقيتك مع مزود الدفع المناسب.
4.3 ستكون مسؤولاً عن دفع أي قطع ذهبية اشتريتها. بمجرد الانتهاء من عملية الشراء، سيتم إضافة الذهب إلى حساب المستخدم الخاص بك. يمكن استخدام الذهب لشراء الهدايا. لا يمكن استبدال الذهب بالنقود أو العملة القانونية أو العملة لأي دولة أو منطقة أو أي كيان سياسي أو أي شكل آخر من أشكال الائتمان. لا يمكن استخدام Golds إلا في LikLok وكجزء من خدماتنا، ولا يمكن دمجها أو استخدامها مع العروض الترويجية أو الكوبونات أو الخصومات أو العروض الخاصة الأخرى، باستثناء تلك التي نحددها من قبلنا.
4.4 باستثناء ما هو منصوص عليه خلافًا لذلك في هذه الاتفاقية، فإن جميع مبيعات الذهب والهدايا تكون
نهائيًا، ولا نعرض المبالغ المستردة مقابل أي هدايا ذهبية وهدايا تم شراؤها. لا يمكن تحويل الذهب والهدايا إلى أموال نقدية أو استبدالها، أو استردادها أو تعويضها من قبلنا لأي سبب من الأسباب.
5. إنهاء الخدمات
يجوز لك إنهاء LikLok Services وهذه الاتفاقية عن طريق إلغاء حساب LikLok الخاص بك. يمكنك الاتصال بنا على:  support@liklok.live
6. إخلاء المسؤولية
6.1 تتحمل المسؤولية الكاملة عن أي مخاطر قد تنتج عن استخدام خدمات LikLok. أي استخدام أو اعتماد على LikLok Services سيكون على مسؤوليتك الخاصة.
6.2 لا تضمن خدمة LikLok تحت أي ظرف من الظروف أن الخدمات ستلبي متطلباتك، أو تضمن عدم انقطاع الخدمات. كما لا يتم ضمان توقيت الخدمات وأمنها ودقتها. أنت تقر وتوافق على أن الخدمات مقدمة من خلال LikLok على أساس "كما هي". لا تقدم شركة LikLok أي إقرارات أو ضمانات من أي نوع، صريحة أو ضمنية، فيما يتعلق بتشغيل وتقديم هذه الخدمات أو أي جزء منها. لن تكون شركة LikLok مسؤولة بأي شكل من الأشكال عن جودة الخدمات أو توقيتها أو دقتها أو اكتمالها ولن تكون مسؤولة عن أي عواقب قد تنشأ عن استخدامك لهذه الخدمات.
6.3 لا يضمن تطبيق LikLok دقة وسلامة أي روابط خارجية يمكن الوصول إليها باستخدام الخدمات و/أو أي روابط خارجية تم وضعها لراحتك. لن تكون شركة LikLok مسؤولة عن محتوى أي موقع مرتبط أو أي رابط موجود في موقع مرتبط، ولن تتحمل شركة LikLok أي مسؤولية أو التزام، بشكل مباشر أو غير مباشر، عن أي خسارة أو ضرر فيما يتعلق باستخدام الخدمات بواسطتك. علاوة على ذلك، فإن LikLok لا يتحمل أي مسؤولية عن محتوى أي صفحة ويب يتم توجيهها إليك عبر رابط خارجي لا يقع تحت سيطرة LikLok.
6.4 لا تتحمل شركة LikLok أي مسؤولية عن انقطاع الخدمات أو أوجه القصور الأخرى فيها بسبب الظروف القاهرة، أو التي تكون خارجة عن سيطرة شركة LikLok. ومع ذلك، قدر الإمكان، يجب على LikLok أن تحاول بشكل معقول تقليل الخسائر الناتجة والتأثير عليك.
7. شروط أخرى
7.1 تشكل هذه الاتفاقية الاتفاقية الكاملة للبنود المتفق عليها والمسائل الأخرى ذات الصلة بين الطرفين. بخلاف ما هو منصوص عليه في هذه الاتفاقية، لا تُمنح أي حقوق أخرى لأي من طرفي هذه الاتفاقية.
7.2 إذا أصبح أي حكم من أحكام هذه الاتفاقية باطلاً أو غير قابل للتنفيذ من قبل السلطات المختصة، كليًا أو جزئيًا، لأي سبب من الأسباب، فإن الأحكام المتبقية من هذه الاتفاقية تظل سارية وملزمة.
7.3 تم وضع العناوين ضمن هذه الاتفاقية من أجل التيسير، ويجب تجاهلها في تفسير هذه الاتفاقية.
8. القانون الحاكم
تخضع شروط الخدمة هذه وأي اتفاقيات منفصلة نقدم بموجبها الخدمات لك لقوانين هونج كونج وتفسر وفقًا لها.
9. اتصل بنا
9.1 البريد الإلكتروني:  support@liklok.live
9.2 الموقع الإلكتروني: https://www.iklok.live
9.3 التطبيق: LikLok  '''   )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
