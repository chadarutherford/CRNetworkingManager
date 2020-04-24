//
//  MockLoader.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation
@testable import CRNetworkingManager

class MockLoader: NetworkDataLoader {
	var data: Data?
	var response: HTTPURLResponse?
	var error: Error?
	
	func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		completion(self.data, self.response, self.error)
	}
	
	func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		completion(self.data, self.response, self.error)
	}
}
