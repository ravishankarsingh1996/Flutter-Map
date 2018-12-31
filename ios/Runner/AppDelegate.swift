import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
//     [GMSServices provideAPIKey:@"AIzaSyCUAm6aC09J9Rlvvy-GuufPL3sfpHzNdMw"];
    GMSServices.provideAPIKey("AIzaSyCUAm6aC09J9Rlvvy-GuufPL3sfpHzNdMw")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
