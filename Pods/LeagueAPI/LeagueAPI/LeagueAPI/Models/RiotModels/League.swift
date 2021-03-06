//
//  League.swift
//  LeagueAPI
//
//  Created by Antoine Clop on 7/28/18.
//  Copyright © 2018 Antoine Clop. All rights reserved.
//

import Foundation

public class League: Decodable {
    
    public var leagueId: LeagueId
    public var tier: RankedTier
    public var leagueInfoList: [LeagueInfo]
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "leagueId"
        case tier = "tier"
        case leagueInfoList = "entries"
    }
    
    public init(leagueId: LeagueId, tier: RankedTier, leagueInfoList: [LeagueInfo]) {
        self.leagueId = leagueId
        self.tier = tier
        self.leagueInfoList = leagueInfoList
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.leagueId = try LeagueId(container.decode(String.self, forKey: .leagueId))
        self.tier = try RankedTier(container.decode(String.self, forKey: .tier))
        self.leagueInfoList = try container.decode([LeagueInfo].self, forKey: .leagueInfoList)
    }
}
