
import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 13.0, *) {

     } else {
         FirebaseApp.configure()
     }
    GMSServices.provideAPIKey("AIzaSyAhKidUT4BogSmwPppJ687QRMIDVStS0zA")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

