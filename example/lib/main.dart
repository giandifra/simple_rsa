import 'package:flutter/material.dart';
import 'package:simple_rsa/simple_rsa.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple RSA Encryption',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  final PUBLIC_KEY =
      "MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBuAGGBgg9nuf6D2c5AIHc8" +
          "vZ6KoVwd0imeFVYbpMdgv4yYi5obtB/VYqLryLsucZLFeko+q1fi871ZzGjFtYXY" +
          "9Hh1Q5e10E5hwN1Tx6nIlIztrh5S9uV4uzAR47k2nng7hh6vuZ33kak2hY940RSL" +
          "H5l9E5cKoUXuQNtrIKTS4kPZ5IOUSxZ5xfWBXWoldhe+Nk7VIxxL97Tk0BjM0fJ3" +
          "8rBwv3++eAZxwZoLNmHx9wF92XKG+26I+gVGKKagyToU/xEjIqlpuZ90zesYdjV+" +
          "u0iQjowgbzt3ASOnvJSpJu/oJ6XrWR3egPoTSx+HyX1dKv9+q7uLl6pXqGVVNs+/" +
          "AgMBAAE=";

  final PRIVATE_KEY =
      "MIIEoQIBAAKCAQBuAGGBgg9nuf6D2c5AIHc8vZ6KoVwd0imeFVYbpMdgv4yYi5ob" +
          "tB/VYqLryLsucZLFeko+q1fi871ZzGjFtYXY9Hh1Q5e10E5hwN1Tx6nIlIztrh5S" +
          "9uV4uzAR47k2nng7hh6vuZ33kak2hY940RSLH5l9E5cKoUXuQNtrIKTS4kPZ5IOU" +
          "SxZ5xfWBXWoldhe+Nk7VIxxL97Tk0BjM0fJ38rBwv3++eAZxwZoLNmHx9wF92XKG" +
          "+26I+gVGKKagyToU/xEjIqlpuZ90zesYdjV+u0iQjowgbzt3ASOnvJSpJu/oJ6Xr" +
          "WR3egPoTSx+HyX1dKv9+q7uLl6pXqGVVNs+/AgMBAAECggEANG9qC1n8De3TLPa+" +
          "IkNXk1SwJlUUnAJ6ZCi3iyXZBH1Kf8zMATizk/wYvVxKHbF1zTyl94mls0GMmSmf" +
          "J9+Hlguy//LgdoJ9Wouc9TrP7BUjuIivW8zlRc+08lIjD64qkfU0238XldORXbP8" +
          "2BKSQF8nwz97WE3YD+JKtZ4x83PX7hqC9zabLFIwFIbmJ4boeXzj4zl8B7tjuAPq" +
          "R3JNxxKfvhpqPcGFE2Gd67KJrhcH5FIja4H/cNKjatKFcP6qNfCA7e+bua6bL0Cy" +
          "DzmmNSgz6rx6bthcJ65IKUVrJK6Y0sBcNQCAjqZDA0Bs/7ShGDL28REuCS1/udQz" +
          "XyB7gQKBgQCrgy2pvqLREaOjdds6s1gbkeEsYo7wYlF4vFPg4sLIYeAt+ed0kn4N" +
          "dSmtp4FXgGyNwg7WJEveKEW7IEAMQBSN0KthZU4sK9NEu2lW5ip9Mj0uzyUzU4lh" +
          "B+zwKzZCorip/LIiOocFWtz9jwGZPCKC8expUEbMuU1PzlxrytHJaQKBgQCkMEci" +
          "EHL0KF5mcZbQVeLaRuecQGI5JS4KcCRab24dGDt+EOKYchdzNdXdM8gCHNXb8RKY" +
          "NYnHbCjheXHxV9Jo1is/Qi9nND5sT54gjfrHMKTWAtWKAaX55qKG0CEyBB87WqJM" +
          "Ydn7i4Rf0rsRNa1lbxQ+btX14d0xol9313VC5wKBgERD6Rfn9dwrHivAjCq4GXiX" +
          "vr0w2V3adD0PEH+xIgAp3NXP4w0mBaALozQoOLYAOrTNqaQYPE5HT0Hk2zlFBClS" +
          "BfS1IsE4DFYOFiZtZDoClhGch1z/ge2p/ue0+1rYc5HNL4WqL/W0rcMKeYNpSP8/" +
          "lW5xckyn8Jq0M1sAFjIJAoGAQJvS0f/BDHz6MLvQCelSHGy8ZUscm7oatPbOB1xD" +
          "62UGvCPu1uhGfAqaPrJKqTIpoaPqmkSvE+9m4tsEUGErph9o4zqrJqRzT/HAmrTk" +
          "Ew/8PU7eMrFVW9I68GvkNCdVFukiZoY23fpXu9FT1YDW28xrHepFfb1EamynvqPl" +
          "O88CgYAvzzSt+d4FG03jwObhdZrmZxaJk0jkKu3JkxUmav9Zav3fDTX1hYxDNTLi" +
          "dazvUFfqN7wqSSPqajQmMoTySxmLI8gI4qC0QskB4lT1A8OfmjcDwbUzQGam5Kpz" +
          "ymmKJA9DgQpPgEIjHAnw2dUDR+wI/Loywb0AGLIbszseCOlc2Q==";

  final myController = TextEditingController();
  String _stringEncoded = '';

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Simple RSA Encryption"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: "Write the text to be encrypted",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child:
                      _stringEncoded.isEmpty ? Text("ENCODE") : Text("DECODE"),
                  color: Colors.yellow,
                  onPressed: () async {
                    String tmp = "";
                    try {
                      if (_stringEncoded.isEmpty) {
                        final text = myController.text;
                        if (text.isNotEmpty) {
                          final tmp = await encryptString(
                              myController.text, PUBLIC_KEY);
                          setState(() {
                            _stringEncoded = tmp;
                            myController.clear();
                          });
                        }
                      } else {
                        tmp = await decryptString(_stringEncoded, PRIVATE_KEY);
                        setState(() {
                          _stringEncoded = "";
                          myController.text = tmp;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                RaisedButton(
                    child: Text("DECODE"),
                    color: Colors.red,
                    onPressed: () async {
                      String tmp = "";
                      if (_stringEncoded.isNotEmpty) {
                        try {
                          tmp =
                              await decryptString(_stringEncoded, PRIVATE_KEY);
                          setState(() {
                            _stringEncoded = "";
                            myController.text = tmp;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    }),
                RaisedButton(
                  child: Text("RESET"),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      _stringEncoded = "";
                      myController.clear();
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.orangeAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("STRING ENCODED"),
                      Divider(),
                      Text(_stringEncoded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
