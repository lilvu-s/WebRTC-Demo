//
//  WebRTCManager.swift
//  WebRTC-Demo
//
//  Created by Ангеліна Семенченко on 26.06.2023.
//

import Foundation
import WebRTC

final class WebRTCManager: NSObject {
    private lazy var peerConnectionFactory: RTCPeerConnectionFactory = {
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
    }()
    
    private lazy var peerConnection: RTCPeerConnection = {
        let configuration = RTCConfiguration()
        configuration.iceServers = config.webRTCIceServers.map { RTCIceServer(urlStrings: [$0]) }
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        if let peerConnection = peerConnectionFactory.peerConnection(with: configuration, constraints: constraints, delegate: self) {
            return peerConnection
        } else {
            fatalError("Peer connection has not been set")
        }
    }()
    
    private var socket: WebSocketService
    private var config: Config
    
    init?(socket: WebSocketService, config: Config? = Config.default) {
        guard let unwrappedConfig = config else {
            return nil
        }
        self.socket = socket
        self.config = unwrappedConfig
        super.init()
    }
}

// MARK: - Need to handle signalling, offers, answers and ICE candidates in RTCPeerConnectionDelegate

extension WebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("Signaling state changed: \(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("Stream was added: \(stream)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        print("Stream was removed: \(stream)")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        print("Should negotiate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("Connection state changed: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("Gathering state changed: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        // MARK: - Need to handle the ICE candidates that are generated by the local peer
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("Candidates were removed: \(candidates)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("Data channel was opened: \(dataChannel)")
    }
}

