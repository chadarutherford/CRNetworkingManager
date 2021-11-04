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

    public func decodeObjects<T: Decodable>(using url: URL) async throws -> T {
        do {
            let (data, response) = try await networkLoader.loadData(using: url)
            guard let httpResponse = response as? HTTPURLResponse, self.expectedResponseCodes.contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard let results = self.decode(to: T.self, data: data) else {
                throw NetworkError.decodeError
            }
            
            return results
        } catch {
            throw NetworkError.unknownError
        }
    }

    public func decodeCoreDataObjects<T: Decodable>(in context: NSManagedObjectContext, using url: URL) async throws -> T {
        do {
            let (data, response) = try await networkLoader.loadData(using: url)
            guard let httpResponse = response as? HTTPURLResponse, self.expectedResponseCodes.contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard let results = self.coreDataDecode(in: context, to: T.self, data: data) else {
                throw NetworkError.decodeError
            }
            
            return results
        } catch {
            throw NetworkError.unknownError
        }
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
