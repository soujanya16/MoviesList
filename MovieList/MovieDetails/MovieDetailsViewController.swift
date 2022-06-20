//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by soujanya Balusu on 16/06/22.
//

import UIKit
import SDWebImage


class MovieDetailsViewController: BaseViewController,Storyboarded {

    weak var coordinator: MainCoordinator?
    var stack = UIStackView()
    let placeholderImage = UIImage(named: "placeholder")
    var moviewObj : MovieDetails?
    var imageBgView = UIView()
   
    let movieImageView:UIImageView = {
        let img = UIImageView()
        img.imageCorners(40)
        img.translatesAutoresizingMaskIntoConstraints = true
        return img
    }()
    
    var nameLabel = MyLabel()
    var descriptionLabel = MyLabel()
    var ratingLabel = MyLabel()
    var dateLabel = MyLabel()
    var originalLanguageLabel = MyLabel()
    
    
    lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        [self.descriptionLabel,
         self.ratingLabel,
         self.dateLabel,
         self.originalLanguageLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Movie Details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        layoutSubviews()
        descriptionLabel.attributedText = String(format: "Description : %@",moviewObj?.overview ?? "").withBoldText(text: "Description :")
        ratingLabel.attributedText = String(format: "Rating : %f",moviewObj?.rating ?? 0.0).withBoldText(text: "Rating :")
        dateLabel.attributedText =  String(format: "Date : %@", moviewObj?.release_date ?? "").withBoldText(text: "Date :")
        originalLanguageLabel.attributedText = String(format: "Language : %@", moviewObj?.original_language ?? "").withBoldText(text: "Language :")
        loadImage()
    }
    
    private func loadImage() {
        let strImage : String = moviewObj?.backdrop_path  ?? ""
        self.movieImageView.sd_setImage(with: NSURL(string: HttpRouter.movieImage.description + strImage as String ) as URL?, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if( error != nil)
            {
                debugPrint("Error while displaying image" , (error?.localizedDescription)! as String)
            }
        })
    }
    
    private  func layoutSubviews() {
      let frameWidth = self.view.frame.width/2
      let frameHeight = self.view.frame.height/3.5
      imageBgView .frame = CGRect(x: frameWidth - 100, y: 100, width: 200, height: frameHeight)
      imageBgView.layer.cornerRadius = 10.0
      imageBgView.backgroundColor = UIColor.bgGrayColor()
      
      movieImageView .frame = CGRect(x: 60, y:10, width: 80, height: 80)
      nameLabel .frame = CGRect(x: imageBgView .frame.width/2 - 70, y:80, width: 150, height: 100)
      nameLabel.text = moviewObj?.title
      nameLabel.textAlignment = .center
      detailsStackView .frame = CGRect(x: 10 , y: frameHeight + 130, width: frameWidth*2 - 20, height: 280)
      [ imageBgView, movieImageView,nameLabel,detailsStackView].forEach {
          self.view.addSubview($0)
      }
      [  movieImageView,nameLabel].forEach {
          self.imageBgView.addSubview($0)
      }
      
  }
    
   
    
}

