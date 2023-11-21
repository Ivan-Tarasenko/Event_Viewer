//
//  DetailEventViewModel.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 17.04.2023.
//

import Foundation
import CoreData

protocol DetailEventModelProtocol: AnyObject {
    var titlesSection: [String] { get }
    var titlesParameter: [String] { get }
    
    var entityEvent: EntityEvent? { get }
}


struct EntityEvent {
    var id: String?
    var date: String?
    var parameter: EntityParameter?
}

struct EntityParameter {
    var key: String?
    var string: String?
    var int: String?
    var bool: String?
}

final class DetailEventViewModel: DetailEventModelProtocol {
    
    let eventManager: EventManager
    let indexCell: Int
    var titlesSection: [String] = []
    var titlesParameter: [String] = []
    
    var entityEvent: EntityEvent?
    
    init(eventManager: EventManager, indexCell: Int) {
        self.eventManager = eventManager
        self.indexCell = indexCell
        
        addTitleSection()
        addTitleParameter()
        getParaneterOfEvent(index: indexCell)
        
        
        
    }
    
    private func addTitleSection() {
        titlesSection.append(R.LocalizationString.idEvent)
        titlesSection.append(R.LocalizationString.dateEvent)
        titlesSection.append(R.LocalizationString.parameterEvent)
    }
    
    private func addTitleParameter() {
        titlesParameter.append(R.LocalizationString.key)
        titlesParameter.append(R.LocalizationString.string)
        titlesParameter.append(R.LocalizationString.int)
        titlesParameter.append(R.LocalizationString.bool)
        
    }
    
    private func getParaneterOfEvent(index: Int) {
        guard !eventManager.limitEvents.isEmpty else { return }
        
        var id: String?
        var date: String?
        var eventParameter: EntityParameter?
        
        if let idEvent = eventManager.limitEvents[index].value(forKey: R.KeyProperties.id) as? String {
            id = idEvent
        }
        
        if let createAt = eventManager.limitEvents[index].value(forKey: R.KeyProperties.createAt) as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let timeString = dateFormatter.string(from: createAt)
            date = timeString
        }
        
        
        if let parameters = eventManager.limitEvents[index].value(forKey: R.KeyProperties.parameters) as? Set<DBParameter> {
            
            for parameter in parameters {
                
                // getting all the event parameters
                let key = parameter.value(forKey: R.KeyParameters.key) as? String
                var stringValue = parameter.value(forKey: R.KeyParameters.stringValue) as? String
                var integerValue = parameter.value(forKey: R.KeyParameters.integerValue) as? Int
                var booleanValue = parameter.value(forKey: R.KeyParameters.booleanValue) as? Bool
                let arrayValue = parameter.value(forKey: R.KeyParameters.arrayValue) as? Set<DBParameter>
                
                if let parameters = arrayValue {
                    for parameter in parameters {
                        
                        if let string = parameter.value(forKey: R.KeyParameters.stringValue) as? String {
                            stringValue = string
                        }
                        
                        if let integer = parameter.value(forKey: R.KeyParameters.integerValue) as? Int {
                            if integer > 0 {
                                integerValue = integer
                            }
                        }
                        
                        if let boolean = parameter.value(forKey: R.KeyParameters.booleanValue) as? Bool {
                            booleanValue = boolean
                        }
                    }
                }
                
                
                // encode all parameters in JSONE format
                let encodedInt = try! JSONEncoder().encode(integerValue)
                let encodedBool = try! JSONEncoder().encode(booleanValue)

                // extracting data in String
                let jsonInt = String(data: encodedInt, encoding: .utf8)
                let jsonBool = String(data: encodedBool, encoding: .utf8)
                
                let parameter = EntityParameter(key: key, string: stringValue, int: jsonInt, bool: jsonBool)
                eventParameter = parameter
            }
        }
        
        entityEvent = EntityEvent(id: id, date: date, parameter: eventParameter)
        
    }
}
