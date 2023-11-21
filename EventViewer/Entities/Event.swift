//
//  Event.swift
//  EventManager
//
//  Created by Ilya Kharlamov on 6/17/22.
//

import Foundation

public struct Event: Identifiable {

    public let id: String
    public var date: Date
    public var parameters: ParameterSet

    public init(id: String, date: Date = Date(), parameters: ParameterSet = [:]) {
        self.id = id
        self.date = date
        self.parameters = parameters
    }

}
