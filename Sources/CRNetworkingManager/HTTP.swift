//
//  HTTP.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case delete = "DELETE"
	case put = "PUT"
}

public enum HTTPHeaderType: String {
	case contentType = "Content-Type"
	case authorization = "Authorization"
}

public enum HTTPHeaderValue: String {
	case json = "application/json"
}

public struct EncodingStatus {
	let request: URLRequest?
	let error: Error?
}
