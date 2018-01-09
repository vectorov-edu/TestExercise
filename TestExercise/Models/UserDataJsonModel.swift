
import Foundation

struct UserDataJsonModel : Codable {
	let id : Int?
	let name : String?
	let username : String?
	let email : String?
	let address : Address?
	let phone : String?
	let website : String?
	let company : Company?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case username = "username"
		case email = "email"
		case address
		case phone = "phone"
		case website = "website"
		case company
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		address = try Address(from: decoder)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		company = try Company(from: decoder)
	}

}
