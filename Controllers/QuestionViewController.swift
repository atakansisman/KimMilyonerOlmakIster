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
    @IBOutlet weak var timerLabel: UILabel!
    
    private var timer: Timer?
    private var timeRemaining: Int = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let horizontalPadding: CGFloat = 20
        questionLabel.preferredMaxLayoutWidth = view.bounds.width - horizontalPadding * 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.numberOfLines = 0
        prizeLabel.numberOfLines = 1
        prizeLabel.adjustsFontSizeToFitWidth = true
        prizeLabel.minimumScaleFactor = 0.5
        
        questions = QuestionLoader.loadQuestions()
        showQuestion()
    }
    
    private func showQuestion() {
        guard currentQuestionIndex < questions.count else {
            performSegue(withIdentifier: "showResult", sender: nil)
            timer?.invalidate()
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
        // Sayaç başlat
        startTimerForCurrentQuestion()
    }
    private func startTimerForCurrentQuestion() {
           // Sorunun indexine göre süre belirle
           switch currentQuestionIndex {
           case 0, 1:
               timeRemaining = 20
           case 2...4:
               timeRemaining = 45
           case 5...6:
               timeRemaining = 60
           default:
               timeRemaining = Int.max // sınırsız
           }
           updateTimerLabel()
           
           // Eğer önceden bir timer çalışıyorsa iptal et
           timer?.invalidate()
           
           // Süre sınırsız değilse timer başlat
           if timeRemaining != Int.max {
               timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                   self?.tick()
               }
           }
       }
       
       private func tick() {
           guard timeRemaining > 0 else {
               timer?.invalidate()
               // Süre dolunca sonuç sayfasına geç
               performSegue(withIdentifier: "showResult", sender: nil)
               return
           }
           timeRemaining -= 1
           updateTimerLabel()
       }
       
       private func updateTimerLabel() {
           if timeRemaining == Int.max {
               timerLabel.text = "--:--"
           } else {
               let m = timeRemaining / 60
               let s = timeRemaining % 60
               timerLabel.text = String(format: "%02d:%02d", m, s)
           }
       }
    
    @IBAction func choiceButtonTapped(_ sender: UIButton) {
        // Seçim yapıldığında timer'ı durdur
        timer?.invalidate()
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
            
            // 1) Puanı geçir
            dest.finalScore = score
            
            // 2) Sorunun index’ini dizinin bounds’ları içinde tut
            let questionIdx = max(0, min(currentQuestionIndex, questions.count - 1))
            
            // 3) Doğru cevabın metnini geçir
            let correctIdx  = questions[questionIdx].correctIndex
            let correctText = questions[questionIdx].options[correctIdx]
            dest.Answer = correctText
        }
    }


    @IBAction func withdrawButtonTapped(_ sender: UIButton) {
        // Çekilince timer'ı durdur ve bir önceki ödülü ver
        timer?.invalidate()
        if currentQuestionIndex > 0 {
            // en son doğru tamamlanan sorunun ödülünü al
            score = prizeList[currentQuestionIndex - 1]
        } else {
            score = 0
        }
        performSegue(withIdentifier: "showResult", sender: nil)
    }

}
