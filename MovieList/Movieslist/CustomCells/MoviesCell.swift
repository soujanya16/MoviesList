//
//  MoviesCell.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import UIKit
import SDWebImage

class MoviesCell: UITableViewCell {
    
    fileprivate var viewModel = MovieslistViemodel()
    let placeholderImage = UIImage(named: "placeholder")
    var results = [MovieDetails]()
    
    let movieImageView:UIImageView = {
        let img = UIImageView()
        img.imageCorners(20)
        return img
    }()
    
    let nameLabel = MyLabel()
    let containerView = MyView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
        setupUI()
        layoutIfNeeded()
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.bgGrayColor()
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(indexPath : IndexPath, viewModelObj : MovieslistViemodel) {
        viewModel = viewModelObj
        let result = viewModel.output.getCellObject(indexPath: indexPath)
        nameLabel.text = result.0
        containerView.layer.borderWidth = result.2 == true ? 1.0 : 0.0
        containerView.layer.borderColor = result.2 == true ? UIColor.blue.cgColor : UIColor.clear.cgColor
        let urlString = HttpRouter.movieImage.description + result.1
        self.movieImageView.sd_setImage(with: NSURL(string: urlString as String ) as URL?, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if( error != nil)
            {
                debugPrint("Error loading image" , (error?.localizedDescription)! as String)
            }
        })
    }
    
    override func layoutSubviews() {
        
        [ movieImageView, nameLabel].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant:2),
            containerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:1),
            containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-2),
            containerView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant:-2),
            movieImageView.centerYAnchor.constraint(equalTo:self.containerView.centerYAnchor),
            movieImageView.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant:10),
            movieImageView.widthAnchor.constraint(equalToConstant:40),
            movieImageView.heightAnchor.constraint(equalToConstant:40),
            nameLabel.centerYAnchor.constraint(equalTo:self.containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo:self.movieImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor)
        ])
        
       
        
    }
    
}
