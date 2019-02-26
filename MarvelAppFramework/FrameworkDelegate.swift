import UIKit

public class FrameworkDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().backgroundColor = .white
        return true
    }
}
