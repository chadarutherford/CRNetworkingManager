import CoreData
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

    private func coreDataDecode<T:Decodable>(in context: NSManagedObjectContext, to type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
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
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
                return
            }

            if let response = response, !self.expectedResponseCodes.contains(response.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }

            guard let results = self.decode(to: T.self, data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(results))
            }
        }
    }

    public func decodeCoreDataObjects<T: Decodable>(in context: NSManagedObjectContext, using url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        networkLoader.loadData(using: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
                return
            }

            if let response = response, !self.expectedResponseCodes.contains(response.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }

            guard let results = self.coreDataDecode(in: context, to: T.self, data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(results))
            }
        }
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
