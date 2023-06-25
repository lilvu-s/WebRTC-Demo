//
//  Config.swift
//  WebRTC-Demo
//
//  Created by Ангеліна Семенченко on 26.06.2023.
//

import Foundation

fileprivate let defaultSignalingServerUrl = URL(string: "ws://localhost:8080")

// Google's public stun servers
fileprivate let defaultIceServers = ["stun:stun.l.google.com:19302",
                                     "stun:stun1.l.google.com:19302",
                                     "stun:stun2.l.google.com:19302",
                                     "stun:stun3.l.google.com:19302",
                                     "stun:stun4.l.google.com:19302"]

struct Config {
    let signalingServerUrl: URL
    let webRTCIceServers: [String]
    
    static var `default`: Config? {
        guard let url = defaultSignalingServerUrl else { return nil }
        return Config(signalingServerUrl: url, webRTCIceServers: defaultIceServers)
    }
}
