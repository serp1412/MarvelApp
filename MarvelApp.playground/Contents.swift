/*:
 # Welcome to MarvelApp!

 ## What has been done?
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

 ## What could have been done?
 - NOTE: A lot of these things I simply didn't have time to do due to family circumstances
 * Acceptance Criteria: Custom transition - just didn't have time to do it. But I have an entire open source library about custom transitions, so you can [check that out](https://github.com/serp1412/LazyTransitions)
 * Snapshot tests! but there was a requirement not to use anything third party, so I skipped that
 * Didn't have time to write UI tests
 * I would have probably extracted the API bits in both controllers into a separate private service. For example, I really don't like the `Bool`s that I introduced in `HeroListInteractor` and would have looked for a better solution.
 * Would have figured out how to separate `CardCell` into subclasses that would come out of the same nib file. For some reason took me too long to make it work and I gave up
 * Write much more documentation
 * Write tests for `FavoritesService` by moving the persistence logic into a separate persistor type.
 * Write integration tests with Marvel API
 * Add some kind of security to the API credentials :D
 * Would have handled API errors and have some kind of UI for failed states
 * Match the physical folder structure of the project with the Xcode structure
 * Make the cell for Stories not show any image placeholder
 * Cleanup the code a bit more

 That's about it! I hope you enjoy looking through this code as I enjoyed writing it :)

 - NOTE: You can actually play around with the entire app, by building the project and pressing the `Play` button below. Make sure to open the `LiveView` of this playground in the Assistent Editor

 */


import Foundation
import UIKit
import PlaygroundSupport
@testable import MarvelApp

let navVC = HeroListBuilder.build()

navVC.view.frame = CGRect.init(x: 0, y: 0, width: 375, height: 667)

let button = UIButton(type: .system)
button.setTitle("Awesome Action!", for: .normal)
let footer = UIView()
footer.addSubview(button)
button.snp.makeConstraints { make in
    make.edges.equalToSuperview().inset(20)
}

let actionSheet = ActionSheet.init(configuration: .init(header: .title("Heroes"), footer: footer, maxHeight: 500))
let firstAction = DefaultActionView(title: "First Action",
                                      icon: .icon(.init(named: "star")!, size: 24),
                                      rightTitle: "Disclaimer",
                                      sheetToDismiss: actionSheet,
                                      onTap: { })
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

PlaygroundPage.current.liveView = navVC.view

//actionSheet.present(in: navVC)

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

//AppEnvironment.current.api.getHeroes { (result) in
//    switch result {
//    case .success(let heroes):
//    DispatchQueue.main.async {
//        let cell = CardCell.instantiate()
//        cell.configure(for: heroes.results.first!)
//        cell.frame = CGRect.init(x: 0, y: 0, width: 375, height: 270)
//
//        PlaygroundPage.current.liveView = cell
//    }
//    case .failure: print("Failed")
//    }
//}

let sPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

let plistPath = sPath.appendingPathComponent("newPlist.plist")

([1, 2, 3] as NSArray).write(to: plistPath, atomically: true)

FileManager.default.fileExists(atPath: sPath.relativePath)
