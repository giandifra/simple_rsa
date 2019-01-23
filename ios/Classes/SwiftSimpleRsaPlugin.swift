import Flutter
import UIKit
import SwiftyRSA

public class SwiftSimpleRsaPlugin: NSObject, FlutterPlugin {
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "juanito21.com/simple_rsa", binaryMessenger: registrar.messenger())
		let instance = SwiftSimpleRsaPlugin()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}

	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		let argsMap : NSDictionary = call.arguments as! NSDictionary
		print("this is my method" + call.method)
		switch (call.method) {
			case "encrypt":
				let text : String = argsMap["txt"] as! String
    			let publicKey : String = argsMap["publicKey"] as! String
    			let res = encryptData(plainText: text, publicKey: publicKey)
    			result(res)
			case "decrypt":
				let text : String = argsMap["txt"] as! String
    			let privateKey : String = argsMap["privateKey"] as! String
    			let res = decryptData(encryptedText: text, privateKey: privateKey)
    			result(res)
			case "sign":
				let plainText : String = argsMap["plainText"] as! String
    			let privateKey : String = argsMap["privateKey"] as! String
    			let res = signData(plainText: plainText, privateKey: privateKey)
    			result(res)
			case "verify":
				let plainText : String = argsMap["plainText"] as! String
		    	let signature : String = argsMap["signature"] as! String
		    	let publicKey : String = argsMap["publicKey"] as! String
    			let res = verifyData(plainText: plainText, signature: signature, publicKey: publicKey)
		    	result(res)
			default:
				result(FlutterMethodNotImplemented)
		}
    }

    private func encryptData(plainText: String, publicKey: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: publicKey)
		let clear = try! ClearMessage(string: plainText, using: .utf8)
		let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
		return encrypted.base64String
    }

    private func decryptData(encryptedText: String, privateKey: String) -> String {
	    let privateKey = try! PrivateKey(pemEncoded: privateKey)
	    let encrypted = try! EncryptedMessage(base64Encoded: encryptedText)
		let clear = try! encrypted.decrypted(with: privateKey, padding: .PKCS1)
		let plain = try! clear.string(encoding: String.Encoding(rawValue: 0))
        return plain
    }

    private func signData(plainText: String, privateKey: String) -> String {
    	let privateKey = try! PrivateKey(pemEncoded: privateKey)
    	let clear = try! ClearMessage(string: plainText, using: .utf8)
		let signature = try! clear.signed(with: privateKey, digestType: .sha1)
		return signature.base64String
    }

    private func verifyData(plainText: String, signature: String, publicKey: String) -> Bool {
        let clear = try! ClearMessage(string: plainText, using: .utf8)
	    let publicKey = try! PublicKey(pemEncoded: publicKey)
	    let signature = try! Signature(base64Encoded: signature)
		let isSuccessful = try! clear.verify(with: publicKey, signature: signature, digestType: .sha1)
		return isSuccessful
    }
}
