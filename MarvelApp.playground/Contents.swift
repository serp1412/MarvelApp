import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelAppFramework

FrameworkDelegate().application(UIApplication.shared, didFinishLaunchingWithOptions: nil)


let navVC = HeroListBuilder.build()

navVC.view.frame = CGRect.init(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.liveView = navVC.view



AppEnvironment.current.api.getHeroes(name: "Spider-Man") { (result) in
    switch result {
    case .success(let heroes): print(heroes)
    DispatchQueue.main.async {
//        let heroCell = HeroCell.instantiate()
//        heroCell.frame = .init(x: 0, y: 0, width: 375, height: 272)
//        heroCell.configure(for: heroes.randomElement()!)
//        PlaygroundPage.current.liveView = heroCell
    }
    case .failure: print("Failed")
    }
}

