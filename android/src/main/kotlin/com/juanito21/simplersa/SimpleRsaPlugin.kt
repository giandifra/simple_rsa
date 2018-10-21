package com.juanito21.simplersa

import android.util.Base64
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.security.*
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import java.util.*
import javax.crypto.BadPaddingException
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException
import javax.crypto.NoSuchPaddingException


class SimpleRsaPlugin() : MethodCallHandler {

//    private var mRegistrar: Registrar? = registrar

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "juanito21.com/simple_rsa")
            val instance = SimpleRsaPlugin()
            channel.setMethodCallHandler(instance)
        }
    }

//    private fun SimpleRsaPlugin(registrar: Registrar) {
//
//    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "encrypt" -> {
                val text = call.argument<String>("txt")
                val publicKey = call.argument<String>("publicKey")
                if (text != null && publicKey != null) {
                    try {
                        val encoded = encryptData(text, publicKey)
                        result.success(encoded)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("UNAVAILABLE", "Encrypt failure.", null)
                    }
                }
                result.error("NULL INPUT STRING", "Encrypt failure.", null)
            }
            "decrypt" -> {
                val text = call.argument<String>("txt")
                val privateKey = call.argument<String>("privateKey")
                if (text != null && privateKey != null) {
                    try {
                        val d = Base64.decode(text, Base64.DEFAULT)
                        val output = decryptData(d, privateKey)
                        result.success(output)
                    } catch (e: java.lang.Exception) {
                        e.printStackTrace()
                        result.error("UNAVAILABLE", "Decrypt failure.", null)
                    }
                } else {
                    result.error("NULL INPUT STRING", "Decrypt failure.", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun encryptData(txt: String, publicKey: String): String {
        val encoded: String
        val encrypted: ByteArray?
        try {
            val publicBytes = Base64.decode(publicKey, Base64.DEFAULT)
            val keySpec = X509EncodedKeySpec(publicBytes)
            val keyFactory = KeyFactory.getInstance("RSA")
            val pubKey = keyFactory.generatePublic(keySpec)
            val cipher = Cipher.getInstance("RSA/ECB/PKCS1PADDING")
            cipher.init(Cipher.ENCRYPT_MODE, pubKey)
            encrypted = cipher.doFinal(txt.toByteArray())
            encoded = Base64.encodeToString(encrypted, Base64.DEFAULT)
            return encoded
        } catch (e: Exception) {
            throw Exception(e.toString())
        }
    }

    @Throws(GeneralSecurityException::class)
    private fun loadPrivateKey(privateKey: String): PrivateKey {
        val clear = Base64.decode(privateKey, Base64.DEFAULT)
        val keySpec = PKCS8EncodedKeySpec(clear)
        val fact = KeyFactory.getInstance("RSA")
        val priv = fact.generatePrivate(keySpec)
        Arrays.fill(clear, 0.toByte())
        return priv
    }

    @Throws(NoSuchAlgorithmException::class, NoSuchPaddingException::class, InvalidKeyException::class, IllegalBlockSizeException::class, BadPaddingException::class)
    private fun decryptData(encryptedBytes: ByteArray, privateKey: String): String {
        val cipher1 = Cipher.getInstance("RSA/ECB/PKCS1PADDING")
        cipher1.init(Cipher.DECRYPT_MODE, loadPrivateKey(privateKey))
        val decryptedBytes = cipher1.doFinal(encryptedBytes)
        return String(decryptedBytes)
    }

}
