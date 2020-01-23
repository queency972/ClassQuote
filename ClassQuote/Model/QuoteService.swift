//
//  QuoteService.swift
//  ClassQuote
//
//  Created by Steve Bernard on 18/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

import Foundation

class QuoteService {

    // Pattern Singleton qui permet à une classe d'avoir une unique instance
    static var shared = QuoteService()
    private init() {}

    // Creation d'un requete, instance URLSessionTask pour l'appel reseau.
    private static let quoteURL = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "https://source.unsplash.com/random/1000x1000")!

    private var task: URLSessionDataTask?
    // On crée la tache.

    // Injection de dependance.
    private var quoteSession =  URLSession(configuration: .default)
    private var imageSession =  URLSession(configuration: .default)

    init(quoteSession: URLSession, imageSession: URLSession) {
        self.quoteSession = quoteSession
        self.imageSession = imageSession
    }

    // Récuparation de la citation via une requete.
    func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        task?.cancel()

        let request = createQuoteRequest()

        task = quoteSession.dataTask(with: request) { (data, response, error) in
            // Tout ce qui touche à l'interface doit avoir lieu dans la main Queue, On place ce block dans la Main Queue.
            DispatchQueue.main.async {
                // Verification des données et si il n'y a pas d'erreur.
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                // On verifie que nous avons une reponse qui a pour code 200.
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                // On decode le JSON en un dictionnaire qui comme clé String et valeur String.
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    // On extrait le texte.
                    let text = responseJSON["quoteText"],
                    // On extrait le l'auteur
                    let author = responseJSON["quoteAuthor"] else {
                        callback(false, nil)
                        return
                }

                self.getImage { (data) in
                    guard let data = data else {
                        callback(false, nil)
                        return
                    }
                    let quote = Quote(text: text, author: author, imageData: data)
                    callback(true, quote)
                }
            }
        }
        // Lancement de la tache.
        task?.resume()
    }

    private func createQuoteRequest()  -> URLRequest {
        var request = URLRequest(url: QuoteService.quoteURL)
        // On choisit la method.
        request.httpMethod = "POST"

        // On défini les parametres de la requete.
        let body = "method=getQuote&format=json&lang=en"
        request.httpBody = body.data(using: .utf8)
        return request
    }

    // Récuparation de l'image via une requete.
    private func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        // On crée la tache.

        task?.cancel()
        task = imageSession.dataTask(with: QuoteService.pictureURL) { (data, response, error) in
            // Tout ce qui touche à l'interface doit avoir lieu dans la main Queue
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                completionHandler(data)
            }
        }
        task?.resume()
    }
}
