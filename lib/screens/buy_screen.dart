import 'package:flutter/material.dart';
import '../services/xenfi_v2_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyScreen extends StatefulWidget { @override _BuyScreenState createState() => _BuyScreenState(); }
class _BuyScreenState extends State<BuyScreen> {
  List packages=[]; bool loading=true; String selectedId="24h";
  @override void initState(){ super.initState(); load(); }
  load() async { var p=await XenfiV2Service().getLivePackages(); setState((){packages=p; loading=false; if(p.isNotEmpty) selectedId=p[0]['id'];}); }
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF05070D), appBar: AppBar(title: Text("Buy Voucher"), backgroundColor: Color(0xFF0A1428)),
      body: loading? Center(child: CircularProgressIndicator()): ListView(padding: EdgeInsets.all(16), children: [
        Text("Select Voucher - Live from XenFi App", style: TextStyle(color: Color(0xFF7DD3FF))),
        SizedBox(height:10),
        ...packages.map((pkg){
          bool sel=selectedId==pkg['id'];
          return GestureDetector(onTap: ()=>setState(()=>selectedId=pkg['id']),
            child: Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: sel?Color(0xFFFFEB3B):Colors.white24), borderRadius: BorderRadius.circular(12), color: sel?Color(0xFF1A2744):Color(0xFF0A1428)),
              child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("${pkg['price']} UGX • ${pkg['duration']}", style: TextStyle(fontWeight: FontWeight.bold)), Text("${pkg['name']} • ${pkg['speed']}", style: TextStyle(fontSize:11))])), if(sel) Icon(Icons.check_circle, color: Color(0xFFFFEB3B))])));
        }).toList(),
        SizedBox(height:20),
        ElevatedButton(onPressed: () async {
          var ctrl=TextEditingController(text:"256");
          var phone = await showDialog(context: context, builder: (c)=> AlertDialog(title: Text("MTN MoMo Number"), content: TextField(controller: ctrl, keyboardType: TextInputType.phone), actions: [TextButton(onPressed: ()=>Navigator.pop(c, ctrl.text), child: Text("Pay"))]));
          if(phone==null) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Initiating MoMo via XenFi... Check phone")));
          var res = await XenfiV2Service().initiateMoMo(phone: phone, packageId: selectedId);
          if(res['voucher']!=null){
            String url = XenfiV2Service().autoLoginUrl(res['voucher']);
            Navigator.push(context, MaterialPageRoute(builder: (_)=> Scaffold(appBar: AppBar(title: Text("Connecting...")), body: WebViewWidget(controller: WebViewController()..loadRequest(Uri.parse(url))))));
          }
        }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFEB3B), padding: EdgeInsets.symmetric(vertical:16)), child: Text("Pay with MTN MoMo", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}