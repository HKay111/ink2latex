import Flutter

class GemmaBridge {
    static let channelName = "com.ink2latex/gemma"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { (call, result) in
            if call.method == "recognize" {
                // TODO: Integrate Gemma E2B via CoreML
                result(["text": "", "confidence": 0.0])
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
