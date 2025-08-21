// AgoraTestView.swift
import SwiftUI

struct AgoraTestView: View {
    @StateObject private var viewModel = AgoraTestViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - Connection Section
                Section(header: Text("Connection")) {
                    TextField("Channel Name", text: $viewModel.channelName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    TextField("Token (Optional)", text: $viewModel.token)
                    
                    HStack {
                        Button("Join Channel") {
                            viewModel.joinChannel()
                        }
                        .disabled(viewModel.isConnected)
                        
                        Spacer()
                        
                        Button("Leave Channel") {
                            viewModel.leaveChannel()
                        }
                        .disabled(!viewModel.isConnected)
                    }
                }
                
                // MARK: - In-Call Controls Section
                Section(header: Text("Controls")) {
                    HStack {
                        Button(action: viewModel.toggleMute) {
                            Label(viewModel.isMuted ? "Unmute" : "Mute", systemImage: viewModel.isMuted ? "mic.slash.fill" : "mic.fill")
                        }
                        
                        Spacer()
                        
                        Button(action: viewModel.toggleSpeaker) {
                            Label(viewModel.isSpeakerEnabled ? "Earpiece" : "Speaker", systemImage: viewModel.isSpeakerEnabled ? "speaker.wave.2.fill" : "speaker.fill")
                        }
                    }
                }
                .disabled(!viewModel.isConnected)
                
                // MARK: - Status Section
                Section(header: Text("Status")) {
                    HStack {
                        Text("Connection Status:")
                        Spacer()
                        Text(viewModel.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(viewModel.isConnected ? .green : .red)
                    }
                    HStack {
                        Text("My UID:")
                        Spacer()
                        Text(viewModel.myUid != nil ? "\(viewModel.myUid!)" : "N/A")
                    }
                    VStack(alignment: .leading) {
                        Text("Remote Users (\(viewModel.remoteUids.count)):")
                        if viewModel.remoteUids.isEmpty {
                            Text("None").foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.remoteUids, id: \.self) { uid in
                                Text("- \(uid)")
                            }
                        }
                    }
                }
                
                // MARK: - Log Section
                Section(header: Text("Event Log")) {
                    List(viewModel.logMessages, id: \.self) { message in
                        Text(message)
                            .font(.system(size: 12, design: .monospaced))
                    }
                    .frame(height: 200)
                }
            }
            .navigationTitle("Agora Manager Test")
        }
    }
}

struct AgoraTestView_Previews: PreviewProvider {
    static var previews: some View {
        AgoraTestView()
    }
}
