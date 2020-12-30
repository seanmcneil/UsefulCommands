 import XCTest
 import Combine

 @testable import BiometricAuthentication

 final class BiometricAuthenticationTests: XCTestCase {
    private let timeout: TimeInterval = 2.0
    
    private var cancelleables = Set<AnyCancellable>()

    func testNoBiometricsDefault() {
        let mockContext = MockContext()
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.biometryType, .none)
    }

    func testFaceID() {
        let mockContext = MockContext(mockBiometryType: .faceID)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.biometryType, .faceID)
    }

    func testTouchID() {
        let mockContext = MockContext(mockBiometryType: .touchID)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.biometryType, .touchID)
    }

    func testLoginNoID() {
        let mockContext = MockContext()
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .dropFirst()
            .sink { action in
                switch action {
                case .error(let error):
                    switch error {
                    case .unsupportedHardware:
                        expect.fulfill()
                        
                    default:
                        XCTFail("Unexpected result")
                    }
                    
                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testLoginFaceID() {
        let mockContext = MockContext(mockBiometryType: .faceID,
                                      isAuthenticated: true)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .sink { action in
                switch action {
                case .authenticated:
                    // Handle authentication
                
                case .notAuthenticated:
                    // Handle sign out
                
                case .error(let error):
                    switch error {
                    case .authenticationFailed:
                        // User was denied access
                        
                    case .unsupportedHardware:
                        // The device does not support biometrics
                    }
                }
            }
            .store(in: &cancelleables)
        
        ba.$authenticationAction
            .dropFirst()
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testLoginTouchID() {
        let mockContext = MockContext(mockBiometryType: .touchID,
                                      isAuthenticated: true)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .dropFirst()
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testRepeatLoginTouchID() {
        let mockContext = MockContext(mockBiometryType: .touchID,
                                      isAuthenticated: true)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .dropFirst(3)
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()
        ba.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testLoginFaceIDFailed() {
        let mockContext = MockContext(mockBiometryType: .faceID)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .dropFirst()
            .sink { action in
                switch action {
                case .error(let error):
                    switch error {
                    case .authenticationFailed:
                        expect.fulfill()
                        
                    default:
                        XCTFail("Unexpected result")
                    }
                    
                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    /// Verifies that a user state is changed to non authenticated
    func testSignOut() {
        let mockContext = MockContext(mockBiometryType: .touchID,
                                      isAuthenticated: true)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        let expect = expectation(description: "expect")
        ba.$authenticationAction
            .dropFirst(2)
            .sink { action in
                switch action {
                case .notAuthenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        ba.login()
        ba.logout()

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    /// Ensures that there is no update to the authenticationAction
    /// since the user starts in the non authenticated state
    func testSignOutFailed() {
        let mockContext = MockContext(mockBiometryType: .touchID)
        let ba = BiometricAuthentication(context: mockContext,
                                         cancelTitle: "cancel",
                                         reason: "reason")
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)

        ba.$authenticationAction
            .dropFirst()
            .sink { _ in
                XCTFail("Unexpected result")
            }
            .store(in: &cancelleables)

        ba.logout()
        XCTAssertEqual(ba.authenticationAction, .notAuthenticated)
    }
 }
