import XCTest
@testable import MarvelAppFramework

class HeroListInteractorTests: XCTestCase {
    var mockAPI: MockAPI!
    var mockInput: MockHeroListInput!
    var interactor: HeroListInteractor!
    let pageSize = 20

    override func setUp() {
        mockAPI = MockAPI()
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: pageSize))))
        mockInput = MockHeroListInput()
        interactor = HeroListInteractor()
        interactor.view = mockInput
        AppEnvironment.pushEnvironment(mockAPI)
    }

    override func tearDown() {
        AppEnvironment.popEnvironment()
    }

    // MARK: - viewDidLoad

    func test_viewDidLoad_shouldCallShowLoadingOnInput() {
        // GIVEN

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.showLoadingFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.showLoadingFuncCheck.callCount == 1)
    }

    func test_viewDidLoad_onSuccessfulRequest_shouldHideLoadingOnInput() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.success(.mocked()))

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.hideLoadingFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.hideLoadingFuncCheck.callCount == 1)
    }

    func test_viewDidLoad_onFailedRequest_shouldHideLoadingOnInput() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.failure)

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.hideLoadingFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.hideLoadingFuncCheck.callCount == 1)
    }

    func test_viewDidLoad_onSuccessfulRequest_shouldCallReloadData() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.success(.mocked()))

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.reloadDataFuncCheck.callCount == 1)
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasCalled(after: mockInput.hideLoadingFuncCheck))
    }

    func test_viewDidLoad_onFailedRequest_shouldNotCallReloadData() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.failure)

        // WHEN
        interactor.viewDidLoad()

        // THEN
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasNotCalled)
    }

    // MARK: - willDisplayCellAtIndex

    func test_willDisplayCellAtIndex_whenNotAtLastCell_shouldNotTriggerPagination() {
        // GIVEN
        interactor.viewDidLoad()
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(0)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    func test_willDisplayCellAtIndex_whenAtLastCell_shouldTriggerPagination() {
        // GIVEN
        interactor.viewDidLoad()
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasCalled)
    }

    func test_willDisplayCellAtIndex_whenTriggersPagination_shouldTriggerRequestWithCorrectOffset() {
        // GIVEN
        interactor.viewDidLoad()
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasCalled(with: (nil, 20)))
    }

    func test_willDisplayCellAtIndex_whenTriggersPaginationAndRequestIsSuccessful_shouldReloadData() {
        // GIVEN
        interactor.viewDidLoad()
        mockInput.reloadDataFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasCalled)
        XCTAssertTrue(mockInput.reloadDataFuncCheck.callCount == 1)
    }

    func test_willDisplayCellAtIndex_whenTriggersPaginationAndRequestIsSuccessful_shouldReturnCorrectNumberOfHeroes() {
        // GIVEN
        interactor.viewDidLoad()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(interactor.numberOfHeroes == pageSize * 2)
    }

    func test_willDisplayCellAtIndex_whenTriggersPaginationAndRequestFails_shouldUseSameOffsetOnNextRequest() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.success(.mocked()))
        interactor.viewDidLoad()
        mockAPI.getHeroesStub = .call(.failure)
        interactor.willDisplayCellAtIndex(pageSize)
        mockAPI.getHeroesStub = .call(.success(.mocked()))
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasCalled(with: (nil, pageSize)))
    }

    func test_willDisplayCellAtIndex_whenAtLastCellAndNextPageIsFetching_shouldNotTriggerRequest() {
        // GIVEN
        interactor.viewDidLoad()
        mockAPI.getHeroesStub = .doNotCall
        interactor.willDisplayCellAtIndex(pageSize)
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    func test_willDisplayCellAtIndex_whenAtLastCellAndNextPageIsNotFetchingAndAllPagesAreLoaded_shouldNotTriggerRequest() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: pageSize), total: pageSize)))
        interactor.viewDidLoad()
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    func test_willDisplayCellAtIndex_whenAtLastCellAndNextPageIsNotFetchingAndNotAllPagesAreLoadedAndInSearchMode_shouldNotTriggerRequest() {
        // GIVEN
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: pageSize), total: pageSize * 2)))
        interactor.viewDidLoad()
        mockAPI.getHeroesFuncCheck.reset()
        interactor.searchBarDidEndEditingWithText("Whatever text")
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.willDisplayCellAtIndex(pageSize)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    // MARK: - heroForIndex

    func test_heroForIndex_whenNotInSearchMode_shouldReturnCorrectHero() {
        // GIVEN
        let expectedResult = MarvelHero.mocked(name: "Main List Hero")
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: expectedResult, count: pageSize))))
        interactor.viewDidLoad()


        // WHEN
        let result = interactor.heroForIndex(0)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_heroForIndex_whenInSearchMode_shouldReturnCorrectHero() {
        // GIVEN
        let mainHeroListResult = MarvelHero.mocked(name: "Main List Hero")
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: mainHeroListResult, count: pageSize))))
        interactor.viewDidLoad()
        let expectedResult = MarvelHero.mocked(name: "Search List Hero")
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: expectedResult, count: pageSize))))
        interactor.searchBarDidEndEditingWithText("Some text")

        // WHEN
        let result = interactor.heroForIndex(0)

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - numberOfHeroes

    func test_numberOfHeroes_whenNotInSearchMode_shouldReturnCorrectNumber() {
        // GIVEN
        let expectedResult = pageSize
        interactor.viewDidLoad()


        // WHEN
        let result = interactor.numberOfHeroes

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_numberOfHeroes_whenInSearchMode_shouldReturnCorrectNumber() {
        // GIVEN
        interactor.viewDidLoad()
        let expectedResult = pageSize + 10
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: expectedResult), total: pageSize * 2)))
        interactor.searchBarDidEndEditingWithText("Some text")

        // WHEN
        let result = interactor.numberOfHeroes

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - searchBarDidEndEditingWithText

    func test_searchBarDidEndEditingWithText_whenNilText_shouldNotTriggerRequest() {
        // GIVEN
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.searchBarDidEndEditingWithText(nil)

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    func test_searchBarDidEndEditingWithText_whenEmptyText_shouldNotTriggerRequest() {
        // GIVEN
        mockAPI.getHeroesFuncCheck.reset()

        // WHEN
        interactor.searchBarDidEndEditingWithText("")

        // THEN
        XCTAssertTrue(mockAPI.getHeroesFuncCheck.wasNotCalled)
    }

    func test_searchBarDidEndEditingWithText_whenSuccessfulRequest_shouldCallReloadData() {
        // GIVEN
        mockAPI.getHeroesFuncCheck.reset()
        mockInput.reloadDataFuncCheck.reset()

        // WHEN
        interactor.searchBarDidEndEditingWithText("Hulk")

        // THEN
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasCalled)
    }

    // MARK: - shouldShowFooter

    func test_shouldShowFooter_whenNoHeroesLoadedYet_shouldReturnFalse() {
        // GIVEN
        let expectedResult = false

        // WHEN
        let result = interactor.shouldShowFooter

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_shouldShowFooter_whenHasLoadedHeroesAndIsInSearchMode_shouldReturnFalse() {
        // GIVEN
        let expectedResult = false
        interactor.viewDidLoad()
        interactor.searchBarDidEndEditingWithText("Whatever text")

        // WHEN
        let result = interactor.shouldShowFooter

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_shouldShowFooter_whenHasLoadedHeroesAndIsNotInSearchModeAndAllPagesLoaded_shouldReturnFalse() {
        // GIVEN
        let expectedResult = false
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: pageSize), total: pageSize)))
        interactor.viewDidLoad()

        // WHEN
        let result = interactor.shouldShowFooter

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    func test_shouldShowFooter_whenHasLoadedHeroesAndIsNotInSearchModeAndNotAllPagesLoaded_shouldReturnTrue() {
        // GIVEN
        let expectedResult = true
        mockAPI.getHeroesStub = .call(.success(.mocked(results:.init(repeating: .mocked(), count: pageSize), total: pageSize * 2)))
        interactor.viewDidLoad()

        // WHEN
        let result = interactor.shouldShowFooter

        // THEN
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - willDismissSearch

    func test_willDismissSearch_shouldCallReloadData() {
        // GIVEN


        // WHEN
        interactor.willDismissSearch()

        // THEN
        XCTAssertTrue(mockInput.reloadDataFuncCheck.wasCalled)
    }

    func test_willDismissSearch_shouldExitSearchMode() {
        // GIVEN
        let mainHeroesCount = interactor.numberOfHeroes
        interactor.searchBarDidEndEditingWithText("Some text")
        let searchHeroesCount = interactor.numberOfHeroes

        // WHEN
        interactor.willDismissSearch()

        // THEN
        XCTAssertEqual(searchHeroesCount, pageSize)
        XCTAssertEqual(mainHeroesCount, interactor.numberOfHeroes)
    }
}
