import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobileapp_project/app/pages/mappage.dart';

class MarkerController {

  deleteAtPath({required dynamic marker}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'recursiveDelete',
      options: HttpsCallableOptions(timeout: Duration(seconds: 9)));


    var data = Map<dynamic, dynamic>();
    data["path"] = "$marker";

    await callable.call(data);



  }



}