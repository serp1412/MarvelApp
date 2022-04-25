import XCTest
@testable import MarvelApp

class HeroDetailInteractorTests: XCTestCase {
    var mockAPI: MockAPI!
    var mockFavorites: MockFavoritesService!
    var mockInput: MockHeroDetailInput!
    var interactor: HeroDetailInteractor!
    let totalNumberOfSections = 5

    override func setUp() {
        super.setUp()

        mockAPI = MockAPI()
        mockFavorites = MockFavoritesService()
        mockInput = MockHeroDetailInput()
        interactor = HeroDetailInteractor.init(hero: .mocked())
        interactor.view = mockInput
        AppEnvironment.pushEnvironment(api: mockAPI, favorites: mockFavorites)
    }

    override func tearDown() {
        AppEnvironment.popEnvironment()

        super.tearDown()
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_shouldTriggerAllRequests() {
        // GIVEN
        let heroId = MarvelHero.mocked().id

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertEqual(mockAPI.getHeroProductsFuncCheck.callCount, 4)
        XCTAssertTrue(mockAPI.getHeroProductsFuncCheck.wasEverCalled(with: (.comics, heroId, 3)))
        XCTAssertTrue(mockAPI.getHeroProductsFuncCheck.wasEverCalled(with: (.events, heroId, 3)))
        XCTAssertTrue(mockAPI.getHeroProductsFuncCheck.wasEverCalled(with: (.series, heroId, 3)))
        XCTAssertTrue(mockAPI.getHeroProductsFuncCheck.wasEverCalled(with: (.stories, heroId, 3)))
    }

    func test_viewDidLoad_shouldCallShowLoading() {
        // GIVEN

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.showLoadingFuncCheck.wasCalled)
    }

    func test_viewDidLoad_whenAllRequestsSucceeded_shouldCallReloadData() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked())) })

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.reloadDataFuncCheck.wasCalled)
        }
    }

    func test_viewDidLoad_whenAllRequestsAreInProgress_shouldNotCallReloadData() {
        // GIVEN

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.reloadDataFuncCheck.wasNotCalled)
        }
    }

    func test_viewDidLoad_whenJustOneRequestCompleted_shouldNotCallHideLoading() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { (kind, _, _) in
            switch kind {
            case .comics: return .call(.success(.mocked()))
            default: return .doNotCall
            }
        })

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.hideLoadingFuncCheck.wasNotCalled)
        }
    }

    func test_viewDidLoad_whenAtLeastOneRequestIsInProgress_shouldNotCallHideLoading() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { (kind, _, _) in
            switch kind {
            case .comics: return .doNotCall
            default: return .call(.success(.mocked()))
            }
        })

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.hideLoadingFuncCheck.wasNotCalled)
        }
    }

    func test_viewDidLoad_whenAllRequestsSucceeded_shouldCallHideLoading() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked())) })

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.hideLoadingFuncCheck.wasCalled)
        }
    }

    func test_viewDidLoad_whenAllRequestsAreInProgress_shouldNotCallHideLoading() {
        // GIVEN

        // WHEN
        interactor.viewDidLoad()

        // THEN
        asyncAssert {
            XCTAssertTrue(self.mockInput.hideLoadingFuncCheck.wasNotCalled)
        }
    }

    // MARK: - numberOfSections

    func test_numberOfSections_whenAllRequestsAreInProgress_shouldAlwaysReturnOne() {
        // GIVEN
        let expectedResult = 1

        // WHEN
        let result = interactor.numberOfSections

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_numberOfSections_whenAllRequestsHaveSucceededWithoutProducts_shouldAlwaysReturnOne() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked())) })
        let expectedResult = 1
        interactor.viewDidLoad()

        // WHEN & THEN
        asyncAssert {
            let result = self.interactor.numberOfSections
            XCTAssertEqual(result, expectedResult)
        }
    }

    func test_numberOfSections_whenAllRequestsHaveSucceededWithProducts_shouldAlwaysReturnFive() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked(results: [.mocked()]))) })
        let expectedResult = totalNumberOfSections
        interactor.viewDidLoad()

        // WHEN & THEN
        asyncAssert {
            let result = self.interactor.numberOfSections
            XCTAssertEqual(result, expectedResult)
        }
    }

    func test_numberOfSections_whenSomeRequestsFail_shouldReturnCorrectNumberOfSections() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { (kind, _, _) in
            switch kind {
            case .comics: return .doNotCall
            default: return .call(.success(.mocked(results: [.mocked()])))
            }
        })

        let expectedResult = totalNumberOfSections - 1
        interactor.viewDidLoad()

        // WHEN & THEN
        asyncAssert {
            let result = self.interactor.numberOfSections
            XCTAssertEqual(result, expectedResult)
        }
    }

    // MARK: - numberOfItemsInSection

    func test_numberOfItemsInSection_whenFirstSection_shouldAlwaysReturnOne() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked(results: [.mocked()]))) })
        let expectedResult = 1
        interactor.viewDidLoad()

        // WHEN
        let result = interactor.numberOfItemsInSection(0)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_numberOfItemsInSection_whenForOtherSections_shouldReturnTheCorrectNumber() {
        // GIVEN
        let results = HeroProduct.mocked().repeat(4)
        mockAPI.getHeroProductsFuncCheck = .init(filter: { _ in .call(.success(.mocked(results: results))) })
        let expectedResult = 4
        interactor.viewDidLoad()

        // WHEN
        let result = interactor.numberOfItemsInSection(1)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - cellTypeForSection

    func test_cellTypeForSection_whenFirstSection_shouldAlwaysReturnPosterCell() {
        // GIVEN
        let expectedResult = DetailCellType.poster

        // WHEN
        let result = interactor.cellTypeForSection(0)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_cellTypeForSection_whenAnyOtherSection_shouldAlwaysReturnCardCell() {
        // GIVEN
        let expectedResult = DetailCellType.card

        // WHEN
        let result = interactor.cellTypeForSection(1)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - product(at indexPath:)

    func test_productAtIndexPath_shouldReturnCorrectValue() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { (kind, _, _) in
            switch kind {
            case .comics: return .call(.success(.mocked(results: [.mocked()])))
            default: return .doNotCall
            }
        })
        interactor.viewDidLoad()

        // WHEN
        let result = interactor.product(at: .init(row: 0, section: 1))

        // THEN
        XCTAssertEqual(result, HeroProduct.mocked())
    }

    // MARK: - titleForSection

    func test_titleForSection_shouldReturnCorrectValue() {
        // GIVEN
        mockAPI.getHeroProductsFuncCheck = .init(filter: { (kind, _, _) in
            switch kind {
            case .comics: return .call(.success(.mocked(results: [.mocked()])))
            default: return .doNotCall
            }
        })
        interactor.viewDidLoad()
        let expectedResult = "Comics"

        // WHEN
        let result = interactor.titleForSection(1)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - favoriteButtonTapped

    func test_favoriteButtonTapped_shouldAlwaysCallFavoritesService() {
        // GIVEN

        // WHEN
        interactor.favoriteButtonTapped()

        // THEN
        XCTAssertTrue(mockFavorites.toggleWithIdFuncCheck.wasCalled(with: MarvelHero.mocked().id))
    }

    func test_favoriteButtonTapped_whenHeroBecameFavorite_shouldCallFavorite() {
        // GIVEN
        mockFavorites.isFavoriteHeroWithIdFuncCheck = .init(stub: true)

        // WHEN
        interactor.favoriteButtonTapped()

        // THEN
        XCTAssertTrue(mockInput.favoriteFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.unfavoriteFuncCheck.wasNotCalled)
    }

    func test_favoriteButtonTapped_whenHeroWasUnfavorited_shouldCallFavorite() {
        // GIVEN
        mockFavorites.isFavoriteHeroWithIdFuncCheck = .init(stub: false)

        // WHEN
        interactor.favoriteButtonTapped()

        // THEN
        XCTAssertTrue(mockInput.unfavoriteFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.favoriteFuncCheck.wasNotCalled)
    }
}
