//
//  GetDataOperation.swift
//  weatherClient
//
//  Created by Inpu on 05.08.18.
//  Copyright © 2018 sergey.shvetsov. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation : AsyncOperation {
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}
