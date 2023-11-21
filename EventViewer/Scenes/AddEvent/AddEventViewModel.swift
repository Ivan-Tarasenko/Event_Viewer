//
//  AddEventViewModel.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 20.04.2023.
//

import Foundation

protocol AddEventModelProtocol: AnyObject {
    
    var titlesSection: [String] { get }
    var titlesEnterParameter: [String] { get }
    
    var titleEvent: String? { get set }
    var dateEvent: Date? { get set }
    var key: String? { get set }
    var strValue: String? { get set }
    var intValue: Int? { get set }
    var boolValue: Bool? { get set }
    
    var isShowDatePicker: Bool {get set }
    
    func changeTitleEvent() -> Bool
    
    func createEvent() -> Event
    
}

final class AddEventViewModel: AddEventModelProtocol {
    
    var titlesSection: [String] = []
    var titlesEnterParameter: [String] = []
    
    var isShowDatePicker: Bool = false
    
    var titleEvent: String?
    var dateEvent: Date?
    var key: String?
    var strValue: String?
    var intValue: Int?
    var boolValue: Bool?
    
    init() {
        addTitleSection()
        addTitleParameter()
    }
    
    func changeTitleEvent() -> Bool {
        if let title = titleEvent {
            if !title.isEmpty {
                return true
            }
        }
        return false
    }
    
    func createEvent() -> Event {
        let id = titleEvent ?? ""
        let date = dateEvent ?? Date()
        let parameter = parameter()
        
        return Event(id: id, date: date, parameters: parameter)
    }
    
    private func parameter() -> ParameterSet {
        
        if key != nil ||
            strValue != nil ||
            intValue != nil ||
            boolValue != nil {
            
            return ParameterSet(dictionaryLiteral: (key ?? "null", .array( [
                .string(strValue ?? "null"),
                .integer(intValue ?? 0),
                .bool(boolValue ?? false)
            ])))
        } else {
            return [:]
        }
        
    }
    
    private func addTitleSection() {
        titlesSection.append(R.LocalizationString.idEvent)
        titlesSection.append(R.LocalizationString.dateEvent)
        titlesSection.append(R.LocalizationString.parameterEvent)
    }
    
    private func addTitleParameter() {
        titlesEnterParameter.append(R.CreateEvent.enterKey)
        titlesEnterParameter.append(R.CreateEvent.EnterString)
        titlesEnterParameter.append(R.CreateEvent.EnterInt)
        titlesEnterParameter.append(R.CreateEvent.EnterBool)
        
    }
}
