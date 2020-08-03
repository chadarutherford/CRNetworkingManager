import Foundation

final public class NetworkManager {
	
	private let networkLoader: NetworkDataLoader
	private let expectedResponseCodes = Set.init(200 ... 299)
	
	public init(networkLoader: NetworkDataLoader = URLSession.shared) {
		self.networkLoader = networkLoader
	}
	
	private func decode<T: Decodable>(to type: T.Type, data: Data) -> T? {
		let decoder = JSONDecoder()
		do {
			let decodedType = try decoder.decode(T.self, from: data)
			return decodedType
		} catch {
			return nil
		}
	}
	
	public func decodeObjects<T: Decodable>(using url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
		networkLoader.loadData(using: url) { data, response, error in
			guard error == nil else {
				completion(.failure(.unknownError))
				return
			}
			
			if let response = response, !self.expectedResponseCodes.contains(response.statusCode) {
				completion(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				completion(.failure(.invalidData))
				return
			}
			
			guard let results = self.decode(to: T.self, data: data) else {
				completion(.failure(.decodeError))
				return
			}
			
			completion(.success(results))
		}
	}
}
