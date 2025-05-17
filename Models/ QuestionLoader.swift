// Models/QuestionLoader.swift

import Foundation

class QuestionLoader {
  static func loadQuestions() -> [Question] {
    // 1) JSON dosyamızı bul
    guard
      let url = Bundle.main.url(forResource: "question_bank", withExtension: "json"),
      let data = try? Data(contentsOf: url)
    else {
      print("❌ question_bank.json bulunamadı")
      return []
    }

    // 2) Decode et
    let decoder = JSONDecoder()
    guard let allQuestions = try? decoder.decode([Question].self, from: data) else {
      print("❌ JSON decode hatası")
      return []
    }

    // 3) Soruları 10 eşit havuza böl
    let poolCount = 10
    let poolSize = allQuestions.count / poolCount  // her havuzun büyüklüğü
    var pools: [[Question]] = []
    for i in 0..<poolCount {
      let start = i * poolSize
      let end = (i == poolCount - 1)
        ? allQuestions.count          // son havuz geri kalanı alsın
        : start + poolSize
      let slice = Array(allQuestions[start..<end])
      pools.append(slice)
    }

    // 4) Her havuzdan 1 tane rastgele seç
    var selected: [Question] = []
    for pool in pools {
      if let q = pool.randomElement() {
        selected.append(q)
      }
    }

    return selected   // Toplam 10 soru
  }
}
