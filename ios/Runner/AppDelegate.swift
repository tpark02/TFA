import UIKit
import Flutter
import GoogleSignIn   // ← add this

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle the OAuth redirect back to your app
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Let GoogleSignIn process the URL
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    // Fall back to Flutter/default handlers
    return super.application(app, open: url, options: options)
  }
}
