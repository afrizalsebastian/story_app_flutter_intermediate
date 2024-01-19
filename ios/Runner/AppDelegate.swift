import UIKit
import Flutter
import GoogleMpas

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD2RTJiSeFlwbrhROyyLPHdY08Zq1gi6ms")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
