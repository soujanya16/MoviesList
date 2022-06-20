//
//  ViewController.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import UIKit

class ViewController: BaseViewController,Storyboarded {
    var safeArea: UILayoutGuide!
    var nextButton: UIButton!
    fileprivate var viewModel = MovieslistViemodel()
    weak var coordinator: MainCoordinator?
        
    lazy var moviesTableView: UITableView = {
        let tableView =  UITableView(frame: view.bounds, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Movies App"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        loadUI()
        registerTableViewCells()
        if Reachability.isConnectedToNetwork(){
            viewModel.networkService.getMovies()
        }
        bindObjects()
    }
    
    /// Method to set all binding object functionality
    private func bindObjects() {
        viewModel.reloadTable.bind { [weak self] shouldReload in
            if shouldReload {
                self?.view.layoutIfNeeded()
                if let id = self?.viewModel.output.getSelectedMovieObject?.id {
                    self?.nextButton.backgroundColor = id == 0 ? .lightGray : .black
                    self?.nextButton.isUserInteractionEnabled = id == 0 ? false : true
                }
                self?.moviesTableView.reloadData()
            }
        }
    }

    ///Set UP UI for NEXT button
    private func loadUI() {
        nextButton =  getButtonOutlet(title: "Next")
        nextButton.addTarget(self, action: #selector(self.navigationToDetails(_:)), for: .touchUpInside)
        layoutSubviews()
        moviesTableView.backgroundColor = UIColor.bgGrayColor()
    }
    
    ///Register tabelcells
    private func registerTableViewCells() {
        moviesTableView.register(MoviesCell.self, forCellReuseIdentifier: "MoviesCell")
        moviesTableView.register(MovieCellHorizontal.self, forCellReuseIdentifier: "MovieCellHorizontal")
    }
        
    ///NAVIGAtion to MOvies details Screen
    @objc private func navigationToDetails(_ sender : UIButton) {
        let vc = MovieDetailsViewController.instantiate()
        vc.moviewObj = self.viewModel.output.getSelectedMovieObject
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func layoutSubviews() {
        [ moviesTableView, nextButton].forEach {
            self.view.addSubview($0)
        }        
        NSLayoutConstraint.activate([
           moviesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
           moviesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
           moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
           moviesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
   }
}

//MARK: - Tableview delegate and Data source methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.numberOfItems(section: section)
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.sectionNamesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.section  == 0 {
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "MovieCellHorizontal", for: indexPath) as? MovieCellHorizontal{
                cell1.configureCell(viewModels: viewModel, int: indexPath.row)
                cell =  cell1
            }
        }
        else {
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as? MoviesCell{
                cell1.configureCell(indexPath: indexPath , viewModelObj : viewModel)
                cell = cell1
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForItem(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.output.headerHeight ?? 0.0
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.frame = CGRect(x:10, y: 0, width: tableView.bounds.width - 20 , height: 44)
        label.text = viewModel.output.getSectionTitle(section: section)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .blue
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 != indexPath.section {
            viewModel.input.selectedMovieIndex(indexPath.row , section: indexPath.section)
        }
    }
}
