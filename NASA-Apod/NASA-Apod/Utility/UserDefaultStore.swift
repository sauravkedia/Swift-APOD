//
//  UserDefaultStore.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 26/05/21.
//

import UIKit

class UserDefaultDataStore : NSObject {
    
    static let APOD_INFO = "apod_info"

    static func storeApodInfo(model:APODModel) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else { return }
        UserDefaults.standard.setValue(data, forKey: APOD_INFO)
    }
 
    static func getCachedApodInfo() -> APODModel? {
        guard let data = UserDefaults.standard.value(forKey: APOD_INFO) as? Data, let model = try? NSKeyedUnarchiver.unarchivedObject(ofClass: APODModel.self, from: data) else {
            return nil
        }
        return model
    }
    
    static func removeCachedApodInfo() {
        UserDefaults.standard.removeObject(forKey: APOD_INFO)
    }
}
