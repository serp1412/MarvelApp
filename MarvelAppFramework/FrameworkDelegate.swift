import UIKit

public class FrameworkDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window?.rootViewController = HeroListBuilder.build()
        window?.makeKeyAndVisible()

        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().prefersLargeTitles = true
        
        return true
    }
}
