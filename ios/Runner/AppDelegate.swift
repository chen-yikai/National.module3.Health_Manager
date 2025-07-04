import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "com.example.flutter_health_pre_test/method",
                                             binaryMessenger: controller.binaryMessenger)
    methodChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "write_history":
        self?.writeToFile(fileName: "history.json", content: call.arguments as! String, result: result)
      case "get_history":
        self?.readFromFile(fileName: "history.json", result: result)
      case "write_exercise":
        self?.writeToFile(fileName: "exercise.json", content: call.arguments as! String, result: result)
      case "get_exercise":
        self?.readFromFile(fileName: "exercise.json", result: result)
      case "write_workout":
        self?.writeToFile(fileName: "workout.json", content: call.arguments as! String, result: result)
      case "get_workout":
        self?.readFromFile(fileName: "workout.json", result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func writeToFile(fileName: String, content: String, result: @escaping FlutterResult) {
    do {
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
      try content.write(to: filePath, atomically: true, encoding: .utf8)
      result(nil)
    } catch {
      result(FlutterError(code: "WRITE_ERROR", message: "Failed to write file", details: error.localizedDescription))
    }
  }
  
  private func readFromFile(fileName: String, result: @escaping FlutterResult) {
    do {
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
      let content = try String(contentsOf: filePath, encoding: .utf8)
      result(content)
    } catch {
      result(FlutterError(code: "READ_ERROR", message: "Failed to read file", details: error.localizedDescription))
    }
  }
}
