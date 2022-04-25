import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = HeroListBuilder.build()
        window?.makeKeyAndVisible()

        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().prefersLargeTitles = true
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppEnvironment.current.favorites.synchronize()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        AppEnvironment.current.favorites.synchronize()
    }
}

