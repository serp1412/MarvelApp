import UIKit
import MarvelAppFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var frameworkDelegate: FrameworkDelegate = {
        let delegate = FrameworkDelegate()
        delegate.window = self.window

        return delegate
    }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return frameworkDelegate.application(application, didFinishLaunchingWithOptions:launchOptions)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        frameworkDelegate.applicationDidEnterBackground(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        frameworkDelegate.applicationWillTerminate(application)
    }
}

