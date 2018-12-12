package com.juanito21.simplersa

import android.util.Base64
import android.util.Log
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
                }else{
                    result.error("NULL INPUT STRING", "Encrypt failure.", null)
                }
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
            "sign" -> {
                val text = call.argument<String>("plainText")
                val privateKey = call.argument<String>("privateKey")
                if (text != null && privateKey != null) {
                    try {
                        val output = signData(text, privateKey)
                        result.success(output)
                    } catch (e: java.lang.Exception) {
                        e.printStackTrace()
                        result.error("UNAVAILABLE", "Sign failure.", null)
                    }
                } else {
                    result.error("NULL INPUT STRING", "Sign failure.", null)
                }
            }
            "verify" -> {
                val text = call.argument<String>("plainText")
                val sign = call.argument<String>("signature")
                val publicKey = call.argument<String>("publicKey")
                if (text != null && sign != null && publicKey != null) {
                    try {
                        val output = verifyData(text, sign, publicKey)
                        result.success(output)
                    } catch (e: java.lang.Exception) {
                        e.printStackTrace()
                        result.error("UNAVAILABLE", "Verify failure.", null)
                    }
                } else {
                    result.error("NULL INPUT STRING", "Verify failure.", null)
                }
            }
            "decryptWithPublicKey" -> {
                val text = call.argument<String>("plainText")
                val publicKey = call.argument<String>("publicKey")
                if (text != null && publicKey != null) {
                    try {
                        val d = Base64.decode(text, Base64.DEFAULT)
                        val output = decryptStringWithPublicKey(d, publicKey)
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

    @Throws(NoSuchAlgorithmException::class, NoSuchPaddingException::class, InvalidKeyException::class, IllegalBlockSizeException::class, BadPaddingException::class)
    private fun decryptStringWithPublicKey(encryptedBytes: ByteArray, publicKey: String): String {
        val publicBytes = Base64.decode(publicKey, Base64.DEFAULT)
        val keySpec = X509EncodedKeySpec(publicBytes)
        val keyFactory = KeyFactory.getInstance("RSA")
        val pubKey = keyFactory.generatePublic(keySpec)
        val cipher1 = Cipher.getInstance("RSA/ECB/PKCS1PADDING")
        cipher1.init(Cipher.DECRYPT_MODE, pubKey)

        val blockSize = cipher1.blockSize
        val blocks : Int = Math.ceil(encryptedBytes.size / blockSize.toDouble()).toInt()
        var output = ByteArray(blocks * blockSize)
        var outputSize = 0

        for (i in 0 until blocks) {
            val offset = i * blockSize
            val blockLength = Math.min(blockSize, encryptedBytes.size - offset)
            val cryptoBlock = cipher1.doFinal(encryptedBytes, offset, blockLength)
            System.arraycopy(cryptoBlock, 0, output, outputSize, cryptoBlock.size)
            outputSize += cryptoBlock.size
        }

        if (outputSize != output.size) {
            val tmp = output.copyOfRange(0, outputSize)
            output = tmp
        }
        return String(output)
    }

    @Throws(NoSuchAlgorithmException::class, NoSuchPaddingException::class, InvalidKeyException::class, IllegalBlockSizeException::class, BadPaddingException::class)
    private fun signData(plainText: String, privateKey: String): String {
        try {
            val privateSignature = Signature.getInstance("SHA1withRSA")
            privateSignature.initSign(loadPrivateKey(privateKey))
            privateSignature.update(plainText.toByteArray())
            val signature = privateSignature.sign()
            return Base64.encodeToString(signature, Base64.DEFAULT)
        } catch (e: Exception) {
            throw Exception(e.toString())
        }
    }

    private fun verifyData(plainText: String, signature: String, publicKey: String): Boolean {
        try {
            val publicBytes = Base64.decode(publicKey, Base64.DEFAULT)
            val keySpec = X509EncodedKeySpec(publicBytes)
            val keyFactory = KeyFactory.getInstance("RSA")
            val pubKey = keyFactory.generatePublic(keySpec)

            val publicSignature = Signature.getInstance("SHA1withRSA")
            publicSignature.initVerify(pubKey)
            publicSignature.update(plainText.toByteArray())
            val signatureBytes = Base64.decode(signature, Base64.DEFAULT)
            return publicSignature.verify(signatureBytes)
        } catch (e: Exception) {
            throw Exception(e.toString())
        }
    }
}
