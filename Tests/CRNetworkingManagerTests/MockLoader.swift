//
//  MockLoader.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation
@testable import CRNetworkingManager

class MockLoader: NetworkDataLoader {
    let result: Result<(Data, URLResponse), Error>
	
    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }
    
	func loadData(using url: URL) async throws -> (Data, URLResponse) {
        await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
        
        return try result.get()
	}
	
	func loadData(using request: URLRequest) async throws -> (Data, URLResponse) {
        await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
        return try result.get()
	}
}

struct AnyError: Error { }
