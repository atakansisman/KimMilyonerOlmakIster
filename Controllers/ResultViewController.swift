//
//  ResultViewController.swift
//  KimMilyonerOlmakIster
//
//  Created by Atakan Şişman on 30.04.2025.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var finalScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Tebrikler! \(finalScore) TL kazandınız."
    }

    @IBAction func restartGameTapped(_ sender: UIButton) {
        if let startVC = storyboard?.instantiateViewController(withIdentifier: "StartViewController") {
            startVC.modalPresentationStyle = .fullScreen
            self.present(startVC, animated: true, completion: nil)
        }
    }
}


