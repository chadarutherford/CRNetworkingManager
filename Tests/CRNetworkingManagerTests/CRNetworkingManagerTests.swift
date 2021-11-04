import XCTest
@testable import CRNetworkingManager

final class CRNetworkingManagerTests: XCTestCase {
	
	struct Pokemon: Codable {
		let name: String
		let url: URL
	}
	
	struct PokemonResults: Codable {
		let results: [Pokemon]
	}
	
	func testDecodeObjects() async throws {
		let networkManager = NetworkManager()
		let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let networkResults: PokemonResults = try await networkManager.decodeObjects(using: url)
        let pokemon = networkResults.results
        XCTAssertGreaterThan(pokemon.count, 0)
	}
	
	func testMockDecodeObjects() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(data: pokemonData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        let networkManager = NetworkManager(networkLoader: mock)
        let networkResults: PokemonResults = try await networkManager.decodeObjects(using: url)
        let pokemon = networkResults.results
        XCTAssertGreaterThan(pokemon.count, 0)
	}
    
    func testNon200ResponseFailsDecode() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(data: pokemonData, response: HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!)
        let networkManager = NetworkManager(networkLoader: mock)
        do {
            let _: PokemonResults = try await networkManager.decodeObjects(using: url)
            XCTFail("Expected Error: \(NetworkError.invalidResponse)")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
    
    func testMockDecodeObjectsMalformedJSONFailsDecode() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(data: pokemonDataMalformed, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        let networkManager = NetworkManager(networkLoader: mock)
        do {
            let _: PokemonResults = try await networkManager.decodeObjects(using: url)
            XCTFail("Expected Error: \(NetworkError.decodeError)")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodeError)
        }
    }
}
