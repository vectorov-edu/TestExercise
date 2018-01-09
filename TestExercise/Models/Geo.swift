import Foundation

struct Geo : Codable {
    var lat : Double?
	let lng : Double?

	enum CodingKeys: String, CodingKey {

		case lat = "lat"
		case lng = "lng"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try Double(values.decodeIfPresent(String.self, forKey: .lat)!)
        lng = try Double(values.decodeIfPresent(String.self, forKey: .lng)!)
	}

}
