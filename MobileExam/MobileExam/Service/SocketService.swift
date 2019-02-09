//
//  SocketService.swift
//  MobileExam
//
//  Created by Suciu Radu on 08/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import Starscream

class SocketService<T: Codable>: WebSocketDelegate {
    
    // MARK: - Private properties
    
    private let socket = WebSocket(url: URL(string: "http://172.30.112.18:3000")!)
    
    // MARK: - Public properties
    
    var didRecieveObject: (T) -> Void = { object in }
    
    // MARK: - Lifecycle
    
    init() {
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: - WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Did connect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let data = text.data(using: .utf8, allowLossyConversion: false) {
            guard let product = try? JSONDecoder().decode(T.self, from: data) else { return }
            didRecieveObject(product)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        print("Got pong! Maybe some data: \(String(describing: data?.count))")
    }
}
