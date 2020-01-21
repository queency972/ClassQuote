//
//  URLSessionFake.swift
//  QuoteServiceTestCase
//
//  Created by Steve Bernard on 20/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

import Foundation

class URLSessionFake: URLSession {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    // On initialise la classe URLSessionFake() avec ces données ci-dessous.
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }

}

class URLSessionDataTaskFake: URLSessionDataTask {

    // Block de retour à utiliser
    var completionHandler:  ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() {}
}
