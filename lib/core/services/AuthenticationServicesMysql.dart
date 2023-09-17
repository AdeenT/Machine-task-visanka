import 'package:flutter/foundation.dart';
import 'package:ourESchool/imports.dart';

import 'httpservices.dart';

class AuthenticationServicesMysql extends Services {


  bool isUserLoggedIn = false;
  UserType userType = UserType.STUDENT;


  // StreamController<User> fireBaseUserStream = StreamController<User>();
  StreamController<user> mdbUserStream = StreamController<user>();
  StreamController<bool> isUserLoggedInStream = StreamController<bool>();
  StreamController<UserType> userTypeStream = StreamController<UserType>();


  ProfileServices _profileServices = locator<ProfileServices>();


  AuthenticationServicesMysql() : super() {
    if (!kIsWeb) firestore.settings = Settings(persistenceEnabled: true);  // (For Web)
    isLoggedin().then((onValue) => isUserLoggedIn = onValue);
    _userType().then((onValue) => userType = onValue);
  }


  Future<bool> isLoggedin() async {
    await getMdbUser();
    mdbUserStream.add(mdbUser!);
    isUserLoggedIn = mdbUser == null ? false : true;
    isUserLoggedInStream.add(isUserLoggedIn);
    if (isUserLoggedIn) _profileServices.getLoggedInUserProfileData();
    print(isUserLoggedIn.toString() + 'here');
    return isUserLoggedIn;
  }


  Future<UserType> _userType() async {
    userType = await sharedPreferencesHelper.getUserType();
    userTypeStream.add(userType);
    return userType;
  }


  Future checkDetails({required String schoolCode, required String email, required String password, required UserType userType,}) async {
      await sharedPreferencesHelper.clearAllData();
      bool isSchoolPresent = true;
      bool isUserAvailable = true;
      String loginType = userType == UserType.STUDENT ? "Student" : userType == UserType.TEACHER ? "Parent-Teacher" : "Parent-Teacher";
      DocumentReference _schoolLoginRef = schoolRef.collection(schoolCode.toUpperCase().trim()).doc('Login'); //    abcd
      await _schoolLoginRef.get().then((onValue) {
        isSchoolPresent = onValue.exists;
        print("Inside Then :" + onValue.data.toString());
      });

      if (!isSchoolPresent) {
        print('School Not Found');
        return ReturnType.SCHOOLCODEERROR;
      } else {
        print('School Found');
      }

      CollectionReference _userRef = _schoolLoginRef.collection(loginType);

      await _userRef.where("email", isEqualTo: email).snapshots().first.then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          isUserAvailable = documentSnapshot.exists;
          print("User Data : " + documentSnapshot.data.toString());
          if (userType == UserType.STUDENT) {
            userDataLogin = UserDataLogin(
              email: documentSnapshot["email"].toString(),
              id: documentSnapshot["id"].toString(),
              parentIds:
              documentSnapshot["parentId"] as Map<dynamic,dynamic>,
            );
          } else {
            userDataLogin = UserDataLogin(
              email: documentSnapshot["email"].toString(),
              id: documentSnapshot["id"].toString(),
              isATeacher: documentSnapshot["isATeacher"] as bool,
              childIds:
              documentSnapshot["childId"].toString(),
            );
          }
        });
      });

      if (!isUserAvailable) {
        print('User Not Found');
        return ReturnType.EMAILERROR;
      } else {
        print('User Found');
        userDataLogin.setData();
      }

      sharedPreferencesHelper.setLoggedInUserId(userDataLogin.id??'');

      if (userType == UserType.STUDENT) {
        this.userType = userType;
        userTypeStream.add(userType);
        sharedPreferencesHelper.setUserType(UserType.STUDENT);
      } else {
        if (userDataLogin.isATeacher??false) {
          this.userType = UserType.TEACHER;
          userTypeStream.add(this.userType);
          sharedPreferencesHelper.setUserType(this.userType);
        } else {
          this.userType = UserType.PARENT;
          userTypeStream.add(this.userType);
          sharedPreferencesHelper.setUserType(this.userType);
        }
      }

      return ReturnType.SUCCESS;
  }


  Future emailPasswordRegisterMySQL(String email, String password, UserType userType, String schoolCode) async{
      try{
        AuthErrors authErrors = AuthErrors.UNKNOWN; // as it is
        await http_post("/createUserWithEmailAndPassword",{"email" : email, "password":password});
        getMdbUser(); // get user
        authErrors = AuthErrors.SUCCESS;
        sharedPreferencesHelper.setSchoolCode(schoolCode);
        print("User Regestered using Email and Password");
        isUserLoggedIn = true;
        isUserLoggedInStream.add(isUserLoggedIn);
        mdbUserStream.add(mdbUser!); // add user
        return authErrors;
      } on Exception catch (e){
        catchException(e);
      }
  }


  Future<AuthErrors> emailPasswordSignInMySQL(String email, String password, UserType userType, String schoolCode) async {
      try
      {
        AuthErrors authErrors = AuthErrors.UNKNOWN;
        await http_post("/signInWithEmailAndPassword", {"email": email, "password": password});
        getMdbUser();
        authErrors = AuthErrors.SUCCESS;
        sharedPreferencesHelper.setSchoolCode(schoolCode);
        print("User Loggedin using Email and Passwor");
        isUserLoggedIn = true;
        mdbUserStream.sink.add(mdbUser!);
        isUserLoggedInStream.add(isUserLoggedIn);
        return authErrors;
      }
      on PlatformException
      catch (e) {
        return catchException(e);
      }
  }


  logoutMethod() async {
      await auth.signOut();
      isUserLoggedIn = false;
      isUserLoggedInStream.add(false);
      mdbUserStream.add(user());
      userTypeStream.add(UserType.UNKNOWN);
      await sharedPreferencesHelper.clearAllData();
      print("User Loged out");
  }


  Future<AuthErrors> passwordReset(String email) async {
      try {
        AuthErrors authErrors = AuthErrors.UNKNOWN;
        await auth.sendPasswordResetEmail(email: email);
        authErrors = AuthErrors.SUCCESS;
        print("Password Reset Link Send");
        return authErrors;
      } on PlatformException catch (e) {
        return catchException(e);
      }
  }


  // Exceptions

  AuthErrors catchException(Exception e) {
    AuthErrors errorType = AuthErrors.UNKNOWN;
    if (e is PlatformException) {
      if (Platform.isIOS) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = AuthErrors.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = AuthErrors.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = AuthErrors.NetworkError;
            break;
          case 'Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later':
            errorType = AuthErrors.TOOMANYATTEMPTS;
            break;
        // ...
          default:
            print('Case iOS ${e.message} is not yet implemented');
        }
      } else if (Platform.isAndroid) {
        switch (e.code) {
          case 'Error 17011':
            errorType = AuthErrors.UserNotFound;
            break;
          case 'Error 17009':
          case 'ERROR_WRONG_PASSWORD':
            errorType = AuthErrors.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = AuthErrors.NetworkError;
            break;
        // ...
          default:
            print('Case Android ${e.message} ${e.code} is not yet implemented');
        }
      }
    }

    print('The error is $errorType');
    return errorType;
  }
}