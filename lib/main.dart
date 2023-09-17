import 'package:flutter/foundation.dart';

import 'imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  timeDilation = 2;
  await Firebase.initializeApp();                                               // Firebase
  if (kIsWeb) await FirebaseFirestore.instance.enablePersistence();             // Web only method

  Provider.debugCheckInvalidValueType = null;                                   // Provider
  setupLocator();                                                               // setupLocator
  runApp(
    MyApp(),
  );  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(                                                       // MultiProvider
      providers: [
        StreamProvider<AppUser>.value(                                          // StreamProvider
          initialData: AppUser(),                                               // AppUser
          value: locator<ProfileServices>().loggedInUserStream.stream,          // locator
        ),
        StreamProvider<user?>.value(                                             // StreamProvider
          initialData: null,
          value: locator<AuthenticationServicesMysql>()
              .mdbUserStream
              .stream
              .asBroadcastStream(),
        ),
        StreamProvider<UserType>.value(
          initialData: UserType.UNKNOWN,
          value: locator<AuthenticationServicesMysql>().userTypeStream.stream,
        ),
        StreamProvider<bool>.value(
          initialData: false,
          value: locator<AuthenticationServicesMysql>().isUserLoggedInStream.stream,
        ),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          fontFamily: "Nunito",
          primaryColor: Colors.red,
           primaryColorLight: Colors.redAccent,
          primaryColorDark: Color(0xff0029cb),
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) => OurSchoolApp(
          theme: theme,
        ),
      ),
    );
  }
}

class OurSchoolApp extends StatelessWidget {

  const OurSchoolApp({
     Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our E-School',
      theme: theme,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Home.id: (context) => Home(),
        ProfilePage.id: (context) => ProfilePage(),
        GuardianProfilePage.id: (context) => GuardianProfilePage(
              title: 'Guardian Profile',
            ),
      },
      home: getHome(context),
    );
  }

  Widget getHome(BuildContext context) {
    AppUser currentUser = Provider.of<AppUser>(context, listen: false);
    UserType userType = Provider.of<UserType>(context, listen: false);

    // if (Provider.of<FirebaseUser>(context, listen: false) == null &&
    //     userType == UserType.UNKNOWN) {
    //       print("here");
    //   return WelcomeScreen();
    // }

    // if (userType == UserType.UNKNOWN) {
    //   return WelcomeScreen();
    // }

    if (Provider.of<bool>(context, listen: false)) {
      if (userType == UserType.STUDENT) {
        return currentUser.isEmpty() ? ProfilePage() : Home();
      } else {
        return Home();
      }
    } else {
      return WelcomeScreen();
    }
  }
}
