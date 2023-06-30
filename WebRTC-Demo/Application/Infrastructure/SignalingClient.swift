//
//  SignalingClient.swift
//  WebRTC-Demo
//
//  Created by Ангеліна Семенченко on 26.06.2023.
//

import Foundation

protocol SignalingClientDelegate: AnyObject {
    func signalingClient(_ client: SignalingClient, didReceiveRemoteSdp sdp: SessionDescription)
    func signalingClient(_ client: SignalingClient, didReceiveCandidate candidate: IceCandidate)
}

enum SignalError: Error {
    case invalidData
    case decodingError(Error)
}


final class SignalingClient {
    private let webSocketService: WebSocketService
    weak var delegate: SignalingClientDelegate?
    
    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
    }
    
    // Send a message to the signaling server
    func send(signal: SignalingMessage) {
        let messageData = try! JSONEncoder().encode(signal)
        
        if let messageString = String(data: messageData, encoding: .utf8) {
            webSocketService.sendMessage(messageString)
        }
    }
    
    // Receive a message from the signaling server
    func receive(messageData: String) throws {
        guard let messageData = messageData.data(using: .utf8) else {
            throw SignalError.invalidData
        }
        
        do {
            let signal = try JSONDecoder().decode(SignalingMessage.self, from: messageData)
            handleSignal(signal)
        } catch {
            throw SignalError.decodingError(error)
        }
    }
    
    private func handleSignal(_ signal: SignalingMessage) {
        switch signal {
        case .offer(let sdp):
            delegate?.signalingClient(self, didReceiveRemoteSdp: sdp)
        case .answer(let sdp):
            delegate?.signalingClient(self, didReceiveRemoteSdp: sdp)
        case .candidate(let candidate):
            delegate?.signalingClient(self, didReceiveCandidate: candidate)
        }
    }
}
