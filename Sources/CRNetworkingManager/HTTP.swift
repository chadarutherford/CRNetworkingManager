//
//  HTTP.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case delete = "DELETE"
	case put = "PUT"
}

enum HTTPHeaderType: String {
	case contentType = "Content-Type"
	case authorization = "Authorization"
}

enum HTTPHeaderValue: String {
	case json = "application/json"
}

struct EncodingStatus {
	let request: URLRequest?
	let error: Error?
}
