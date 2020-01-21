//
//  QuoteServiceTestCase.swift
//  QuoteServiceTestCase
//
//  Created by Steve Bernard on 19/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

@testable import ClassQuote
import XCTest

class QuoteServiceTestCase: XCTestCase {
    // Premier Test
    func testGetQuoteShouldPostFailedCallbackError() {

        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData().error),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.08)

    }

    // Deuxieme Test
    func testGetQuoteShouldPostFailedCallbackIfNoData() {

        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.08)

    }

    // Troisieme Test
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {

        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData().quoteCorrectData, response: FakeResponseData().responseKO, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.08)

    }
    // Troisieme Test
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {

        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData().quoteIncorrectData, response: FakeResponseData().responseOK, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.08)

    }

    
    // Quatrieme Test
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {

        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData().quoteCorrectData, response: FakeResponseData().responseOK, error: nil),
            imageSession: URLSessionFake(data: FakeResponseData().imageData, response: FakeResponseData().responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { (success, quote) in
            // Then
            let text = "Anticipate the difficult by managing the easy."
            let author =  "Lao Tzu"
            let imageData = "image".data(using: .utf8)!

            XCTAssertTrue(success)
            XCTAssertNotNil(quote)
            XCTAssertEqual(text, quote!.text)
            XCTAssertEqual(author, quote!.author)
            XCTAssertEqual(imageData, quote!.imageData)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.08)

    }
}
