// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }

//   runApp(new MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     android: AndroidInAppWebViewOptions(
//       useHybridComposition: true,
//     ),
//   );

//   listener( e) {
//    print(e);
//    print(jsonDecode((e).data as String));
//  }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(title: Text("JavaScript Handlers")),
//           body: SafeArea(
//               child: Column(children: <Widget>[
//             Expanded(
//               child: InAppWebView(

//                 initialUrlRequest: URLRequest(url: Uri.parse(
//                     // "https://abhishekak048.github.io/abhishek048.github.io/"
//                     "https://create-react-app-one-phi-85.vercel.app/"
//                     // "https://posappstaging.insurancedekho.com/"
//                     )),

// //                     initialData: InAppWebViewInitialData(
// //                         data: """
// // <!DOCTYPE html>
// // <html lang="en">
// //     <head>
// //         <meta charset="UTF-8">
// //         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
// //     </head>
// //     <body>
// //         <h1>JavaScript Handlers</h1>
// //         <script>
// //             window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
// //                 window.flutter_inappwebview.callHandler('test',"hello bro hi")
// //                   .then(function(result) {
// //                     // print to the console the data coming
// //                     // from the Flutter side.
// //                     console.log(JSON.stringify(result));

// //                     window.flutter_inappwebview
// //                       .callHandler('test', 1, true, ['bar', 5], {foo: 'baz'}, result);
// //                 });
// //             });
// //         </script>
// //     </body>
// // </html>
// //                       """
// //                 ),
//                 initialOptions: options,
//                 onWebViewCreated: (controller) {

//                   // controller.addJavaScriptHandler(
//                   //     handlerName: 'mobileLoginForCaptchaResponse',
//                   //     callback: (args) {
//                   //       // return data to the JavaScript side!
//                   //       print("addJavaScriptHandlerfirst");

//                   //       return {'bar': 'bar_value', 'baz': 'baz_value'};
//                   //     });
//                   controller.addJavaScriptHandler(
//                       handlerName: 'handlerFoo',
//                       callback: (args) {
//                         print("addJavaScriptHandler$args");
//                         // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
//                       });
//                 },
//                 onConsoleMessage: (controller, consoleMessage) {
//                   print("consoleMessage$consoleMessage");

//                   // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
//                 },
//               ),
//             ),
//           ]))),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

WebViewController? webViewctrl;

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  var sessionCookie = WebViewCookie(
    name: 'https://posappstaging.insurancedekho.com/',
    value: 'showMobileLoginForCaptcha',
    domain: 'true',
  );

  @override
  Widget build(BuildContext context) {
    _controller.future.then((controller) {
      webViewctrl = controller;
      Map<String, String> header = {'showMobileLoginForCaptcha': 'true'};
      webViewctrl?.loadUrl('https://posappstaging.insurancedekho.com/',
          headers: header);
    });
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example'),
            actions: <Widget>[
              //MenuList(_controller.future),
            ],
          ),
          body: Builder(builder: (BuildContext context) {
            return WebView(
              
              initialUrl: 'https://posappstaging.insurancedekho.com/',
           
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                webViewctrl = webViewController;
              },
              javascriptChannels: <JavascriptChannel>[
                _scanBarcode(context),
                _scanBarcode2(context),
                _scanBarcode3(context),
              ].toSet(),
              onPageFinished: (String url) {
                //TODO : events after page loading finished

              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // webViewctrl.evaluateJavascript(
              //     "scanBarcode('123')");
            },
            child: Icon(Icons.navigation),
            backgroundColor: Colors.green,
          )),
    );
  }
}
void setSession(String sessionId, WebViewController webViewController) async {
  if (Platform.isIOS) {
   await webViewController.runJavascriptReturningResult("showMobileLoginForCaptcha = 'ASP.NET_SessionId=$sessionId'");
  } else {
   await webViewController.runJavascriptReturningResult('document.cookie = "ASP.NET_SessionId=$sessionId; path=/"');
  }
 }
JavascriptChannel _scanBarcode(BuildContext context) {
  return JavascriptChannel(
      name: 'MobileLoginForCaptchaResponse',
      onMessageReceived: (JavascriptMessage message) {
        print("Barcode++++++++++++++${message.message}");
        /*String result = scanBarcode(context);
        ******I got result of scanned barcode in result variable*******/
      });
}

JavascriptChannel _scanBarcode2(BuildContext context) {
  return JavascriptChannel(
      name: 'mobileLoginForCaptchaResponse',
      onMessageReceived: (JavascriptMessage message) {
        print("Barcode++++++++++++++${message.message}");
        /*String result = scanBarcode(context);
        ******I got result of scanned barcode in result variable*******/
      });
}

JavascriptChannel _scanBarcode3(BuildContext context) {
  return JavascriptChannel(
      name: 'Event3',
      onMessageReceived: (JavascriptMessage message) {
        print("Barcode++++++++++++++${message.message}");
        /*String result = scanBarcode(context);
        ******I got result of scanned barcode in result variable*******/
      });
}
