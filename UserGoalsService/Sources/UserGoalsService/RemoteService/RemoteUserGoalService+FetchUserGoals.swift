//
//  File.swift
//  
//
//  Created by Georges on 3/4/21.
//

import Foundation
import ApiCall

extension RemoteUserGoalService {
    // response dto
    struct Response: Decodable {
        let items: [GoalElement]
        struct GoalElement: Decodable {
            let id: String
            let title: String
            let description: String
            let type: String
            let goal: Int
            let reward: RewardElement
            struct RewardElement: Decodable {
                let trophy: String
                let points: Int
            }
        }
    }
    // Note:
    // Notice that we are no using it in the response
    // we will validate it later (Deffensive programming)
    // we dont want the api to fail if the reponse added some types
    // that we are not yet aware of. Maybe the user has an older version? or data corrupted
    enum GoalTypes: String {
        case step = "step"
        case walkingDistance = "walking_distance"
        case runningDistance = "running_distance"
        var goalType: GoalType {
            switch self {
            case .step:
                return .step
            case .runningDistance:
                return .runningDistance
            case .walkingDistance:
                return .walkingDistance
            }
        }
    }
    // same as goal types
    enum TrophyTypes: String {
        case bronzeMedal = "bronze_medal"
        case silverMedal = "silver_medal"
        case goldMedal = "gold_medal"
        case zombieHand = "zombie_hand"
        var trophyType: GoalTrophyType {
            switch self {
            case .bronzeMedal:
                return .bronzeMedal
            case .silverMedal:
                return .silverMedal
            case .goldMedal:
                return .goldMedal
            case .zombieHand:
                return .zombieHand
            }
        }
    }
    public func fetchUserGoals(_ callback: @escaping (Result<[GoalObject], UserGoalServiceError>) -> Void) {
        apiService.performRequest(ApiRequest(url: Paths.getGoals, method: .get)) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                callback(.failure(UserGoalServiceError.network(error)))
            case .success(let data):
                if let decodedData: Response = try? JSONDecoder().decode(Response.self, from: data) {
                    callback(.success(self.encodeObject(response: decodedData)))
                } else {
                    callback(.failure(UserGoalServiceError.network(.notDecodable)))
                }
            }
        }
    }
    
    // Note:
    // business level validations goe here
    //
    // for example, we require that _points_ key to be > 0
    // we could filter the corrupted data here and always make sure we
    // send back clean verified data.
    // We can add tests for this part
    //
    // we are validating the supported goal and discarding unsopported goals
    //
    // we could also use https://github.com/tristanhimmelman/ObjectMapper for more
    // advanced operations
    func encodeObject(response: Response) -> [GoalObject] {
        response.items.map { (element) -> GoalObject? in
            guard
                let goalType = RemoteUserGoalService.GoalTypes(rawValue: element.type),
                let trophyType = RemoteUserGoalService.TrophyTypes(rawValue: element.reward.trophy)  else {
                return nil
            }
            let reward = GoalRewardObject(
                trophy: trophyType.trophyType,
                points: element.reward.points
            )
            return GoalObject(
                id: element.id,
                title: element.title,
                description: element.description,
                type: goalType.goalType,
                goal: element.goal,
                reward: reward
            )
        }.compactMap({ $0 })
    }
    
}
