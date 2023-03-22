import SwiftUI

struct PopoverCoinView: View {
    
    @ObservedObject var viewModel: PopoverCoinViewModel
    
    var body: some View {
        Spacer().frame(height: 5)
        VStack(spacing: 13) {
            VStack {
                Text(viewModel.title).font(.largeTitle)
                Text(viewModel.subtitle).font(.title.bold())
            }
            
            Divider()
            
            Picker("Select Coin", selection: $viewModel.selectedCoinType) {
                ForEach(viewModel.coinTypes) { type in
                    HStack {
                        Text(type.description)
                            .font(.headline)
                        Spacer()
                        Text(viewModel.valueText(for: type))
                            .frame(alignment: .trailing)
                            .font(.body)
                        Link(destination: type.url) {
                            Image(systemName: "safari")
                        }
                    }
                    .tag(type)
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
            .labelsHidden()
            .padding(.horizontal, 16)
            
            Divider()
            
            Button("Quit CryptoTracker") {
                NSApp.terminate(self)
            }
        }
        .onChange(of: viewModel.selectedCoinType) { _ in
            viewModel.updateView()
        }
        .onAppear {
            viewModel.subscribeToService()
        }
        .frame(height: 200)
    }
}

struct PopoverCoinView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverCoinView(viewModel: .init(title: "Bitcoin", subtitle: "$28,000"))
    }
}
