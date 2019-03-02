import UIKit

enum HeroListBuilder {
    static func build() -> UINavigationController {
        let view = HeroListViewController.instantiate()
        let interactor = HeroListInteractor()

        view.interactor = interactor
        interactor.view = view

        return .init(rootViewController: view)
    }
}
