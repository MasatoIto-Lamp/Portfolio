//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by イトマサ on 2023/08/07.
//

import CoreData
import XCTest
@testable import Portfolio

// テスト実施前準備
class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
