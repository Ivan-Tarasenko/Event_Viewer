//
//  EventListViewModel.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 11.04.2023.
//

import Foundation
import CoreData

protocol EventListModelProtorol: AnyObject {
    
    var limitAllEvents: [NSManagedObject] { get set }
    
    func eventID(index: Int) -> String?
    func eventDate(index: Int) -> String?
    func reloadData(completion: @escaping () -> Void)
    func deleteEvent(index: Int)
    func search(searchText: String)
}

final class EventListViewModel: EventListModelProtorol {
    
    
    let eventManager: EventManager?
    
    var limitAllEvents: [NSManagedObject] = []
    
    init(eventManager: EventManager) {
        self.eventManager = eventManager
    }
    
    func eventID(index: Int) -> String? {
        guard !limitAllEvents.isEmpty else { return R.ErrorTitle.noEvent }
        return limitAllEvents[index].value(forKey: R.KeyProperties.id) as? String
    }
    
    func eventDate(index: Int) -> String? {
        guard !limitAllEvents.isEmpty else { return "00/00/0000 00:00" }
        guard let eventDate = limitAllEvents[index].value(forKey: R.KeyProperties.createAt) as? Date else { return "00/00/0000 00:00" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let timeString = dateFormatter.string(from: eventDate)
        return timeString
    }
    
    func reloadData(completion: @escaping () -> Void) {
        guard let eventManager = eventManager else { return }
        eventManager.getLimitEvents()
        limitAllEvents = eventManager.limitEvents
        completion()
    }
    
    func deleteEvent(index: Int) {
        guard !limitAllEvents.isEmpty else { return }
        guard let eventManager = eventManager else { return }
        eventManager.deleteEvent(index: index)
        limitAllEvents.remove(at: index)
    }
    
    // MARK: - Search methods
    
    func getAllEvents() {
        eventManager?.getEvents()
    }
    
    func search(searchText: String) {
        if let filteredEvents = eventManager?.allEvents.filter({ ($0.value(forKey: R.KeyProperties.id) as? String)!.lowercased().contains(searchText.lowercased()) }) {
            
            limitAllEvents = filteredEvents
        }
    }
}
