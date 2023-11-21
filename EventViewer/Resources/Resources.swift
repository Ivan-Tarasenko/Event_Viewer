//
//  Resources.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 19.04.2023.
//

import Foundation

enum R {
    enum KeyProperties {
        static let id = "id"
        static let createAt = "createdAt"
        static let parameters = "parameters"
    }

    enum KeyParameters {
        static let key = "key"
        static let stringValue = "stringValue"
        static let integerValue = "integerValue"
        static let booleanValue = "booleanValue"
        static let arrayValue = "arrayValue"
        
    }

    enum LocalizationString {
        static let idEvent = NSLocalizedString("idEvent", comment: "")
        static let dateEvent = NSLocalizedString("dateEvent", comment: "")
        static let parameterEvent = NSLocalizedString("parameterEvent", comment: "")
        
        static let key = NSLocalizedString("key", comment: "")
        static let string = NSLocalizedString("string", comment: "")
        static let int = NSLocalizedString("int", comment: "")
        static let bool = NSLocalizedString("bool", comment: "")
    }

    enum ErrorTitle {
        static let noParameter = NSLocalizedString("noParameter", comment: "")
        static let noEvent = NSLocalizedString("noEvent", comment: "")
    }

    enum CreateEvent {
        static let enterID = NSLocalizedString("enterID", comment: "")
        static let enterDate = NSLocalizedString("enterDate", comment: "")
        static let enterKey = NSLocalizedString("enterKey", comment: "")
        static let EnterString = NSLocalizedString("EnterString", comment: "")
        static let EnterInt = NSLocalizedString("EnterInt", comment: "")
        static let EnterBool = NSLocalizedString("EnterBool", comment: "")
    }

    enum TitleAlert {
        static let titleID = NSLocalizedString("titleID", comment: "")
        static let titleDate = NSLocalizedString("titleDate", comment: "")
    }
    
    enum TitleAlertClear {
        static let titleClear = NSLocalizedString("titleClear", comment: "")
        static let  massageClear = NSLocalizedString("massageClear", comment: "")
    }
}
