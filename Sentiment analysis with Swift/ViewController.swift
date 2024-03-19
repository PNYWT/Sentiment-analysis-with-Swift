//
//  ViewController.swift
//  Sentiment analysis with Swift
//
//  Created by Dev on 19/3/2567 BE.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {
    
    private lazy var textFieldInpud:UITextField! = {
        let text = UITextField(frame: .zero)
        text.borderStyle = .line
        text.layer.cornerRadius = 8
        text.placeholder = "Input somthing"
        text.delegate = self
        return text
    }()
    
    private lazy var btnSentimentScore:UIButton! = {
        let button = UIButton(frame: .zero)
        button.setTitle("Hit now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(actionSentimentScore(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lbSentimentScore:UILabel! = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "Score: "
        return label
    }()
    private lazy var lbSentiment:UILabel! = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "Sentiment: "
        return label
    }()
    
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textFieldInpud)
        view.addSubview(btnSentimentScore)
        view.addSubview(lbSentimentScore)
        view.addSubview(lbSentiment)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldInpud.frame = CGRect(x: (view.frame.width - 200) / 2.0, y: view.frame.width - 50, width: 200, height: 50)
        btnSentimentScore.frame = CGRect(x: (view.frame.width - 120) / 2.0, y: textFieldInpud.frame.origin.y + textFieldInpud.frame.height + 16, width: 120, height: 50)
        lbSentimentScore.frame = CGRect(x: (view.frame.width - 200) / 2.0, y: btnSentimentScore.frame.origin.y + btnSentimentScore.frame.height + 16, width: 200, height: 20)
        lbSentiment.frame = CGRect(x: (view.frame.width - 200) / 2.0, y: lbSentimentScore.frame.origin.y + lbSentimentScore.frame.height + 8, width: 200, height: 20)
    }

    @objc private func actionSentimentScore(_ sender:UIButton!){
        guard let text = textFieldInpud.text else{
            textFieldInpud.becomeFirstResponder()
            return
        }
        setupNLP(withText: text)
    }
    
    private func setupNLP(withText:String){
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = withText
        let sentiment = tagger.tag(at: withText.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        
        guard let sentimentScore = sentiment?.rawValue, let score = Double(sentimentScore) else{
            lbSentimentScore.text = "Score: "
            lbSentiment.text = "Sentiment: "
            print("Could not identify sentiment.")
            return
        }
        
        lbSentimentScore.text = "Score: \(score)"
        if score > 0 {
            lbSentiment.text = "Sentiment: positive."
        } else if score < 0 {
            lbSentiment.text = "Sentiment: negative."
        } else {
            lbSentiment.text = "Sentiment: neutral."
        }
    }
}

extension ViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lbSentimentScore.text = "Score: "
        lbSentiment.text = "Sentiment: "
    }
}
