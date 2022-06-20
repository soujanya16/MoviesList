//
//  BaseViewController.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    var backButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBack()
    }
    
    private func customizeBack() {
        let backImage = UIImage(named: "nav_back_icon")
        let backAppearance = UINavigationBarAppearance()
        backAppearance.configureWithDefaultBackground()
        backAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        navigationController?.navigationBar.scrollEdgeAppearance = backAppearance
    }
    
    @objc func backClickedBase(_: UIButton?) {
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
        self.navigationItem.title = ""
    }
    
    func getButtonOutlet(title: String) -> UIButton {
        let  button = UIButton()
        button.frame = CGRect(x: 10, y: self.view.frame.height - 50, width: self.view.frame.width - 20, height: 44)
        button.backgroundColor = .black
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.isUserInteractionEnabled = false
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    
}

