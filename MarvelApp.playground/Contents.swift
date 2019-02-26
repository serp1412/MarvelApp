import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelAppFramework

AppEnvironment.current.api.getHeroes { (result) in
    switch result {
    case .success(let heroes): print(heroes)
    DispatchQueue.main.async {
        let heroCell = HeroCell.instantiate()
        heroCell.frame = .init(x: 0, y: 0, width: 375, height: 272)
        heroCell.configure(for: heroes.randomElement()!)
        PlaygroundPage.current.liveView = heroCell
    }
    case .failure: print("Failed")
    }
}
