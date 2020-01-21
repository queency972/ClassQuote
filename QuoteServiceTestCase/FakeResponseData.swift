//
//  FakeResponseData.swift
//  QuoteServiceTestCase
//
//  Created by Steve Bernard on 19/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

import Foundation

// Gerer les donnés de test.
class FakeResponseData {

    // Simuler response
    let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                     statusCode: 200, httpVersion: nil, headerFields: nil)!
    let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                     statusCode: 500, httpVersion: nil, headerFields: nil)!

    class QuoteError: Error {}
    let error = QuoteError()

    // Propriété calculé
    var quoteCorrectData: Data {
        // Bundle qui contient le fichier de la classe dans laquelle on se trouve.
        let bundle = Bundle(for: FakeResponseData.self)
        // Récupration du URL à laquelle se trouve notre fichier en indiquant le nom et l'extension qu'on recherche.
        let url = bundle.url(forResource: "Quote", withExtension: "json")
        // Récuperer les données contenu à cette URL.
        let data = try! Data(contentsOf: url!)
        // On renvoi data.
        return data
    }

    let quoteIncorrectData = "erreur".data(using: .utf8)!

    let imageData = "image".data(using: .utf8)!
}
