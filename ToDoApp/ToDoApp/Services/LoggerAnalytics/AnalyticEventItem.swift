//
//  EventParams.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 08.07.2024.
//

struct AnalyticEventItem {
    let event: EventType
    let screen: EventScreen
    let item: EventItem?
    let params: [String: String]?

    init(
        event: EventType,
        screen: EventScreen,
        item: EventItem? = nil,
        params: [String: String]? = nil
    ) {
        self.event = event
        self.screen = screen
        self.item = item
        self.params = params
    }

    var toDict: [String: String] {
        [
            "event": event.rawValue,
            "screen": screen.rawValue,
            "item": item?.rawValue,
            "params": params?.description
        ].compactMapValues { $0 }
    }

    var eventName: String {
        [screen.rawValue, event.rawValue, item?.rawValue].compactMap { $0 }.joined(separator: "_")
    }

}

extension AnalyticEventItem {

    enum EventType: String {
        case open
        case close
        case click
        case swipe
    }
    
    enum EventItem: String {
        case showCompleted
        case hideCompleted
        case sortByPriority
        case sortByCreationDate
        case markAsCompleted
        case markAsIncompleted
        case info
        case quickAddNew
        case addNew
        case edit
        case calendar
        case deadline
        case priority
        case category
        case cancel
        case save
        case delete
    }

    enum EventScreen: String {
        case todoList
        case todoView
        case calendar
    }

}
