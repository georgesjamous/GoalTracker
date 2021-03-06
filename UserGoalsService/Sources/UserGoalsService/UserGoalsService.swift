import Foundation
import ApiCall

public protocol UserGoalService {
    
    /// Create a user gols service
    /// - Parameter api: the api service to use to make requests
    init(apiService: ApiService)
    
    func fetchUserGoals(_ callback: @escaping (_ result: Result<[GoalObject], UserGoalServiceError>) -> Void)
    
    //    func addGoal()
    //    func removeGoal()
    //    func updateGoal()
}
