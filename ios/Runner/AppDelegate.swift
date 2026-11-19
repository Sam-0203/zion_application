import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }

  func didInitializeImplicitFlutterEngine(
    _ engineBridge: FlutterImplicitEngineBridge
  ) {

    GeneratedPluginRegistrant.register(
      with: engineBridge.pluginRegistry
    )
    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "FreshInstallPlugin"
    ) {
      FreshInstallPlugin.register(with: registrar)
    }

  }

}

private final class FreshInstallPlugin: NSObject, FlutterPlugin {
  private static let firstLaunchKey = "flutter_app_has_launched_before"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_app/installation",
      binaryMessenger: registrar.messenger()
    )
    let instance = FreshInstallPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "isFreshInstall" else {
      result(FlutterMethodNotImplemented)
      return
    }

    let defaults = UserDefaults.standard
    let isFreshInstall = defaults.object(forKey: Self.firstLaunchKey) == nil
    if isFreshInstall {
      defaults.set(true, forKey: Self.firstLaunchKey)
    }
    result(isFreshInstall)
  }
}
