//
//  Utils.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


struct Utils {
    static var shared: Utils = Utils()
    private init() {}

    static let maxCharacter = 280

    public var loggedInUser: UserModel?
}


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


public enum LoginField: Int {
    case displayName
    case emailAddress
    case userName
    case password
    case photo
}


public enum LoginError: Error {
    case missingClientID
    case invalidTokenID
    case missingParameters
    case photoMissing
    case displayNameMisssing
    case emailAddressMissing
    case userNameMissing
    case passwordMissing
    case passwordCriteriaMissing

    public var errorDescription: String {
        switch self {
        case .missingClientID:
            return NSLocalizedString("Missing Client ID. Please try again.", comment: "Message")
        case .invalidTokenID:
            return NSLocalizedString("Invalid Token ID. Please try again.", comment: "Message")
        case .missingParameters:
            return NSLocalizedString("Please enter valid email address and password.", comment: "Message")
        case .photoMissing:
            return NSLocalizedString("Please select a Photo.", comment: "Message")
        case .displayNameMisssing:
            return NSLocalizedString("Please enter your Full Name", comment: "Message")
        case .emailAddressMissing:
            return NSLocalizedString("Please enter email address", comment: "Message")
        case .userNameMissing:
            return NSLocalizedString("Please enter userName", comment: "Message")
        case .passwordMissing:
            return NSLocalizedString("Please enter password", comment: "Message")
        case .passwordCriteriaMissing:
            return NSLocalizedString("Please enter valid password", comment: "Message")
        }
    }
}


public enum FireBaseError: Error {
    case missingParameters
    case failedToFetch

    public var errorDescription: String? {
        switch self {
        case .missingParameters:
            return NSLocalizedString("Missing Parameters. Please try again.", comment: "Message")
        case .failedToFetch:
            return NSLocalizedString("Failed to fetch the data. Please try again.", comment: "Message")
        }
    }
}


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
    case profileImage = "Profile_Images"
    case tweetImage = "Tweet_Images"
}


typealias PostCallBack<T> = ((Result<T, Error>) -> ())

typealias UserCallBack = ((UserModel?, Error?) -> ())
typealias TweetsCallBack = (([ViewTweetModel]?, Error?) -> ())

typealias CallBack = ((Error?) -> ())
typealias URLCallBack = ((URL?, Error?) -> ())

typealias JSONDict = [String: AnyObject]
