//
//  APODViewModel.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 26/05/21.
//

import UIKit

class APODViewModel: NSObject {
    
    private var service:NetworkServiceProtocol!
    
    var bindApodModelToView: (() -> ()) = {}
    var bindErrorToView: (() -> ()) = {}
    
    var isDisplayingOldInfo: Bool = false
    
    var apodInfo:APODModel! {
        didSet {
            self.bindApodModelToView()
        }
    }
    
    var error:Error! {
        didSet {
            self.bindErrorToView()
        }
    }
    
    override init() {
        super.init()
        self.service = NetworkService()
    }
    
    func getAPODInfo() {
        self.service.getAPODInfo(apodKey: AppConfig.NASA_APOD_KEY) { (data) in
            guard let responseData = data else {
                self.error = nil
                return
            }
            let jsonDecoder = JSONDecoder()
            if let infoModel = try? jsonDecoder.decode(APODModel.self, from: responseData) {
                self.apodInfo = infoModel
                if let mediaPath = infoModel.url, let url = URL(string: mediaPath) {
                    self.service.downloadMedia(url: url) { (data) in
                        infoModel.mediaContent = data
                        UserDefaultDataStore.storeApodInfo(model: self.apodInfo)
                    } failure: { (error) in
                        self.apodInfo = infoModel
                    }
                }
            }
        } failure: { (error) in
            if let cacheData = self.checkForCacheData() {
                self.apodInfo = cacheData
            }else {
                self.error = error
            }
        }
    }
    
    private func checkForCacheData() -> APODModel? {
        guard let model = UserDefaultDataStore.getCachedApodInfo() else {
            return nil
        }
        if let date = model.date, let cacheDataDate = DateFormatters.getDateFrom(date: date) {
            if Calendar.current.isDateInToday(cacheDataDate) {
                isDisplayingOldInfo = false
            }else{
                isDisplayingOldInfo = true
            }
            return model
        }else{
            UserDefaultDataStore.removeCachedApodInfo()
            return nil
        }
    }
}
