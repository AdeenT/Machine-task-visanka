import 'package:ourESchool/core/Server.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../imports.dart';
import 'httpservices.dart';

class user {
  String? id;
  String? email;

  user({this.id, this.email});
}

abstract class Services {
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  static String country =
      "India"; //Get this from firstScreen(UI Not developed yet)
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //User firebaseUser;  // user variable declared

  //String MDBUser, mdbUser;

  user? mdbUser;

  AppUser? _user;

  UserDataLogin userDataLogin = UserDataLogin();

  String? schoolCode = null;

  final Reference _storageReference =
      FirebaseStorage.instance.ref().child(country);

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  String baseUrl = Server.baseUrl;

  String webApiUrl = Server.baseUrl + Server.webApi;

  String profileUpdateUrl =
      Server.baseUrl + Server.webApi + Server.profileUpdate;

  String getProfileDataUrl =
      Server.baseUrl + Server.webApi + Server.getProfileData;

  String postAnnouncemnetUrl =
      Server.baseUrl + Server.webApi + Server.postAnnouncement;

  String addAssignmentUrl =
      Server.baseUrl + Server.webApi + Server.addAssignment;

  DocumentReference _schoolRef = _firestore.collection('Schools').doc(country);

  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;
  AppUser? get loggedInUser => _user;

  DocumentReference get schoolRef => _schoolRef;

  Future<CollectionReference> schoolRefwithCode() async =>
      _schoolRef.collection((await getSchoolCode())!.toUpperCase().trim());

  Reference get storageReference => _storageReference;

  SharedPreferencesHelper get sharedPreferencesHelper =>
      _sharedPreferencesHelper;

  /*getFirebaseUser() async {
    firebaseUser = _auth.currentUser;
  }*/
  /*Future<dynamic> _auth() async{
     await http.post("/getLoginUser",);
  }*/
  //_auth function => return String currentUser, bool isLoggedIn

  getMdbUser() async {
    var _auth = await http_get('getUser');
    /*var in_users = _auth as List<dynamic>;
    in_users.forEach((in_user) {User(id : in_user['id'], email : in_user['email']);});*/
    for (var e in _auth) {
      mdbUser = user(id: e["id"].toString(), email: e["email"]);
    }
    //MDBUser = _auth.email;
  }

  /*userData(String email, String password) async {
    var _auth = await http_post('getLoginUser', {"email" : email, "password":password});
    MDBUser = _auth.email;
  }
  getMDBUser() async {
    mdbUser = userData.email // email
  }*/

  Future<String?> getSchoolCode() async {
    schoolCode = await _sharedPreferencesHelper.getSchoolCode();
    return schoolCode;
  }
}
