//
//  MockLoader.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation
@testable import CRNetworkingManager

class MockLoader: NetworkDataLoader {
	var data: Data
	var response: URLResponse
	
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
	func loadData(using url: URL) async throws -> (Data, URLResponse) {
        await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
        return (data, response)
	}
	
	func loadData(using request: URLRequest) async throws -> (Data, URLResponse) {
        await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
        return (data, response)
	}
}
