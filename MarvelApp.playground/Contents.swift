import Foundation
@testable import MarvelAppFramework

AppEnvironment.current.api.getHeroes { (result) in
    switch result {
    case .success(let heroes): print(heroes)
    case .failure: print("Failed")
    }
}

RunLoop.main.run()
