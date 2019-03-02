import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelAppFramework

//FrameworkDelegate().application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

//
//let navVC = HeroListBuilder.build()
//
//navVC.view.frame = CGRect.init(x: 0, y: 0, width: 375, height: 667)

//PlaygroundPage.current.liveView = navVC.view

//let api = API()
//api.getHeroes { result in
//    switch result {
//    case .success(let heroes):
//        heroes.results.first!.id
//        api.getSeries(heroId: heroes.results.first!.id, completion: { (result) in
//            print(result)
//        })
//    case .failure: print("Failed")
//    }
//}
//
//api.getSeries(heroId: 1011194, completion: { (result) in
//    switch result {
//    case .success(let comics):
//        print(comics.count)
//        print(comics)
//    case .failure: break
//    }
//})

AppEnvironment.current.api.getHeroes { (result) in
    switch result {
    case .success(let heroes):
    DispatchQueue.main.async {
        let detail = HeroDetailViewController.instantiate(with: heroes.results.first!)
        let navVC = UINavigationController(rootViewController: detail)
        navVC.view.frame = CGRect.init(x: 0, y: 0, width: 375, height: 667)
        PlaygroundPage.current.liveView = navVC.view
    }
    case .failure: print("Failed")
    }
}
