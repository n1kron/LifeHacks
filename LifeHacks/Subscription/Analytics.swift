//
//  Analytics.swift
//
//

import Foundation
import YandexMobileMetrica
import FacebookCore

struct Analytics {
    static func logPurchaseScreenView(index: Int) {
        let params: [String: Any] = ["Номер": index]
        YMMYandexMetrica.reportEvent("Просмотр экрана подписки", parameters: params, onFailure: nil)
        
        let fbParams = AppEvent.ParametersDictionary(dictionaryLiteral: ("Index", index))
        AppEventsLogger.log("Purchase screen view", parameters: fbParams, valueToSum: nil, accessToken: nil)
    }
    
    static func logPurchase(productName: String, price: NSDecimalNumber, currency: String) {
        let params: [String: Any] = ["Товар": productName, "Цена": price.stringValue, "Валюта": currency]
        
        YMMYandexMetrica.reportEvent("Покупка", parameters: params, onFailure: nil)

        AppEventsLogger.log(.purchased(amount: price.doubleValue, currency: currency, extraParameters: ["Product": productName]))
    }
}

