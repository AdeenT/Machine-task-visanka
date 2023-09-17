import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ourESchool/core/services/Services.dart';

class StorageServices extends Services {
  StorageServices() {
    getMdbUser(); // getMdbUser
    getSchoolCode();
  }

  Future<String> setProfilePhoto(String filePath) async {
    if (mdbUser == null) await getMdbUser();
    if (schoolCode == null) await getSchoolCode();
    // String schoolCode = await sharedPreferencesHelper.getSchoolCode();

    String _extension = p.extension(filePath);
    String fileName = mdbUser!.id! + _extension;
    final UploadTask uploadTask = storageReference
        .child(schoolCode! + '/' + "Profile" + '/' + fileName)
        .putFile(
          File(filePath),
          SettableMetadata(
            contentType: "image",
            customMetadata: {
              "uploadedBy": mdbUser!.id ?? '',
            },
          ),
        );

    final TaskSnapshot downloadUrl = await uploadTask.snapshot;
    final String profileUrl = await downloadUrl.ref.getDownloadURL();

    await sharedPreferencesHelper.setLoggedInUserPhotoUrl(profileUrl);

    return profileUrl;
  }

  Future<String> uploadAnnouncemantPhoto(
      String filePath, String fileName) async {
    if (schoolCode == null) await getSchoolCode();
    if (mdbUser == null) await getMdbUser();

    final UploadTask uploadTask = storageReference
        .child(schoolCode! + "/" + "Posts" + '/' + fileName)
        .putFile(
          File(filePath),
          SettableMetadata(
            contentType: "image",
            customMetadata: {
              "uploadedBy": mdbUser!.id ?? '',
            },
          ),
        );

    final TaskSnapshot downloadUrl = await uploadTask.snapshot;
    final String postmageUrl = await downloadUrl.ref.getDownloadURL();

    return postmageUrl;
  }

  Future<String> uploadAssignment(String filePath, String fileName) async {
    if (schoolCode == null) await getSchoolCode();
    if (mdbUser == null) await getMdbUser();

    String _extension = p.extension(filePath);
    String file = fileName + _extension;

    final UploadTask uploadTask = storageReference
        .child(schoolCode! + "/" + "Assignments" + '/' + file)
        .putFile(
          File(filePath),
          SettableMetadata(
            contentType: "PDF",
            customMetadata: {
              "uploadedBy": mdbUser!.id ?? "",
            },
          ),
        );

    final TaskSnapshot downloadUrl = await uploadTask.snapshot;
    final String postmageUrl = await downloadUrl.ref.getDownloadURL();

    return postmageUrl;
  }
}
