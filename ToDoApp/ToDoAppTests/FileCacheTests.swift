//
//  FileCacheTests.swift
//  ToDoAppTests
//
//  Created by Наталья Захарова on 20.06.2024.
//

import XCTest
@testable import ToDoApp

class TodoItemTests: XCTestCase {
    
    func testInitialization() {
        let todo = TodoItem(text: "Test school", importance: .high, isCompleted: false)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo.text, "Test school")
        XCTAssertEqual(todo.importance, .high)
        XCTAssertFalse(todo.isCompleted)
    }

    func testJSONSerialization() {
        let todo = TodoItem(text: "Test school", importance: .normal, isCompleted: true)
        let json = todo.json as! [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json["text"] as? String, "Test school")
        XCTAssertNil(json["importance"])
        XCTAssertTrue(json["isCompleted"] as! Bool)
    }

    func testJSONParsing() {
        let json: [String: Any] = [
            "id": "1",
            "text": "Test parsing",
            "isCompleted": false,
            "creationDate": "2021-06-01T12:00:00Z"
        ]
        let todo = TodoItem.parse(json: json)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo?.text, "Test parsing")
        XCTAssertFalse(todo!.isCompleted)
    }

    func testCSVSerializationAndParsing() {
        let todo = TodoItem(text: "Hello, world!", importance: .high, isCompleted: true)
        let csv = todo.csv
        XCTAssertNotNil(csv)

        let parsedTodo = TodoItem.fromCSV(csvString: csv)
        XCTAssertNotNil(parsedTodo)
        XCTAssertEqual(parsedTodo?.text, "Hello, world!")
        XCTAssertEqual(parsedTodo?.importance, .high)
        XCTAssertTrue(parsedTodo!.isCompleted)
    }

    func testInvalidJSONParsing() {
        let invalidJson: [String: Any] = [
            "id": "1",
            "text": "Test parsing",
            "isCompleted": false
        ]
        let todo = TodoItem.parse(json: invalidJson)
        XCTAssertNil(todo)
    }

    func testInvalidCSVParsing() {
        let invalidCSV = "1,Test parsing,,false"
        let todo = TodoItem.fromCSV(csvString: invalidCSV)
        XCTAssertNil(todo)
    }
}
