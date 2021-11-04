//
//  URLRequestDecodeTests.swift
//  
//
//  Created by Rutherford, Chad on 11/4/21.
//

import XCTest
@testable import CRNetworkingManager

final class URLRequestDecodeTests: XCTestCase {
    
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
        let request = URLRequest(url: url)
        let networkResults: PokemonResults = try await networkManager.decodeObjects(using: request)
        let pokemon = networkResults.results
        XCTAssertGreaterThan(pokemon.count, 0)
    }
    
    func testMockDecodeObjects() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(result: .success((pokemonData, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let networkManager = NetworkManager(networkLoader: mock)
        let request = URLRequest(url: url)
        let networkResults: PokemonResults = try await networkManager.decodeObjects(using: request)
        let pokemon = networkResults.results
        XCTAssertGreaterThan(pokemon.count, 0)
    }
    
    func testNon200ResponseFailsDecode() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(result: .success((pokemonData, HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!)))
        let networkManager = NetworkManager(networkLoader: mock)
        let request = URLRequest(url: url)
        do {
            let _: PokemonResults = try await networkManager.decodeObjects(using: request)
            XCTFail("Expected Error: \(NetworkError.invalidResponse)")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
            XCTAssertEqual((error as? NetworkError)?.localizedDescription, NetworkError.invalidResponse.localizedDescription)
        }
    }
    
    func testMockDecodeObjectsMalformedJSONFailsDecode() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(result: .success((pokemonDataMalformed, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        let networkManager = NetworkManager(networkLoader: mock)
        let request = URLRequest(url: url)
        do {
            let _: PokemonResults = try await networkManager.decodeObjects(using: request)
            XCTFail("Expected Error: \(NetworkError.decodeError)")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodeError)
            XCTAssertEqual((error as? NetworkError)?.localizedDescription, NetworkError.decodeError.localizedDescription)
        }
    }
    
    func testNetworkErrorFailsDecode() async throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let mock = MockLoader(result: .failure(anyError()))
        let networkManager = NetworkManager(networkLoader: mock)
        let reqeust = URLRequest(url: url)
        do {
            let _: PokemonResults = try await networkManager.decodeObjects(using: reqeust)
            XCTFail("Expected Error: \(NetworkError.unknownError)")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.localizedDescription, NetworkError.unknownError.localizedDescription)
        }
    }
}

private func anyError() -> Error {
    AnyError()
}
