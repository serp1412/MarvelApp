import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelAppFramework

AppEnvironment.current.api.getHeroes { (result) in
    switch result {
    case .success(let heroes): print(heroes)
      let data = try! Data(contentsOf: heroes.first!.thumbnail.url())
    DispatchQueue.main.async {
        let imageView = UIImageView(image: UIImage(data: data))
        PlaygroundPage.current.liveView = imageView
    }
    case .failure: print("Failed")
    }
}
