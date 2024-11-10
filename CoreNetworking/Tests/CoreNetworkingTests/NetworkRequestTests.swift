import Testing
@testable import CoreNetworking

@Suite("Network Request")
struct NetworkRequestTests {
    typealias SUT = MockNetworkRequest<Bool>
    
    let environment: NetworkEnvironment = .mock()
    
    @Test("Empty request")
    func testEmptyRequest() {
        // GIVEN request with no headers
        let sut = SUT(
            path: "",
            headers: [:]
        )
        
        // WHEN generating the URL
        let url = sut.url(environment: environment)
        
        // THEN url is just the domain+path, with no query items
        #expect(sut.headerQueryItems.isEmpty)
        #expect(url?.absoluteString == environment.domain + environment.basePath)
    }
    
    @Test("Request with path and headers")
    func testRequestWithPathAndHeaders() {
        // GIVEN request with path and headers
        let sut = SUT(
            path: "/path",
            headers: ["key": "value"]
        )
        
        // WHEN generating the URL
        let url = sut.url(environment: environment)
        
        // THEN url is domain + path + query items
        #expect(sut.headerQueryItems.count == 1)
        
        let expectedURLString = environment.domain + environment.basePath + "/path?key=value"
        #expect(url?.absoluteString == expectedURLString)
    }
}
