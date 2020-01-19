//
//  ViewController.swift
//  ClassQuote
//
//  Created by Ambroise COLLON on 08/03/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newQuoteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToQuoteLabel()
    }

    private func addShadowToQuoteLabel() {
        quoteLabel.layer.shadowColor = UIColor.black.cgColor
        quoteLabel.layer.shadowOpacity = 0.9
        quoteLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    private func update(quote: Quote) {
        imageView.image = UIImage(data: quote.imageData)
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
    }

    @IBAction func tappedNewQuoteButton() {
        QuoteService.getQuote { (success, quote) in
            if success, let quote = quote {
                self.update(quote: quote)
            } else {
                self.presentAlert()
            }
        }
    }

    private func presentAlert() {
        // On crée l'alerte.
               let alertVC = UIAlertController(title: "Error", message: "The quote download failed", preferredStyle: .alert)
               // On crée l'action.
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               // Et on présente l'alerte.
               present(alertVC, animated: true, completion: nil)
           }
    }

