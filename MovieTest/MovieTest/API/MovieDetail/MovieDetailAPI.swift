//
//  MovieDetailAPI.swift
//  MovieTest
//
//  Created by Tiara Mahardika on 12/07/22.
//

import Foundation
import RxSwift

protocol MovieDetailAPI: ClientAPI {
    func request(id: Int) -> Single<MovieDetailResponse>
}
