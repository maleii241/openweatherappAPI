import 'package:flutter/material.dart';
import 'package:flutter_weather/components/API_textfield.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/screens/search_screen.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  String version;

  TextEditingController weatherKeyTextController;

  String defaultLocationText = "";
  String APIKey = "";

  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    weatherKeyTextController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var info = await SharedPrefs.getDefaultLocation();
    var userOwmKey = await SharedPrefs.getOpenWeatherAPIKey();

    weatherKeyTextController = TextEditingController(text: userOwmKey);

    weatherKeyTextController.addListener(() async {
      await SharedPrefs.setOpenWeatherAPIKey(
          weatherKeyTextController.text.trim());
    });

    setState(() {
      version = packageInfo.version;
      defaultLocationText = info[0];
      weatherKeyTextController.text = userOwmKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: TextButton(
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.primaryTextColor(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        brightness: ThemeColors.isDark ? Brightness.dark : Brightness.light,
        title: Text(
          Language.getTranslation("advancedSettings"),
          style: TextStyle(color: ThemeColors.primaryTextColor()),
        ), //Language.getTranslation("advancedSettings")
        centerTitle: true,
        backgroundColor: ThemeColors.backgroundColor(),
      ),
      backgroundColor: ThemeColors.backgroundColor(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [

              Card(
                shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                color: ThemeColors.cardColor(),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.app_settings_alt_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      title: Text(
                        Language.getTranslation("APIKey"),
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: weatherKeyTextController,
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                        decoration: InputDecoration(
                          hintText: Language.getTranslation("owmKey"),
                          hintStyle: TextStyle(
                            color: ThemeColors.secondaryTextColor(),
                            fontSize: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeColors.secondaryTextColor(),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeColors.secondaryTextColor(),
                                width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          Language.getTranslation("customKeyInfo"),
                          style: TextStyle(
                              color: ThemeColors.secondaryTextColor()),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        const url =
                            "https://home.openweathermap.org/users/sign_up";
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Text(
                        Language.getTranslation("getAKey"),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
