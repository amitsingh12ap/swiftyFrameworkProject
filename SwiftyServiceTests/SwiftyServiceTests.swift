//
//  SwiftyServiceTests.swift
//  SwiftyServiceTests
//
//  Created by Amit Singh on 09/08/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import XCTest
@testable import SwiftyService

struct Employee: Codable {
    let id : String?
    let employee_name : String?
    let employee_salary : String?
    let employee_age : String?
    let profile_image : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case employee_name = "employee_name"
        case employee_salary = "employee_salary"
        case employee_age = "employee_age"
        case profile_image = "profile_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        employee_name = try values.decodeIfPresent(String.self, forKey: .employee_name)
        employee_salary = try values.decodeIfPresent(String.self, forKey: .employee_salary)
        employee_age = try values.decodeIfPresent(String.self, forKey: .employee_age)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
    }
    
}

class SwiftyServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testApi(){
        let urlString = "http://dummy.restapiexample.com/api/v1/employee/16554"
        let s = SwiftyApiManager(configuration: .default)
        s.createRequest(withEndPoint: urlString, withRequestType: .get, withParameters: nil, withHeader: nil, decode: Employee.self) { (response) in
            
            switch response {
            case .success(let employeeModel):
                print(employeeModel?.employee_name ?? "response not available")
            case .failure(let failure):
                print(failure?.localizedDescription ?? "Failed ")
            }
        }
    }
    
}
