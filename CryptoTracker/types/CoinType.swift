import Foundation

enum CoinType: String, Identifiable, CaseIterable {
    case bitcoin
    case ethereum
    case dogecoin
    
    var id: Self { self }
    var url: URL { URL(string: "https://coincap.io/assets/\(rawValue)")! }
    var description: String { rawValue.capitalized }
}
