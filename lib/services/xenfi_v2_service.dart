import 'dart:convert';
import 'package:http/http.dart' as http;

class XenfiV2Service {
  static const String proxyBase = "https://sky-tech-proxy.workers.dev";
  
  Future<List<dynamic>> getLivePackages() async {
    try {
      final res = await http.get(Uri.parse("$proxyBase/packages"));
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        return data['packages'] ?? data['data'] ?? data;
      }
    } catch(e){ print(e); }
    return [
      {"id":"half_day_chill","name":"Half Day Chill","price":500,"duration":"6 Hours","speed":"125 Mbps"},
      {"id":"live_vip","name":"Live stream VIP","price":800,"duration":"12 Hours","speed":"125 Mbps"},
      {"id":"24h","name":"24 Hours","price":1000,"duration":"24 Hours","speed":"125 Mbps","popular":true},
      {"id":"super_vip","name":"Supper Fast VIP","price":1500,"duration":"24 Hours","speed":"125 Mbps"},
    ];
  }

  Future<Map> initiateMoMo({required String phone, required String packageId}) async {
    final res = await http.post(Uri.parse("$proxyBase/pay"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({"phone":phone,"package_id":packageId,"router":"sky_tech"}));
    return jsonDecode(res.body);
  }

  String autoLoginUrl(String voucher) => "http://sky.tech/login?card=$voucher";
}