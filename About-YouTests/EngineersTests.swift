//
//  EngineersTests.swift
//  About-YouTests
//
//

import XCTest
@testable import About_You

class EngineersTests: XCTestCase {
    private var engineers: [Engineer]?
    
    
    override func setUp() {
        engineers = Engineer.testingData()
    }

    func testNEnsureEngineersExists() {
        XCTAssertTrue(engineers != nil)
    }
    
    func testEngineerData() {
        let engineer = engineers?.first
        XCTAssertTrue(engineer?.ID == "5265656E656E")
        XCTAssertTrue(engineer?.name == "Reenen")
        XCTAssertTrue(engineer?.role == "Dev manager")
        XCTAssertTrue(engineer?.quickStats.years == 6)
        XCTAssertTrue(engineer?.quickStats.coffees == 5400)
        XCTAssertTrue(engineer?.quickStats.bugs == 1800)
    }
    
    func testQuestionsAnswers() {
        let engineer = engineers?.first
        XCTAssertTrue(engineer?.questions.first?.questionText == "When do you have the most energy?")
        XCTAssertTrue(engineer?.questions.first?.answer?.text == "6am")
    }
    
    func testOrderingYears() {
        if var engineers = engineers {
            Engineer.sort(orderBy: .years, engineers: &engineers)
            let engineer = engineers.first
            XCTAssertTrue(engineer?.ID == "57696C6D6172")
            XCTAssertTrue(engineer?.name == "Wilmar")
            XCTAssertTrue(engineer?.role == "Head of Engineering")
            XCTAssertTrue(engineer?.quickStats.years == 15)
            XCTAssertTrue(engineer?.quickStats.coffees == 4000)
            XCTAssertTrue(engineer?.quickStats.bugs == 4000)
            engineers.removeAll()
        } else {
            XCTAssert(false)
        }
    }
    
    func testOrderingCoffees() {
        if var engineers = engineers {
            Engineer.sort(orderBy: .coffees, engineers: &engineers)
            let engineer = engineers.first
            XCTAssertTrue(engineer?.ID == "4272616E646F6E")
            XCTAssertTrue(engineer?.name == "Brandon")
            XCTAssertTrue(engineer?.role == "Senior dev")
            XCTAssertTrue(engineer?.quickStats.years == 9)
            XCTAssertTrue(engineer?.quickStats.coffees == 99999)
            XCTAssertTrue(engineer?.quickStats.bugs == 99999)
            engineers.removeAll()
        }  else {
            XCTAssert(false)
        }
    }
    
    func testOrderingBugs() {
        if var engineers = engineers {
            Engineer.sort(orderBy: .bugs, engineers: &engineers)
            let engineer = engineers.first
            XCTAssertTrue(engineer?.ID == "4272616E646F6E")
            XCTAssertTrue(engineer?.name == "Brandon")
            XCTAssertTrue(engineer?.role == "Senior dev")
            XCTAssertTrue(engineer?.quickStats.years == 9)
            XCTAssertTrue(engineer?.quickStats.coffees == 99999)
            XCTAssertTrue(engineer?.quickStats.bugs == 99999)
            engineers.removeAll()
        } else {
            XCTAssert(false)
        }
    }
}
