//
//  File.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

public protocol NetworkDataLoader {
	func loadData(using url: URL) async throws -> (Data, URLResponse)
	func loadData(using request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkDataLoader {
	public func loadData(using url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
	}
	
	public func loadData(using request: URLRequest) async throws -> (Data, URLResponse) {
		try await data(for: request)
	}
}
