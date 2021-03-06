//
//  MainCoordinator.swift
//  MovieTest
//
//  Created by Tiara on 12/07/22  .
//

import Foundation

class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    
    private let router: Router
    private let factory: MainFactory
    
    init(router: Router, factory: MainFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        self.showMovieList()
    }
    
    private func showMovieList() {
        let view = factory.makeMovieListView()
        view.onCardTapped = { [weak self] (movie) in
            guard let self = self else { return }
            self.showMovieDetail(movie: movie)
        }
        router.setRootModule(view, hideBar: false, animation: .bottomUp)
    }
    
    private func showMovieDetail(movie: MovieModel) {
        let view = factory.makeMovieDetailView()
        view.model = MovieDetailModel(id: movie.id, title: movie.name, movieImage: movie.imageUrl, duration: "", genres: [], overview: movie.overview)
        router.push(view)
    }
}
