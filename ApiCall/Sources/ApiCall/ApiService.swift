import Foundation

// An api service that is responsible to make calls by using an injected executer.
//
// Possible enhancements:
// - token service
// - pre and post request manipulating hooks
// - additional features and caches...
open class ApiService {
    
    /// A Lock queue that is used for minor operations.
    private let lockQueue: DispatchQueue = DispatchQueue(label: "com.ApiService.lock")
    
    /// base URL for all request from this Api (if available)
    /// Use this to create multiple APis for different services.
    private let baseURL: URL?
    
    /// Contains all tasks currently being executed
    private var inflightTasks: Set<NSURLApiExecuter> = Set()
    
    /// Use this to create muktiple Apis for each service
    /// - Parameter url: base URL for all request from this Api
    public init(url: URL? = nil) {
        self.baseURL = url
    }
    
    /// Cancells all executing requests
    public func cancelAllInflightRequests() {
        lockQueue.async {
            self.inflightTasks.forEach({ $0.cancel() })
            self.inflightTasks.removeAll()
        }
    }
    
    // Mark: Task Executing

    /// Perfoms an API request and returns a response
    /// - Parameters:
    ///   - request: the request to execute
    ///   - callback: the callback that will be called on the default APi Queue
    public func performRequest(_ request: ApiRequestInterface, callback: @escaping (Result<Data, ApiError>) -> Void) {
        
        // build the request for the executed
        let apiRequest = taskForRequest(request)
        
        // Note:
        // _NSURLApiExecuter_ is being used here
        // this can be injected for more abstract usecases if we want to
        // use multiple executer types (URL, Alamofire) within the same project.
        // but for now, lets use it directly here since its quicker.
        let executingTask = NSURLApiExecuter(request: apiRequest)
        
        insertInflightTask(task: executingTask)

        // execute the task
        executingTask.execute { [weak self] (result) in
            guard let self = self else { return }
            self.removeInflightTask(task: executingTask)
            self.handleResponse(request: request, response: result, callback: callback)
        }
    }
    
    /// Returns the full Url for the request
    func getFullUrl(_ pathUrl: URL) -> URL {
        if let baseURL = baseURL {
            return baseURL.appendingPathComponent(pathUrl.path)
        }
        return pathUrl
    }
    
    func taskForRequest(_ request: ApiRequestInterface) -> ApiExecutingRequest {
        ApiExecutingRequest(
            url: getFullUrl(request.url),
            method: request.method,
            headers: request.headers ?? [:]
        )
    }
    
    // Mark: Response Handling
    
    func handleResponse(
        request: ApiRequestInterface,
        response: Result<Data, ApiError>,
        callback: @escaping (Result<Data, ApiError>) -> Void
    ) {
        switch response {
        case .failure(let error):
            callback(.failure(error))
        case .success(let data):
            callback(.success(data))
        }
    }
    
    // Mark: Task tracking
    
    func insertInflightTask(task: NSURLApiExecuter) {
        lockQueue.async {
            self.inflightTasks.insert(task)
        }
    }
    
    func removeInflightTask(task: NSURLApiExecuter) {
        lockQueue.async {
            self.inflightTasks.remove(task)
        }
    }
    
}
