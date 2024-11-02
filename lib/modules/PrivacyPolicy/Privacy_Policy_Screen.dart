import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Privacy_Policy_Screen extends StatefulWidget {
  const Privacy_Policy_Screen({super.key});

  @override
  State<Privacy_Policy_Screen> createState() => _Privacy_Policy_ScreenState();
}

class _Privacy_Policy_ScreenState extends State<Privacy_Policy_Screen> {

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
        title: Text("privacy_policy_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5.0,),
              Text("privacy_policy".tr,style: TextStyle(color: Colors.black,fontSize: 20.0),),
              SizedBox(height: 20.0,),
              local == 'en' ?   Text(''' Privacy Policy for LikLok
          
          Privacy Policy
          Last updated: January 16, 2024
          
          This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.
          
          We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Privacy Policy Generator.
          
          Interpretation and Definitions
          Interpretation
          The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.
          
          Definitions
          For the purposes of this Privacy Policy:
          
          Account means a unique account created for You to access our Service or parts of our Service.
          
          Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.
          
          Application refers to LikLok, the software program provided by the Company.
          
          Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to LikLok.
          
          Country refers to: Washington, United States
          
          Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.
          
          Personal Data is any information that relates to an identified or identifiable individual.
          
          Service refers to the Application.
          
          Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.
          
          Third-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service.
          
          Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).
          
          You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.
          
          Collecting and Using Your Personal Data
          Types of Data Collected
          Personal Data
          While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:
          
          Email address
          
          First name and last name
          
          Phone number
          
          Address, State, Province, ZIP/Postal code, City
          
          Usage Data
          
          Usage Data
          Usage Data is collected automatically when using the Service.
          
          Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.
          
          When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.
          
          We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.
          
          Information from Third-Party Social Media Services
          The Company allows You to create an account and log in to use the Service through the following Third-party Social Media Services:
          
          Google
          Facebook
          Instagram
          Twitter
          LinkedIn
          If You decide to register through or otherwise grant us access to a Third-Party Social Media Service, We may collect Personal data that is already associated with Your Third-Party Social Media Service's account, such as Your name, Your email address, Your activities or Your contact list associated with that account.
          
          You may also have the option of sharing additional information with the Company through Your Third-Party Social Media Service's account. If You choose to provide such information and Personal Data, during registration or otherwise, You are giving the Company permission to use, share, and store it in a manner consistent with this Privacy Policy.
          
          Information Collected while Using the Application
          While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:
          
          Information regarding your location
          
          Pictures and other information from your Device's camera and photo library
          
          We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on Your device.
          
          You can enable or disable access to this information at any time, through Your Device settings.
          
          Use of Your Personal Data
          The Company may use Personal Data for the following purposes:
          
          To provide and maintain our Service, including to monitor the usage of our Service.
          
          To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.
          
          For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.
          
          To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.
          
          To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.
          
          To manage Your requests: To attend and manage Your requests to Us.
          
          For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.
          
          For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.
          
          We may share Your personal information in the following situations:
          
          With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.
          For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.
          With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.
          With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.
          With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile.
          With Your consent: We may disclose Your personal information for any other purpose with Your consent.
          Retention of Your Personal Data
          The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.
          
          The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.
          
          Transfer of Your Personal Data
          Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.
          
          Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.
          
          The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.
          
          Delete Your Personal Data
          You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.
          
          Our Service may give You the ability to delete certain information about You from within the Service.
          
          You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.
          
          Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.
          
          Disclosure of Your Personal Data
          Business Transactions
          If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.
          
          Law enforcement
          Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).
          
          Other legal requirements
          The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:
          
          Comply with a legal obligation
          Protect and defend the rights or property of the Company
          Prevent or investigate possible wrongdoing in connection with the Service
          Protect the personal safety of Users of the Service or the public
          Protect against legal liability
          Security of Your Personal Data
          The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.
          
          Children's Privacy
          Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.
          
          If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.
          
          Links to Other Websites
          Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.
          
          We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.
          
          Changes to this Privacy Policy
          We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.
          
          We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.
          
          You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.
          
          Contact Us
          If you have any questions about this Privacy Policy, You can contact us:
          
          By email: support@liklok.live ''' , style: TextStyle(color: Colors.grey),)
                  : Text(style: TextStyle(color: Colors.grey) , ''' سياسة الخصوصية LikLok
          
           سياسة الخصوصية
           آخر تحديث: 16 يناير 2024
          
           تصف سياسة الخصوصية هذه سياساتنا وإجراءاتنا بشأن جمع معلوماتك واستخدامها والكشف عنها عند استخدام الخدمة وتخبرك بحقوق الخصوصية الخاصة بك وكيف يحميك القانون.
          
           نحن نستخدم بياناتك الشخصية لتوفير الخدمة وتحسينها. باستخدام الخدمة، فإنك توافق على جمع واستخدام المعلومات وفقًا لسياسة الخصوصية هذه. تم إنشاء سياسة الخصوصية هذه بمساعدة منشئ سياسة الخصوصية.
          
           التفسير والتعاريف
           تفسير
           الكلمات التي يتم كتابة الحرف الأول منها بالأحرف الكبيرة لها معاني محددة وفقًا للشروط التالية. يكون للتعريفات التالية نفس المعنى بغض النظر عما إذا كانت تظهر بصيغة المفرد أو الجمع.
          
           تعريفات
           لأغراض سياسة الخصوصية هذه:
          
           الحساب يعني حسابًا فريدًا تم إنشاؤه لك للوصول إلى خدمتنا أو أجزاء من خدمتنا.
          
           الشركة التابعة تعني كيان يسيطر أو يخضع لسيطرة أو يخضع لسيطرة مشتركة مع طرف ما، حيث تعني كلمة "السيطرة" ملكية 50٪ أو أكثر من الأسهم أو حصص الأسهم أو الأوراق المالية الأخرى التي يحق لها التصويت لانتخاب أعضاء مجلس الإدارة أو أي سلطة إدارية أخرى .
          
           يشير التطبيق إلى برنامج  LikLok، وهو البرنامج الذي توفره الشركة.
          
           تشير الشركة (المشار إليها باسم "الشركة" أو "نحن" أو "نا" أو "خاصتنا" في هذه الاتفاقية) إلى "دخول الدردشة".
          
           تشير الدولة إلى: واشنطن، الولايات المتحدة الأمريكية
          
           الجهاز يعني أي جهاز يمكنه الوصول إلى الخدمة مثل جهاز كمبيوتر أو هاتف محمول أو جهاز لوحي رقمي.
          
           البيانات الشخصية هي أي معلومات تتعلق بفرد محدد أو يمكن التعرف عليه.
          
           تشير الخدمة إلى التطبيق.
          
           مقدم الخدمة يعني أي شخص طبيعي أو اعتباري يقوم بمعالجة البيانات نيابة عن الشركة. ويشير إلى شركات الطرف الثالث أو الأفراد العاملين لدى الشركة لتسهيل الخدمة، أو تقديم الخدمة نيابة عن الشركة، أو أداء الخدمات المتعلقة بالخدمة أو مساعدة الشركة في تحليل كيفية استخدام الخدمة.
          
           تشير خدمة الوسائط الاجتماعية التابعة لجهة خارجية إلى أي موقع ويب أو أي موقع ويب لشبكة اجتماعية يمكن للمستخدم من خلاله تسجيل الدخول أو إنشاء حساب لاستخدام الخدمة.
          
           تشير بيانات الاستخدام إلى البيانات التي يتم جمعها تلقائيًا، إما الناتجة عن استخدام الخدمة أو من البنية التحتية للخدمة نفسها (على سبيل المثال، مدة زيارة الصفحة).
          
           أنت تعني الفرد الذي يصل إلى الخدمة أو يستخدمها، أو الشركة أو أي كيان قانوني آخر يقوم هذا الفرد بالنيابة عنه بالوصول إلى الخدمة أو استخدامها، حسب الاقتضاء.
          
           جمع واستخدام بياناتك الشخصية
           أنواع البيانات التي تم جمعها
           بيانات شخصية
           أثناء استخدام خدمتنا، قد نطلب منك تزويدنا ببعض معلومات التعريف الشخصية التي يمكن استخدامها للاتصال بك أو التعرف عليك. قد تتضمن معلومات التعريف الشخصية، على سبيل المثال لا الحصر، ما يلي:
          
           عنوان البريد الإلكتروني
          
           الاسم الأول واسم العائلة
          
           رقم التليفون
          
           العنوان، الولاية، المقاطعة، الرمز البريدي/الرمز البريدي، المدينة
          
           بيانات الاستخدام
          
           بيانات الاستخدام
           يتم جمع بيانات الاستخدام تلقائيًا عند استخدام الخدمة.
          
           قد تتضمن بيانات الاستخدام معلومات مثل عنوان بروتوكول الإنترنت الخاص بجهازك (مثل عنوان IP)، ونوع المتصفح، وإصدار المتصفح، وصفحات خدمتنا التي تزورها، ووقت وتاريخ زيارتك، والوقت الذي تقضيه في تلك الصفحات، والجهاز الفريد المعرفات والبيانات التشخيصية الأخرى.
          
           عندما تصل إلى الخدمة عن طريق أو من خلال جهاز محمول، قد نقوم بجمع معلومات معينة تلقائيًا، بما في ذلك، على سبيل المثال لا الحصر، نوع الجهاز المحمول الذي تستخدمه، والمعرف الفريد لجهازك المحمول، وعنوان IP الخاص بجهازك المحمول، وهاتفك المحمول. نظام التشغيل ونوع متصفح الإنترنت عبر الهاتف المحمول الذي تستخدمه ومعرفات الجهاز الفريدة والبيانات التشخيصية الأخرى.
          
           يجوز لنا أيضًا جمع المعلومات التي يرسلها متصفحك عندما تزور خدمتنا أو عندما تصل إلى الخدمة عن طريق جهاز محمول أو من خلاله.
          
           معلومات من خدمات الوسائط الاجتماعية التابعة لجهات خارجية
           تسمح لك الشركة بإنشاء حساب وتسجيل الدخول لاستخدام الخدمة من خلال خدمات الوسائط الاجتماعية التابعة لجهات خارجية التالية:
          
           جوجل
           فيسبوك
           انستغرام
           تويتر
           ينكدين
           إذا قررت التسجيل من خلال خدمة وسائط اجتماعية تابعة لجهة خارجية أو منحتنا حق الوصول إليها، فقد نقوم بجمع البيانات الشخصية المرتبطة بك بالفعل

حساب خدمة الوسائط الاجتماعية لجهة خارجية، مثل اسمك أو عنوان بريدك الإلكتروني أو أنشطتك أو قائمة جهات الاتصال الخاصة بك المرتبطة بهذا الحساب.
          
           قد يكون لديك أيضًا خيار مشاركة معلومات إضافية مع الشركة من خلال حساب خدمة الوسائط الاجتماعية التابعة لجهة خارجية. إذا اخترت تقديم هذه المعلومات والبيانات الشخصية، أثناء التسجيل أو غير ذلك، فإنك تمنح الشركة الإذن باستخدامها ومشاركتها وتخزينها بطريقة تتفق مع سياسة الخصوصية هذه.
          
           المعلومات التي يتم جمعها أثناء استخدام التطبيق
           أثناء استخدام تطبيقنا، ومن أجل توفير ميزات تطبيقنا، قد نقوم بجمع، بعد الحصول على إذن مسبق منك:
          
           المعلومات المتعلقة بموقعك
          
           الصور والمعلومات الأخرى من كاميرا جهازك ومكتبة الصور
          
           نحن نستخدم هذه المعلومات لتوفير ميزات خدمتنا، ولتحسين خدمتنا وتخصيصها. قد يتم تحميل المعلومات على خوادم الشركة و/أو خادم مقدم الخدمة أو قد يتم تخزينها ببساطة على جهازك.
          
           يمكنك تمكين أو تعطيل الوصول إلى هذه المعلومات في أي وقت، من خلال إعدادات جهازك.
          
           استخدام بياناتك الشخصية
           يجوز للشركة استخدام البيانات الشخصية للأغراض التالية:
          
           لتوفير خدمتنا والحفاظ عليها، بما في ذلك مراقبة استخدام خدمتنا.
          
           لإدارة حسابك: لإدارة تسجيلك كمستخدم للخدمة. يمكن أن تمنحك البيانات الشخصية التي تقدمها إمكانية الوصول إلى وظائف مختلفة للخدمة المتاحة لك كمستخدم مسجل.
          
           لتنفيذ العقد: التطوير والامتثال والتعهد بعقد الشراء للمنتجات أو العناصر أو الخدمات التي اشتريتها أو أي عقد آخر معنا من خلال الخدمة.
          
           للاتصال بك: للاتصال بك عن طريق البريد الإلكتروني أو المكالمات الهاتفية أو الرسائل النصية القصيرة أو أي أشكال أخرى مماثلة من الاتصالات الإلكترونية، مثل إشعارات تطبيق الهاتف المحمول فيما يتعلق بالتحديثات أو الاتصالات الإعلامية المتعلقة بالوظائف أو المنتجات أو الخدمات المتعاقد عليها، بما في ذلك التحديثات الأمنية، عندما يكون ذلك ضروريا أو معقولا لتنفيذها.
          
           لتزويدك بالأخبار والعروض الخاصة والمعلومات العامة حول السلع والخدمات والأحداث الأخرى التي نقدمها والمشابهة لتلك التي اشتريتها بالفعل أو استفسرت عنها ما لم تكن قد اخترت عدم تلقي هذه المعلومات.
          
           لإدارة طلباتك: لحضور وإدارة طلباتك المقدمة إلينا.
          
           بالنسبة لعمليات نقل الأعمال: قد نستخدم معلوماتك لتقييم أو إجراء عملية دمج أو تصفية أو إعادة هيكلة أو إعادة تنظيم أو حل أو بيع أو نقل آخر لبعض أو كل أصولنا، سواء كمنشأة مستمرة أو كجزء من الإفلاس أو التصفية أو أو إجراء مماثل، حيث تكون البيانات الشخصية التي نحتفظ بها حول مستخدمي خدمتنا من بين الأصول المنقولة.
          
           لأغراض أخرى: قد نستخدم معلوماتك لأغراض أخرى، مثل تحليل البيانات وتحديد اتجاهات الاستخدام وتحديد فعالية حملاتنا الترويجية وتقييم وتحسين خدمتنا ومنتجاتنا وخدماتنا والتسويق وتجربتك.
          
           قد نشارك معلوماتك الشخصية في الحالات التالية:
          
           مع مقدمي الخدمة: قد نشارك معلوماتك الشخصية مع مقدمي الخدمة لمراقبة وتحليل استخدام خدمتنا، للاتصال بك.
           بالنسبة لعمليات نقل الأعمال: يجوز لنا مشاركة معلوماتك الشخصية أو نقلها فيما يتعلق أو أثناء المفاوضات بشأن أي اندماج أو بيع أصول الشركة أو تمويل أو الاستحواذ على كل أو جزء من أعمالنا لشركة أخرى.
           مع الشركات التابعة: قد نشارك معلوماتك مع الشركات التابعة لنا، وفي هذه الحالة سنطلب من تلك الشركات التابعة احترام سياسة الخصوصية هذه. تشمل الشركات التابعة شركتنا الأم وأي شركات فرعية أخرى أو شركاء في مشاريع مشتركة أو شركات أخرى نسيطر عليها أو تخضع لسيطرة مشتركة معنا.
           مع شركاء العمل: قد نشارك معلوماتك مع شركاء العمل لدينا لنقدم لك منتجات أو خدمات أو عروض ترويجية معينة.
           مع مستخدمين آخرين: عندما تشارك معلومات شخصية أو تتفاعل بطريقة أخرى في المناطق العامة مع مستخدمين آخرين، فقد يتم عرض هذه المعلومات من قبل جميع المستخدمين وقد يتم توزيعها للعامة في الخارج. إذا كنت تتفاعل مع مستخدمين آخرين أو قمت بالتسجيل من خلال خدمة وسائط اجتماعية تابعة لجهة خارجية، فقد ترى جهات الاتصال الخاصة بك على خدمة الوسائط الاجتماعية التابعة لجهة خارجية اسمك وملفك الشخصي وصورك ووصف نشاطك. وبالمثل، سيتمكن المستخدمون الآخرون من عرض أوصاف نشاطك والتواصل معك وعرض ملفك الشخصي.
           بموافقتك: يجوز لنا الكشف عن معلوماتك الشخصية لأي غرض آخر مع موافقتك.
           الاحتفاظ ببياناتك الشخصية
           ستحتفظ الشركة ببياناتك الشخصية فقط طالما كان ذلك ضروريًا للأغراض المنصوص عليها في سياسة الخصوصية هذه. سنحتفظ ببياناتك الشخصية ونستخدمها بالقدر اللازم للامتثال لالتزاماتنا القانونية (على سبيل المثال، إذا طُلب منا الاحتفاظ ببياناتك للامتثال للقوانين المعمول بها)، وحل النزاعات، وإنفاذ اتفاقياتنا وسياساتنا القانونية.
          
           ستحتفظ الشركة أيضًا ببيانات الاستخدام لأغراض التحليل الداخلي. يتم الاحتفاظ ببيانات الاستخدام عمومًا لفترة زمنية أقصر، إلا عندما يتم استخدام هذه البيانات لتعزيز الأمان أو لتحسين وظائف خدمتنا، أو عندما نكون ملزمين قانونًا بالاحتفاظ بهذه البيانات لفترات زمنية أطول.
          
           نقل بياناتك الشخصية
           تتم معالجة معلوماتك، بما في ذلك البيانات الشخصية، في مكاتب تشغيل الشركة وفي أي أماكن أخرى تتواجد فيها الأطراف المشاركة في المعالجة. وهذا يعني أنه قد يتم نقل هذه المعلومات إلى - والاحتفاظ بها - على أجهزة الكمبيوتر الموجودة خارج ولايتك أو مقاطعتك أو بلدك أو أي ولاية قضائية حكومية أخرى حيث قد تختلف قوانين حماية البيانات عن تلك الموجودة في ولايتك القضائية.
          
           إن موافقتك على سياسة الخصوصية هذه متبوعة بتقديمك لهذه المعلومات تمثل موافقتك على هذا النقل.
          
           ستتخذ الشركة جميع الخطوات الضرورية بشكل معقول لضمان التعامل مع بياناتك بشكل آمن ووفقًا لسياسة الخصوصية هذه ولن يتم نقل بياناتك الشخصية إلى منظمة أو دولة ما لم تكن هناك ضوابط كافية مطبقة بما في ذلك أمان بياناتك والمعلومات الشخصية الأخرى.
          
           احذف بياناتك الشخصية
           لديك الحق في حذف أو طلب المساعدة في حذف البيانات الشخصية التي جمعناها عنك.
          
           قد تمنحك خدمتنا القدرة على حذف معلومات معينة عنك من داخل الخدمة.
          
           يمكنك تحديث معلوماتك أو تعديلها أو حذفها في أي وقت عن طريق تسجيل الدخول إلى حسابك، إذا كان لديك حساب، وزيارة قسم إعدادات الحساب الذي يسمح لك بإدارة معلوماتك الشخصية. يمكنك أيضًا الاتصال بنا لطلب الوصول إلى أو تصحيح أو حذف أي معلومات شخصية قدمتها لنا.
          
           ومع ذلك، يرجى ملاحظة أننا قد نحتاج إلى الاحتفاظ بمعلومات معينة عندما يكون لدينا التزام قانوني أو أساس قانوني للقيام بذلك.
          
           الكشف عن بياناتك الشخصية
           المعاملات التجارية
           إذا كانت الشركة متورطة في عملية دمج أو استحواذ أو بيع أصول، فقد يتم نقل بياناتك الشخصية. سنقدم إشعارًا قبل نقل بياناتك الشخصية وقبل أن تصبح خاضعة لسياسة خصوصية مختلفة.
          
           تطبيق القانون
           في ظل ظروف معينة، قد يُطلب من الشركة الكشف عن بياناتك الشخصية إذا كان ذلك مطلوبًا بموجب القانون أو استجابة لطلبات صالحة من السلطات العامة (مثل المحكمة أو وكالة حكومية).
          
           المتطلبات القانونية الأخرى
           يجوز للشركة الكشف عن بياناتك الشخصية بحسن نية أن هذا الإجراء ضروري من أجل:
          
           الامتثال لالتزام قانوني
           حماية والدفاع عن حقوق أو ممتلكات الشركة
           منع أو التحقيق في أي مخالفات محتملة فيما يتعلق بالخدمة
           حماية السلامة الشخصية لمستخدمي الخدمة أو الجمهور
           الحماية من المسؤولية القانونية
           أمن بياناتك الشخصية
           يعد أمان بياناتك الشخصية أمرًا مهمًا بالنسبة لنا، ولكن تذكر أنه لا توجد طريقة نقل عبر الإنترنت أو طريقة تخزين إلكترونية آمنة بنسبة 100%. بينما نسعى جاهدين لاستخدام وسائل مقبولة تجاريًا لحماية بياناتك الشخصية، لا يمكننا ضمان أمانها المطلق.
          
           خصوصية الأطفال
           لا تتناول خدمتنا أي شخص يقل عمره عن 13 عامًا. نحن لا نجمع معلومات التعريف الشخصية عن قصد من أي شخص يقل عمره عن 13 عامًا. إذا كنت أحد الوالدين أو الوصي وكنت على علم بأن طفلك قد زودنا ببيانات شخصية، فيرجى اتصل بنا. إذا علمنا أننا قمنا بجمع بيانات شخصية من أي شخص يقل عمره عن 13 عامًا دون التحقق من موافقة الوالدين، فإننا نتخذ خطوات لإزالة تلك المعلومات من خوادمنا.
          
           إذا كنا بحاجة إلى الاعتماد على الموافقة كأساس قانوني لمعالجة معلوماتك وكان بلدك يتطلب موافقة أحد الوالدين، فقد نطلب موافقة والديك قبل أن نقوم بجمع تلك المعلومات واستخدامها.
          
           روابط لمواقع أخرى
           قد تحتوي خدمتنا على روابط لمواقع أخرى لا نقوم بإدارتها. إذا نقرت على رابط طرف ثالث، فسيتم توجيهك إلى موقع الطرف الثالث. ننصحك بشدة بمراجعة سياسة الخصوصية لكل موقع تزوره.
ليس لدينا أي سيطرة ولا نتحمل أي مسؤولية عن المحتوى أو سياسات الخصوصية أو الممارسات الخاصة بأي مواقع أو خدمات تابعة لجهات خارجية.
          
           التغييرات على سياسة الخصوصية هذه
           قد نقوم بتحديث سياسة الخصوصية الخاصة بنا من وقت لآخر. وسوف نقوم بإعلامك بأي تغييرات عن طريق نشر سياسة الخصوصية الجديدة على هذه الصفحة.
          
           سنخبرك عبر البريد الإلكتروني و/أو إشعار بارز على خدمتنا، قبل أن يصبح التغيير ساري المفعول ونقوم بتحديث تاريخ "آخر تحديث" في الجزء العلوي من سياسة الخصوصية هذه.
          
           يُنصح بمراجعة سياسة الخصوصية هذه بشكل دوري لمعرفة أي تغييرات. تصبح التغييرات التي يتم إجراؤها على سياسة الخصوصية هذه فعالة عند نشرها على هذه الصفحة.
          
           اتصل بنا
           إذا كانت لديك أي أسئلة حول سياسة الخصوصية هذه، يمكنك الاتصال بنا:
          
           عبر البريد الإلكتروني: support@liklok.live ''')
            ],
          ),
        ),
      ),
    );
  }
}
