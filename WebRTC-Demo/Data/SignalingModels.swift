//
//  SignalingModels.swift
//  WebRTC-Demo
//
//  Created by Ангеліна Семенченко on 26.06.2023.
//

import Foundation

enum SignalingMessage: Codable {
    case offer(SessionDescription)
    case answer(SessionDescription)
    case candidate(IceCandidate)
}

struct SessionDescription: Codable {
    let sdp: String
    let type: String
}

struct IceCandidate: Codable {
    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String?
}
