//
//  FileCacheTests.swift
//  ToDoAppTests
//
//  Created by Наталья Захарова on 20.06.2024.
//

import XCTest
import FileCache
@testable import ToDoApp

class TodoItemTests: XCTestCase {

    func testInitialization() {
		let todo = TodoItem(text: "Test school", importance: .important, category: .standard(DefaultCategory.hobby), isCompleted: false)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo.text, "Test school")
		XCTAssertEqual(todo.importance, .important)
        XCTAssertFalse(todo.isCompleted)
    }

    func testJSONSerialization() {
		let todo = TodoItem(text: "Test school", importance: .important, category: .standard(DefaultCategory.hobby), isCompleted: true)
        let json = todo.json as! [String: Any]
        XCTAssertNotNil(json)
        XCTAssertEqual(json["text"] as? String, "Test school")
        XCTAssertNotNil(json["importance"])
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
		XCTAssertFalse(todo?.isCompleted ?? false)
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
        let todo = TodoItem.fromCSV(invalidCSV)
        XCTAssertNil(todo)
    }
}
