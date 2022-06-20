//
//  MovieCollectionCell.swift
//  MovieList
//
//  Created by soujanya Balusu on 15/06/22.
//

import UIKit
import SDWebImage

class MovieCollectionCell: UICollectionViewCell {
    
    let placeholderImage = UIImage(named: "placeholder")
    var imageSuffixName = ""
    let nameLabel = MyLabel()
//    = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    let movieImageView:UIImageView = {
        let img = UIImageView()
        img.imageCorners(20)
        return img
    }()
    
    
    let containerView = MyView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor.bgGrayColor()
        self.layer.cornerRadius = 5
        containerView.backgroundColor = .white
    }

    func  configureCell(id : Int, viewmodel : MovieDetails?) {
        self.backgroundColor = UIColor.bgGrayColor()
        self.layer.cornerRadius = 10.0
        let strImage : String = viewmodel?.poster_path ?? ""
        self.nameLabel.text = viewmodel?.title
        self.nameLabel.textAlignment = .center
        self.layer.borderWidth = 0.0
        self.imageSuffixName = HttpRouter.movieImage.description.description + strImage
        if id == viewmodel?.id {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.blue.cgColor
        }
        self.movieImageView.sd_setImage(with: NSURL(string: imageSuffixName as String ) as URL?, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if( error != nil)
            {
                print("Error displaying image" , (error?.localizedDescription)! as String)
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [ nameLabel, movieImageView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:5),
            containerView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-5),
            containerView.heightAnchor.constraint(equalTo:self.contentView.heightAnchor),
            movieImageView.topAnchor.constraint(equalTo:self.containerView.topAnchor, constant: 10),
            movieImageView.centerXAnchor.constraint(equalTo:self.containerView.centerXAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant:40),
            movieImageView.heightAnchor.constraint(equalToConstant:40),
            
            nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor,constant: 52 ),
            nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: -10),
        ])
        nameLabel.center = self.containerView.center
        movieImageView.center = self.containerView.center
    }
}

