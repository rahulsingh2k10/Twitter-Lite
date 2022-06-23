//
//  Constants.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import Foundation


public enum ConnectionStatus: CustomStringConvertible {
    case none
    case unavailable
    case wifi
    case cellular

    public var description: String {
        switch self {
        case .none: return "unavailable"
        case .cellular: return "Cellular"
        case .wifi: return "WiFi"
        case .unavailable: return "No Connection"
        }
    }
}
