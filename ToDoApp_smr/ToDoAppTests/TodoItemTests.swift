import XCTest
@testable import ToDoApp

class TodoItemTests: XCTestCase {

    func testTodoItemJSONSerialization() {
        let todoItem = TodoItem(id: "1", text: "Test Task", importance: .high, deadline: Date(timeIntervalSince1970: 1623814800), isDone: false, creationDate: Date(timeIntervalSince1970: 1623814800), modificationDate: Date(timeIntervalSince1970: 1623891200))
        let json = todoItem.json

        if let parsedItem = TodoItem.parse(json: json) {
            XCTAssertEqual(todoItem.id, parsedItem.id)
            XCTAssertEqual(todoItem.text, parsedItem.text)
            XCTAssertEqual(todoItem.importance, parsedItem.importance)
            XCTAssertEqual(todoItem.deadline, parsedItem.deadline)
            XCTAssertEqual(todoItem.isDone, parsedItem.isDone)
            XCTAssertEqual(todoItem.creationDate, parsedItem.creationDate)
            XCTAssertEqual(todoItem.modificationDate, parsedItem.modificationDate)
        } else {
            XCTFail("Failed to parse JSON")
        }
    }

    func testTodoItemCSVSerialization() {
        let todoItem = TodoItem(id: "1", text: "Test Task", importance: .high, deadline: Date(timeIntervalSince1970: 1623814800), isDone: false, creationDate: Date(timeIntervalSince1970: 1623814800), modificationDate: Date(timeIntervalSince1970: 1623891200))
        let csv = todoItem.csv

        if let parsedItem = TodoItem.parse(csv: csv) {
            XCTAssertEqual(todoItem.id, parsedItem.id)
            XCTAssertEqual(todoItem.text, parsedItem.text)
            XCTAssertEqual(todoItem.importance, parsedItem.importance)
            XCTAssertEqual(todoItem.deadline, parsedItem.deadline)
            XCTAssertEqual(todoItem.isDone, parsedItem.isDone)
            XCTAssertEqual(todoItem.creationDate, parsedItem.creationDate)
            XCTAssertEqual(todoItem.modificationDate, parsedItem.modificationDate)
        } else {
            XCTFail("Failed to parse CSV")
        }
    }
}
