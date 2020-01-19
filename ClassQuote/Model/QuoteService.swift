//
//  QuoteService.swift
//  ClassQuote
//
//  Created by Steve Bernard on 18/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

import Foundation

class QuoteService {
    // Creation d'un requete, instance URLSessionTask pour l'appel reseau.
    private static let quoteURL = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "https://source.unsplash.com/random/1000x1000")!


    // Récuparation de la citation via une requete.
    static func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        var request = URLRequest(url: quoteURL)
        // On choisit la method.
        request.httpMethod = "POST"

        // Les parametres de la requete.
        let body = "method=getQuote&format=json&lang=en"
        request.httpBody = body.data(using: .utf8)

        // On crée la tache.
        let session =  URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                // Verification des données et si il n'y a pas d'erreur.
                if let data = data, error == nil {
                    // On verifie que nous avons une reponse qui a pour code 200.
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        // On decode le JSON en un dictionnaire qui comme clé String et valeur String.
                        if let responseJSON = try? JSONDecoder() .decode([String: String].self, from: data),
                            // On extrait le texte.
                            let text = responseJSON["quoteText"],
                            // On extrait le texte.
                            let author = responseJSON["quoteAuthor"] {
                            getImage { (data) in
                                if let data = data {
                                    let quote = Quote(text: text, author: author, imageData: data)
                                    callback(true, quote)
                                } else {
                                    callback(false, nil)
                                }
                            }
                        } else {
                            callback(false, nil)
                        }
                    } else {
                        callback(false, nil)
                    }
                } else {
                    callback(false, nil)
                }
            }

        }
        // Lancement de la tache.
        task.resume()
    }

    // Récuparation de l'image via une requete.
    private static func getImage(completionHandler: @escaping (Data?) -> Void) {
        // On crée la tache.
        let session =  URLSession(configuration: .default)
        let task = session.dataTask(with: pictureURL) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        completionHandler(data)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            }

        }
        task.resume()
    }
}
