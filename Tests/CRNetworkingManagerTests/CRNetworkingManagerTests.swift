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
	
	func testDecodeObjects() {
		
		var networkResults = [Pokemon]()
		
		let networkManager = CRNetworkingManager()
		let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
		let waitForNetwork = expectation(description: "Waiting on network")
		networkManager.decodeObjects(using: url) { (result: Result<PokemonResults, NetworkError>) in
			switch result {
			case .success(let results):
				networkResults = results.results
			case .failure(let error):
				XCTFail("Error decoding results: \(error)")
			}
			waitForNetwork.fulfill()
		}
		
		wait(for: [waitForNetwork], timeout: 10)
		XCTAssert(networkResults.count > 0)
	}
	
	func testMockDecodeObjects() {
		var networkResults = [Pokemon]()
		
		let mock = MockLoader()
		mock.data = pokemonData
		let networkManager = CRNetworkingManager(networkLoader: mock)
		let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
		let waitForMockNetwork = expectation(description: "Waiting on mock network")
		networkManager.decodeObjects(using: url) { (result: Result<PokemonResults, NetworkError>) in
			switch result {
			case .success(let results):
				networkResults = results.results
			case .failure(let error):
				XCTFail("Error decoding results: \(error)")
			}
			waitForMockNetwork.fulfill()
		}
		
		wait(for: [waitForMockNetwork], timeout: 5)
		XCTAssert(networkResults.count > 0)
	}
}
