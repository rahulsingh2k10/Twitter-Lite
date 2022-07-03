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


public enum EncodingeError: Error {
    case encodingFailed
    case decodingFailed
}


public enum LoginError: Error {
    case missingClientID
    case invalidTokenID
    case missingParameters

    public var errorDescription: String? {
        switch self {
        case .missingClientID:
            return NSLocalizedString("Missing Client ID. Please try again.", comment: "Message")
        case .invalidTokenID:
            return NSLocalizedString("Invalid Token ID. Please try again.", comment: "Message")
        case .missingParameters:
            return NSLocalizedString("Please enter valid email address and password.", comment: "Message")
        }
    }
}

public enum FireBaseError: Error {
    case missingParameters

    public var errorDescription: String? {
        switch self {
        case .missingParameters:
            return NSLocalizedString("Missing Parameters. Please try again.", comment: "Message")
        }
    }
}


typealias UserCallBack = ((UserModel?, Error?) -> ())
typealias CallBack = ((Error?) -> ())
typealias URLCallBack = (([URL]?, Error?) -> ())
typealias TweetsCallBack = (([ViewTweetModel]?, Error?) -> ())


typealias JSONDict = [String: AnyObject]

public enum StringValue: String {
    case pickPhoto = "Pick a Photo"
    case choosePicture = "Choose a picture"
    case home = "Home"
    case login = "Login"
    case okTitle = "Ok"
    case cancelTitle = "Cancel"
    case library = "Library"
    case camera = "Camera"
    case yesTitle = "Yes"
    case signOutConfirmation = "Are you sure you want to Sign Out?"
    case loading = "Loading..."
    case signingIn = "Signing In..."
    case signingOut = "Signing Out..."
    case loggingIn = "Logging In..."
    case posting = "Posting..."
}


public enum Mode {
    case add
    case view
}



public enum FirebaseDatabaseName: String {
    case users = "Users"
    case tweets = "Tweets"
    case profileImages = "Profile_Images"
    case tweetImages = "Tweet_Images"
}


struct Constants {
    static let maxCharacter = 280
}
