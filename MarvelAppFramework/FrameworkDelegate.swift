import UIKit

public class FrameworkDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = HeroListBuilder.build()
        window?.makeKeyAndVisible()

        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().prefersLargeTitles = true
        
        return true
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        AppEnvironment.current.favorites.synchronize()
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        AppEnvironment.current.favorites.synchronize()
    }
}
