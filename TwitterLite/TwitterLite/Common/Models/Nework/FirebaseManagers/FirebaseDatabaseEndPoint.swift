//
//  FirebaseDatabaseEndPoint.swift
//  TwitterLite
//
//  Created by Rahul Singh on 04/07/22.
//

import Foundation


protocol FirebaseDatabaseEndPoint {
    var path: String { get }
}


extension FirebaseDatabaseEndPoint {
    public func fetchWithoutObserving<T: Codable>(pageSize: UInt? = .none,
                                                  queryKey: String? = .none,
                                                  queryStarting: Any? = .none,
                                                  queryEnding: Any? = .none,
                                                  callBackHandler: @escaping PostCallBack<T>) {
        FirebaseDatabaseManager.shared.fetchWithoutObserving(endpoint: self,
                                                             pageSize: pageSize,
                                                             queryKey: queryKey,
                                                             queryStarting: queryStarting,
                                                             queryEnding: queryEnding,
                                                             callBackHandler: callBackHandler)
    }

    public func post<T: Codable>(data: T,
                                 callBackHandler: @escaping PostCallBack<T>) {
        FirebaseDatabaseManager.shared.post(endpoint: self,
                                            data: data,
                                            completion: callBackHandler)
    }

    public func delete(callBackHandler: @escaping CallBack) {
        FirebaseDatabaseManager.shared.delete(endpoint: self, callBackHandler: callBackHandler)
    }

    public func uploadAttachment(data: Data,
                                 callBackHandler: @escaping URLCallBack) {
        FirebaseDatabaseManager.shared.uploadImage(endpoint: self,
                                                   data: data,
                                                   callBackHandler: callBackHandler)
    }
}
