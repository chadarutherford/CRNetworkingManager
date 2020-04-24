//
//  File.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

protocol NetworkDataLoader {
	func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
	func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

extension URLSession: NetworkDataLoader {
	func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		dataTask(with: url) { data, response, error in
			completion(data, response as? HTTPURLResponse, error)
		}.resume()
	}
	
	func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		dataTask(with: request) { data, response, error in
			completion(data, response as? HTTPURLResponse, error)
		}.resume()
	}
}
