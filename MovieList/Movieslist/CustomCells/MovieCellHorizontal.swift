//
//  MovieCellHorizontal.swift
//  MovieList
//
//  Created by soujanya Balusu on 15/06/22.
//

import UIKit

protocol MovieCellHorizontalDelegate: AnyObject {
    func movieCellHorizontalDelegate( didselect item: Int)
}

class MovieCellHorizontal: UITableViewCell {
    fileprivate var viewModel = MovieslistViemodel()
    var favourites = [MovieDetails]()
    var onTap: (() -> ())? = nil
    var collectionView: UICollectionView!
    weak var delegate: MovieCellHorizontalDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
  
    }
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 120)
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(
            frame: self.frame,
            collectionViewLayout: layout)
        
        contentView.backgroundColor = .clear
        self.collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        self.collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        self.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(viewModels : MovieslistViemodel, int : Int){
        self.favourites = viewModels.favoritesList
        viewModel = viewModels
        collectionView.reloadData()
    }
    override func layoutSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 10),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,constant: 10)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension MovieCellHorizontal: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        cell.configureCell(id : self.viewModel.output.getSelectedMovieObject?.id ?? 0 ,
                           viewmodel : viewModel.favoritesList[indexPath.item])
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.selectedMovieIndex(indexPath.item , section: 0)
        delegate?.movieCellHorizontalDelegate(didselect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
        
    }
    
}
