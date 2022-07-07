//
//  FirebaseDatabaseManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


struct FirebaseDatabaseManager {
    static var shared: FirebaseDatabaseManager = FirebaseDatabaseManager()

    private let databaseRef: DatabaseReference = Database.database().reference()
    private let storageRef: StorageReference = Storage.storage().reference()

    private init() {}

    // MARK: - Public Methods -
    public func generateKey() -> String {
        return databaseRef.childByAutoId().key ?? UUID().uuidString
    }

    public func fetchWithoutObserving<T: Codable>(endpoint: FirebaseDatabaseEndPoint,
                                                  pageSize: UInt?,
                                                  queryKey: String?,
                                                  queryStarting: Any?,
                                                  queryEnding: Any?,
                                                  callBackHandler: @escaping PostCallBack<T>) {
        var query: AnyObject = databaseRef.child(endpoint.path)

        if let queryKey = queryKey {
            query = query.queryOrdered(byChild: queryKey)
        }

        if let queryStarting = queryStarting {
            query = query.queryStarting(atValue: queryStarting)
        }

        if let queryEnding = queryEnding {
            query = query.queryEnding(atValue: queryEnding)
        }

        if let pageSize = pageSize {
            query = query.queryLimited(toLast: pageSize)
        }

        query.observeSingleEvent(of: .value) { snapshot in
            var decodedValue: T?

            if let value = snapshot.value as? JSONDict {
                decodedValue = value.decode(T.self)

                if decodedValue == nil {
                    decodedValue = value.decodeAsArray(T.self)
                }
            } else if let value = snapshot.value as? Array<Any> {
                decodedValue = value.decode(T.self)
            }

            if let decodedValue = decodedValue {
                callBackHandler(.success(decodedValue))
            } else {
                callBackHandler(.failure(FireBaseError.failedToFetch))
            }
        }
    }

    public func post<T: Codable>(endpoint: FirebaseDatabaseEndPoint,
                                 data: T,
                                 completion: @escaping PostCallBack<T>) {
        var encodedData: Any?

        if let value = data.JSONDictionary {
            encodedData = value
        } else if let value = data.JSONArray {
            encodedData = value
        }

        if encodedData == nil {
            completion(.failure(EncodingeError.encodingFailed))

            return
        }

        let reference = databaseRef.child(endpoint.path)

        reference.setValue(encodedData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
    }

    public func delete(endpoint: FirebaseDatabaseEndPoint, callBackHandler: @escaping CallBack) {
        databaseRef.child(endpoint.path).removeValue { (error, reference) in
            callBackHandler(error)
        }
    }

    public func uploadImage(endpoint: FirebaseDatabaseEndPoint,
                            data: Data,
                            callBackHandler: @escaping URLCallBack) {
        let ref = storageRef.child(endpoint.path)

        ref.putData(data, metadata: .none) { metadata, error in
            ref.downloadURL(completion: callBackHandler)
        }
    }

    public func deleteImage(endpoint: FirebaseDatabaseEndPoint,
                            imageURL: String,
                            callBackHandler: @escaping CallBack) {
        let ref = storageRef.child(endpoint.path).storage.reference(forURL: imageURL)

        ref.delete(completion: callBackHandler)
    }
}
