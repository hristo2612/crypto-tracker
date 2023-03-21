import SwiftUI

struct PopoverCoinView: View {
    var body: some View {
        Spacer().frame(height: 10)
        VStack(spacing: 13) {
            VStack {
                Text("Bitcoin").font(.largeTitle)
                Text("28,000$").font(.title.bold())
            }
            
            Divider()
            
            Button("Quit CryptoTracker") {
                NSApp.terminate(self)
            }
        }
    }
}

struct PopoverCoinView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverCoinView()
    }
}
