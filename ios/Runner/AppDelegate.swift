import UIKit
import Flutter
import moengage_flutter
import MoEngageSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterViewController: FlutterViewController?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let appID = "668EZ1ENJ3R8N6YSZNAGIQP0"
      let sdkConfig = MoEngageSDKConfig(withAppID: appID)
      sdkConfig.appGroupID = "group.com.vernost.bounz.NotificationServices"
      sdkConfig.enableLogs = true
      sdkConfig.moeDataCenter = MoEngageDataCenter.data_center_04
      
      MoEngageInitializer.sharedInstance.initializeDefaultInstance(sdkConfig,launchOptions: launchOptions)
      MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
      flutterViewController = FlutterViewController()
      let nav = UINavigationController.init(rootViewController:flutterViewController!)
      nav.isNavigationBarHidden = true
      let window = UIWindow()
      self.window = window
      window.rootViewController = nav
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    if let vc = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
    return
    }
    }
                                                                   
    override func registrar(forPlugin: String) -> FlutterPluginRegistrar {
    return (self.flutterViewController?.registrar(forPlugin: forPlugin))!
    }
        
    override func hasPlugin(_ pluginKey: String) -> Bool {
    return (self.flutterViewController?.hasPlugin(pluginKey))!
    }
        
    override func valuePublished(byPlugin pluginKey: String) -> NSObject {
    return (self.flutterViewController?.valuePublished(byPlugin: pluginKey))!
    }
        
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("Opening deeplink", url)
    return true
    }
        
    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    print("Opening Universal link", userActivityType)
    return false
    }
    
    
    //Remote notification Registration callback methods
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      //Call only if MoEngageAppDelegateProxyEnabled is NO
      MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }

    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      //Call only if MoEngageAppDelegateProxyEnabled is NO
      MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
    }
    
    // MARK:- UserNotifications Framework callback method
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        
        //Custom Handling of notification if Any
        let pushDictionary = response.notification.request.content.userInfo
        print(pushDictionary)
        
        completionHandler();
    }


    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //This is to only to display Alert and enable notification sound
        completionHandler([.sound,.alert])
        
    }
}