import Flutter
import UIKit
import SwiftyRSA

public class SwiftSimpleRsaPlugin: NSObject, FlutterPlugin {
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "simple_rsa", binaryMessenger: registrar.messenger())
		let instance = SwiftSimpleRsaPlugin()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}

	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		let argsMap : NSDictionary = call.arguments as! NSDictionary
		switch (call.method) {
			case "encrypt":
				let text : String = argsMap["txt"] as! String
    			let publicKey : String = argsMap["publicKey"] as! String

				let base64Key : Data(publicKey.utf8).base64EncodedString()

    			let result = encryptData(plainText: text, publicKey: base64Key)
    			result(result)
			case "decrypt":
				let text : String = argsMap["txt"] as! String
    			let privateKey : String = argsMap["privateKey"] as! String

				let base64Text : Data(text.utf8).base64EncodedString()
				let base64Key : Data(privateKey.utf8).base64EncodedString()

    			let result = decryptData(encryptedText: base64Text, publicKey: base64Key)
    			result(result)
			case "sign":
				let plainText : String = argsMap["plainText"] as! String
    			let privateKey : String = argsMap["privateKey"] as! String

    			let base64Key : Data(privateKey.utf8).base64EncodedString()

    			let result = signData(plainText: plainText, privateKey: base64Key)
    			result(result)
			case "verify":
				let plainText : String = argsMap["plainText"] as! String
		    	let signature : String = argsMap["signature"] as! String
		    	let publicKey : String = argsMap["publicKey"] as! String

    			let base64Signature : Data(signature.utf8).base64EncodedString()
    			let base64Key : Data(publicKey.utf8).base64EncodedString()

    			let result = verifyData(plainText: plainText, signature: base64Signature, publicKey: base64Key)
		    	result(result)
			default:
				result(FlutterMethodNotImplemented)
		}
    }

    private func encryptData(plainText: String, publicKey: base64Encoded) -> String {
    	let publicKey = try PublicKey(base64Encoded: publicKey)
		let clear = try ClearMessage(string: plainText, using: .utf8)
		let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
		return encrypted.base64Encoded
    }

    private func decryptData(encryptedText: base64Encoded, privateKey: base64Encoded) -> String {
	    let privateKey = try PrivateKey(base64Encoded: privateKey)
	    let encrypted = try EncryptedMessage(base64Encoded: encryptedText)
		let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)
		return clear.base64Encoded
    }

    private func signData(plainText: String, privateKey: base64Encoded) -> String {
    	let privateKey = try PrivateKey(base64Encoded: privateKey)
    	let clear = try ClearMessage(string: plainText, using: .utf8)
		let signature = clear.signed(with: privateKey, digestType: .sha1)
		return signature.base64String
    }

    private func verifyData(plainText: String, signature: base64Encoded, publicKey: base64Encoded) -> Bool {
	    let publicKey = try PublicKey(base64Encoded: publicKey)
	    let signature = try Signature(base64Encoded: signature)
		let isSuccessful = try clear.verify(with: publicKey, signature: signature, digestType: .sha1)
		return isSuccessful
    }
}
