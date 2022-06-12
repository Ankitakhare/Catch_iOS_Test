//
//  Interactor.swift
//  TestAnkita
//
//  Created by ankita khare on 11/06/22.
//

import Foundation

struct NetworkModel: Codable {
    var id: Int?
    var title: String?
    var subtitle: String?
    var content: String?
}

class Interactor: InteractorProtocol {
    
    func getList(completion: @escaping(Result<[Model],ApiError>)->()) {
        guard let url = URL(string: "https://raw.githubusercontent.com/catchnz/ios-test/master/data/data.json")  else {
            completion(.failure(ApiError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error as? URLError {
                completion(Result.failure(ApiError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(ApiError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let networkModels = try decoder.decode([NetworkModel].self, from: data)
                    
                    completion(Result.success(self.getModelFromNetworkModel(info: networkModels)))
                    
                }catch {
                    completion(Result.failure(ApiError.parsing(error as? DecodingError)))
                }
            }
        }.resume()
    }
    
    private func getModelFromNetworkModel(info: [NetworkModel]) -> [Model] {
        var array: [Model] = []
        
        for item in info {
            let model = Model(id: item.id ?? -1, title: item.title ?? "", subTitle: item.subtitle ?? "", content: item.content ?? "")
            array.append(model)
        }
        
        return array
    }
}
