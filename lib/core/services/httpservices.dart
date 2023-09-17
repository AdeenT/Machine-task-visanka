import 'dart:convert';
import 'package:http/http.dart' as http;

const PROTOCOL = "http";
const DOMAIN = "localhost:3000"; // (RESPECTIVE DOMAIN)

Future http_get(String route, [dynamic data]) async{
  var datastr = jsonEncode(data);
  print(datastr);
  var url = '$PROTOCOL://$DOMAIN/api/users/$route?data=$datastr';
  var result = await http.get(Uri.parse(url));
  return jsonDecode(result.body);
}

Future http_post(String route, [dynamic data]) async{
  var url = "$PROTOCOL://$DOMAIN/api/users/$route";
  var datastr = jsonEncode(data);
  var result = await http.post(Uri.parse(url), body: datastr,headers: {"Content-Type":"application/json"});
  return jsonDecode(result.body);
}