//
//  MovieDetailRepositoryImpl.swift
//  MovieTest
//
//  Created by Tiara Mahardika on 13/07/22.
//

import Foundation
import RxSwift

class MovieDetailRepositoryImpl: MovieDetailRepository {
    private let castListAPI: CastListAPI
    private let movieDetailAPI: MovieDetailAPI
    private let disposeBag = DisposeBag()
    
    init(movieDetailAPI: MovieDetailAPI, castListAPI : CastListAPI) {
        self.movieDetailAPI = movieDetailAPI
        self.castListAPI = castListAPI
    }

    func requestDetail(id: Int) -> Single<(MovieDetailModel)> {
        return Single.create { (observer) in
            
            self.movieDetailAPI
                .request(id: id)
                .map { (result) in self.outputTransformModel(result) }
                .subscribe { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: MovieDetailResponse) -> Result<MovieDetailModel, HTTPError> {
        if response.statusMessage != nil{
            return .failure(HTTPError.internalError)
        }
        let imageUrl = "https://www.themoviedb.org/t/p/w500\(response.posterPath ?? "")"
        let duration = response.runtime?.minutesToHoursAndMinutes()
        let genreArr = response.genres?
            .compactMap { $0.name }
            .map { "\($0)" } ?? []
        
        let model = MovieDetailModel(id: response.id ?? 0, title: response.title ?? "", movieImage: imageUrl,
                                     duration: "\(duration?.0 ?? 0) h \(duration?.1 ?? 0) m",
                                     genres: genreArr,
                                     overview: response.overview ?? "")
        return .success(model)
    }
    
    func requestCasts(id: Int) -> Single<[CastModel]> {
        return Single.create { (observer) in
            
            self.castListAPI
                .request(id: id)
                .map { self.outputTransformModelCast($0) }
                .subscribe { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModelCast(_ response: CastListResponse) -> Result<[CastModel], HTTPError> {
        if let datas = response.cast {
            let model = datas.map { (res) in
                return CastModel(name: res.name ?? "", imageUrl: res.profilePath ?? "")
            }
            return .success(model)
        }
        return .failure(HTTPError.internalError)
    }
}

