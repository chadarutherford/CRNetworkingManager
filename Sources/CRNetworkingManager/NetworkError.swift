//
//  File.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

public enum NetworkError: Error {
	case unknownError
	case invalidResponse
	case decodeError
	
	public var localizedDescription: String {
		switch self {
		case .unknownError:
			return "An unknown error occurred"
		case .invalidResponse:
			return "The response from the server was invalid. Please try again"
		case .decodeError:
			return "There was an error decoding objects."
		}
	}
}
