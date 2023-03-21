import Combine
import Foundation
import Network

class CoinCapPriceService: NSObject {
    private let session = URLSession(configuration: .default)
    private var wsTask: URLSessionWebSocketTask?
    
    private let coinDictionarySubject = CurrentValueSubject<[String: Coin], Never>([:])
    private var coinDictionary: [String: Coin] { coinDictionarySubject.value }
    
    private let connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    private var isConnected: Bool { connectionStateSubject.value }
    
    func connect() {
        let coins = CoinType.allCases
            .map { $0.rawValue }
            .joined(separator: ",")
        
        let url = URL(string: "wss://ws.coincap.io/prices?assets=\(coins)")!
        wsTask = session.webSocketTask(with: url)
        wsTask?.delegate = self
        wsTask?.resume()
    }
    
    private func recieveMessage() {
        wsTask!.receive { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                    if let data = text.data(using: .utf8) {
                        self?.onReceiveData(data)
                    }
                case .data(let data):
                    print("Received binary data: \(data)")
                    self?.onReceiveData(data)
                default: break
                }
                self?.recieveMessage()
            case .failure(let error):
                print("Failed to receive message: \(error.localizedDescription)")
            }
        }
    }
    
    private func onReceiveData(_ data: Data) {
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String] else { return }
        
        var newDict = [String: Coin]()
        dict.forEach { (key,value) in
            let value = Double(value) ?? 0
            newDict[key] = Coin(name: key.capitalized, value: value)
        }
        
        let mergedDict = coinDictionary.merging(newDict) { $1 }
        coinDictionarySubject.send(mergedDict)
    }
    
    
    deinit {
        coinDictionarySubject.send(completion: .finished)
        connectionStateSubject.send(completion: .finished)
    }
}

extension CoinCapPriceService: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
    }
}

