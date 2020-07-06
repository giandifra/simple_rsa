import 'dart:async';

import 'package:flutter/services.dart';
abstract class RSAHash{
  static const String sha512='SHA512withRSA';
  static const String sha224='SHA224withRSA';
  static const String sha256='SHA256withRSA';
  static const String sha384='SHA384withRSA';
  static const String sha1='SHA1withRSA';
}
const MethodChannel _channel =
    const MethodChannel('juanito21.com/simple_rsa');
Future<String> encryptString(String txt, String publicKey) async {
  try {
    publicKey = publicKey.replaceAll("-----BEGIN PUBLIC KEY-----", "").replaceAll("-----END PUBLIC KEY-----", "");
    final String result = await _channel
        .invokeMethod('encrypt', {"txt": txt, "publicKey": publicKey});
    return result;
  } on PlatformException catch (e) {
    throw "Failed to get string encoded: '${e.message}'.";
  }
}

Future<String> decryptString(String txt, String privateKey) async {
  try {
    privateKey = privateKey.replaceAll("-----BEGIN PRIVATE KEY-----", "").replaceAll("-----END PRIVATE KEY-----", "");
    privateKey = privateKey.replaceAll("-----BEGIN RSA PRIVATE KEY-----", "").replaceAll("-----END RSA PRIVATE KEY-----", "");
    final String result = await _channel
        .invokeMethod('decrypt', {"txt": txt, "privateKey": privateKey});
    return result;
  } on PlatformException catch (e) {
    throw "Failed decoded string: '${e.message}'.";
  }
}

Future<String> signString(String plainText, String privateKey,[String sha=RSAHash.sha1]) async {
  try {
    privateKey = privateKey.replaceAll("-----BEGIN PRIVATE KEY-----", "").replaceAll("-----END PRIVATE KEY-----", "");
    privateKey = privateKey.replaceAll("-----BEGIN RSA PRIVATE KEY-----", "").replaceAll("-----END RSA PRIVATE KEY-----", "");
    final String result = await _channel
        .invokeMethod('sign', {"plainText": plainText, "privateKey": privateKey,"sha":sha});
    return result;
  } on PlatformException catch (e) {
    throw "Failed decoded string: '${e.message}'.";
  }
}

Future<bool> verifyString(String plainText, String signature, String publicKey,[String sha=RSAHash.sha1]) async {
  try {
    publicKey = publicKey.replaceAll("-----BEGIN PUBLIC KEY-----", "").replaceAll("-----END PUBLIC KEY-----", "");
    final bool result = await _channel
        .invokeMethod('verify', {"plainText": plainText, "signature": signature, "publicKey": publicKey,"sha":sha});
    return result;
  } on PlatformException catch (e) {
    throw "Failed decoded string: '${e.message}'.";
  }
}

Future<String> decryptStringWithPublicKey(String plainText, String signature, String publicKey) async {
  try {
    publicKey = publicKey.replaceAll("-----BEGIN PUBLIC KEY-----", "").replaceAll("-----END PUBLIC KEY-----", "");
    final String result = await _channel
        .invokeMethod('decryptWithPublicKey', {"plainText": plainText, "publicKey": publicKey});
    return result;
  } on PlatformException catch (e) {
    throw "Failed decoded string: '${e.message}'.";
  }
}
