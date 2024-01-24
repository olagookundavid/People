//
//  CreateFormValidatorTests.swift
//  PeoplesTests
//
//  Created by David OH on 12/14/23.
//


import XCTest
@testable import Peoples

class CreateFormValidatorTests: XCTestCase {

    private var validator: Validator!
    
    override func setUp() {
        validator = Validator()
    }
    
    override func tearDown() {
        validator = nil
    }
    
    func test_with_empty_person_first_name_error_thrown() {
        let person = NewPerson()
        XCTAssertThrowsError(try validator.validate(person:person), "Error for an empty first name should be thrown")
        
        do {
            _ = try validator.validate(person:person)
        } catch {
            guard let validationError = error as? Validator.validateError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validationError, Validator.validateError.invalidFirstName, "Expecting an error where we have an invalid first name")
        }
    }
    
    func test_with_empty_first_name_error_thrown() {
        
        let person = NewPerson(lastName: "OH", job: "iOS Dev")
        XCTAssertThrowsError(try validator.validate(person:person), "Error for an empty first name should be thrown")

        do {
            _ = try validator.validate(person:person)
        } catch {
            guard let validationError = error as? Validator.validateError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validationError, Validator.validateError.invalidFirstName, "Expecting an error where we have an invalid first name")
        }
    }
    
    func test_with_empty_last_name_error_thrown() {
        
        let person = NewPerson(firstName: "David", job: "iOS Dev")
        XCTAssertThrowsError(try validator.validate(person:person), "Error for an empty last name should be thrown")

        do {
            _ = try validator.validate(person:person)
        } catch {
            guard let validationError = error as? Validator.validateError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validationError, Validator.validateError.invalidLastName, "Expecting an error where we have an invalid last name")
        }
    }
    
    func test_with_empty_job_error_thrown() {
        
        let person = NewPerson(firstName: "David", lastName: "OH")
        XCTAssertThrowsError(try validator.validate(person:person), "Error for an empty job should be thrown")

        do {
            _ = try validator.validate(person:person)
        } catch {
            guard let validationError = error as? Validator.validateError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validationError, Validator.validateError.invalidJob, "Expecting an error where we have an invalid job")
        }
    }
    
    func test_with_valid_person_error_not_thrown() {
        
        let person = NewPerson(firstName: "David", lastName: "OH", job: "iOS Dev")
        
        do {
            _ = try validator.validate(person:person)
        } catch {
            XCTFail("No errors should be thrown, since the person should be a valid object")
        }
        //Same as the do catch above
        XCTAssertNoThrow(try validator.validate(person:person),"should not throw")
    }
}
