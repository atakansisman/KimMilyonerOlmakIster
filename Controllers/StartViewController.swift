//
//  StartViewController.swift
//  KimMilyonerOlmakIster
//
//  Created by Atakan Şişman on 30.04.2025.
//
import UIKit

class StartViewController: UIViewController {
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("Başla butonuna tıklandı")
        performSegue(withIdentifier: "startToQuestion", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
