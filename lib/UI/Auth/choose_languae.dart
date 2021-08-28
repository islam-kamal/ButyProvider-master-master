import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/UI/Auth/intro.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Languages extends StatefulWidget {
  final GlobalKey navKey;

  const Languages({Key key, this.navKey}) : super(key: key);

  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage=="ar"?TextDirection.rtl :TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.contain,
              width: 100,
              height: 30,
            )),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                allTranslations.text("welcome"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Center(
                    child: Text(
                      allTranslations.text("quot"),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  allTranslations.text("choose_lang"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () async {
                  changeLang("ar");
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            allTranslations.currentLanguage == "ar"
                                ? Icon(Icons.radio_button_checked)
                                : Icon(Icons.radio_button_unchecked),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text( allTranslations.text("ar")),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/images/sa_flag.png"),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              InkWell(
                onTap: () => changeLang("en"),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            allTranslations.currentLanguage == "en"
                                ? Icon(Icons.radio_button_checked)
                                : Icon(Icons.radio_button_unchecked),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text( allTranslations.text("en")),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/images/us_flag.png"),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: CustomButton(
                  onBtnPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Intro()));
                  },
                  text:  allTranslations.text("confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeLang(String lang) async {
    allTranslations.setNewLanguage(
     '${lang}',
      true,
      context,

    );
    MyApp.setLocale(context, Locale('${lang}'));

  }
}
