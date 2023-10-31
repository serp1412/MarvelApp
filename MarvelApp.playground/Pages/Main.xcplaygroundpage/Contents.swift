/*:
 # Welcome to MarvelApp!
 
 - NOTE: To view this in proper Markup, make sure to go to `Editor -> Show Rendered Markup`
 
 ## What has been added recently?
 * App switched to modern playgrounds. Removed app-inside-framework approach.
 * Added custom action sheet for custom transitions and customizability options.
 - NOTE: Check its snapshot tests for customization options
 * Added snapshot tests for app screens and action sheet
    * Make sure to run the snapshots on iPhone 12, iOS 15.4.
 * Integrated [LazyTransitions](https://github.com/serp1412/LazyTransitions/tree/master/LazyTransitions) for lazy pop gestures on details page (swipe right from the middle of the screen when you open one of the Marvel Heroes)
 * Used SnapKit for the new UI
 * Updated this playground with new examples

 ## What has been initially done in 2019?
 * App was added into playgrounds for quick iterations especially in the beginning. You'll notice that I only made the project to run on the simulator on commit #6 4c1ea15
 - NOTE: If you go through git history you'll notice what I prototyped in the playgrounds on each stage (API, UI, various ideas etc.)
 * To make the point above work, I had to move the whole app into a framework. The idea is stolen from `Kickstarter` iOS app
 * Introduced `AppEnvironment` - it's basically a singleton to control all singletons. Very useful during tests
 * API layer implemented using `Codable` protocol, and leveraging generics for code re-usability
 * Added `Tagged` (source indicated in file) struct to transform primitives into a strong types that can be enforced at compile time.
 * Added `MD5` to be able to generate hashes needed for performing Marvel API requests (source indicated in the file)
 * Architecture that I used is a combination of a `View` - for UI, `Interactor` - for business logic, and `Builder` - to combine them (so.. VIB?). It leverages `AppEnvironment` to work with dependencies and allows to inject mocked version very easily. `View` and `Interactor` know nothing of each other due to dependency inversion. I chose this architecture because it enables testability, without having a ton of boilerplate that comes with more complex archs like `VIPER` or `RIBlets`.
 * A lot of convenience extensions were added to improve the workflow, look and readability of code. You can find most of them in the `MarvelAppFramework`>`Helpers` folder.
 * Found an interesting solution using `DispatchGroup` in order to run all the requests needed for displaying hero details  in parallel. Can be seen in the `HeroDetailInteractor` file
 * Added `FuncChecks` to simplify writing tests. It's a class we've come up with with my team internally and heavily use it in our projects.
 * Had to come up with a new `FuncCheck` type in order to control the stub of a closure when it's called multiple times in a row - `ClosureStubFuncCheck`. This allowed me to provide a different stub depending on the passed parameters. Specifically this was useful in `HeroDetailInteractor` when on `viewDidLoad` it triggers 4 requests at once and I wanted to pass different values in the completion block depending on the request. Check `HeroDetailInteractorTests` to see what I mean.
 * A bit of runtime magic to make sure images are loaded properly when inside reusable cells

 That's about it! I hope you enjoy looking through this code as I enjoyed writing it :)

You can actually play around with the entire app, by building the project and pressing the `Play` button below. Make sure to open the `LiveView` of this playground in the Assistent Editor.
    If playgrounds are acting up, just re-run them ;)
 
 - NOTE: On a M1 machine for playgrounds to work, make sure you're **not** running it with Rosetta

 */


import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelApp

let navVC = HeroListBuilder.build()

navVC.view.frame = CGRect.init(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.liveView = navVC.view
/*:
 ## API usage examples
*/


//let api = API()
//api.getHeroes { result in
//    switch result {
//    case .success(let heroes):
//        heroes.results.first!.id
//        api.getHeroProducts(kind: .series, heroId: heroes.results.first!.id,
//                            limit: 20, completion: { (result) in
//            print(result)
//        })
//    case .failure: print("Failed")
//    }
//}
//
//AppEnvironment.current.api.getHeroes { (result) in
//    switch result {
//    case .success(let heroes):
//    DispatchQueue.main.async {
//        let cell = CardCell.instantiate()
//        cell.configure(for: heroes.results.first!, infoButtonTapped: {})
//        cell.frame = CGRect.init(x: 0, y: 0, width: 375, height: 270)
//
//        PlaygroundPage.current.liveView = cell
//    }
//    case .failure: print("Failed")
//    }
//}

/*:
 ## ActionSheet usage example
*/
let button = UIButton(type: .system)
button.setTitle("Awesome Action!", for: .normal)
let footer = UIView()
footer.addSubview(button)
button.snp.makeConstraints { make in
    make.edges.equalToSuperview().inset(20)
}

let actionSheet = ActionSheet.init(configuration: .init(header: .title("Heroes"), footer: footer, maxHeight: 500))
let firstAction = DefaultActionView(title: "First Action",
                                    icon: .icon(Images.star, size: 24),
                                    rightTitle: "Disclaimer",
                                    sheetToDismiss: actionSheet,
                                    onTap: { })

let tapAction = DefaultActionView(title: "Tap Me!!!", icon: .empty) {
    actionSheet.setActions([
        firstAction,
        DefaultActionView(title: "Second Action",
                          icon: .empty,
                          sheetToDismiss: actionSheet,
                          onTap: { }),
        DefaultActionView(title: "Third Action",
                          icon: .empty,
                          sheetToDismiss: actionSheet,
                          onTap: { })
    ])
}

actionSheet.setActions([tapAction])
//actionSheet.present(in: self)

//actionSheet.setActions([
//    firstAction,
//    DefaultActionView(title: "Second Action",
//                      icon: .empty,
//                      sheetToDismiss: actionSheet,
//                      onTap: { }),
//    DefaultActionView(title: "Third Action",
//                      icon: .empty,
//                      sheetToDismiss: actionSheet,
//                      onTap: { })
//])

actionSheet.present(in: navVC)

