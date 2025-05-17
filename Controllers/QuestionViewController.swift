// Controllers/QuestionViewController.swift

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: – Model
    private var questions: [Question] = []
    private var currentQuestionIndex = 0
    private let prizeList = [2000, 5000, 7500, 10000, 20000, 50000, 100000, 250000, 500000, 1000000]
    private var score = 0
    
    // MARK: – Outlets
    @IBOutlet weak var prizeLabel: UILabel!    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let horizontalPadding: CGFloat = 20
        questionLabel.preferredMaxLayoutWidth = view.bounds.width - horizontalPadding * 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.numberOfLines = 0
        questions = QuestionLoader.loadQuestions()
        showQuestion()
        // Ödül etiketini sığdırmak için:
        prizeLabel.numberOfLines = 1
        prizeLabel.adjustsFontSizeToFitWidth = true
        prizeLabel.minimumScaleFactor = 0.5
    }
    
    private func showQuestion() {
        guard currentQuestionIndex < questions.count else {
            performSegue(withIdentifier: "showResult", sender: nil)
            return
        }
        
        // Ödül etiketini güncelle
        prizeLabel.text = "Ödül: \(prizeList[currentQuestionIndex]) ₺"
        
        let q = questions[currentQuestionIndex]
        questionLabel.text = q.questionText
        for (i, btn) in choiceButtons.enumerated() {
            btn.setTitle(q.options[i], for: .normal)
            btn.tag = i
            btn.isEnabled = true
        }
    }
    
    @IBAction func choiceButtonTapped(_ sender: UIButton) {
        guard currentQuestionIndex < questions.count else { return }
        let correct = questions[currentQuestionIndex].correctIndex
        if sender.tag == correct {
            score = prizeList[currentQuestionIndex]
            currentQuestionIndex += 1
            showQuestion()
        } else {
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult",
           let dest = segue.destination as? ResultViewController {
            dest.finalScore = score
        }
    }
}
