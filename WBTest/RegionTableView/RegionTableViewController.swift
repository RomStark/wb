//
//  RegionTableViewController.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import UIKit

final class RegionTableViewController: UIViewController {
    
    private let regionTableView = UITableView()
    private let isLoadIndicatorView = UIActivityIndicatorView()
    private let myRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.alpha = 0.0
        return refresh
    }()
    
    private let viewModel = RegionTableViewModel()
    
    private var tableViewCells: [RegionTableCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupTableView()
        bindViewModel()
        setupIsLoadingIndicatorView()
        viewModel.getData()
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        viewModel.getData()
        sender.endRefreshing()
    }
}

private extension RegionTableViewController {
    func bindViewModel() {
        viewModel.dataSource.bind("RegionTableViewController") { [weak self] regions in
            guard let self = self,
                  let regions = regions else {
                      return
                  }
            
            self.tableViewCells = regions
            self.reloadTable()
        }
        
        viewModel.isLoading.bind("RegionTableViewController") { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.isLoadIndicatorView.startAnimating()
                } else {
                    self.isLoadIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.regionTableView.reloadData()
        }
    }
    
    func setupRegionTableView()  {
        view.addSubview(regionTableView)
        
        myRefreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        regionTableView.refreshControl = myRefreshControl
        
        regionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        regionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        regionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        regionTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        regionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    }
    
    func setupIsLoadingIndicatorView() {
        view.addSubview(isLoadIndicatorView)
        
        isLoadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        isLoadIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        isLoadIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
}


extension RegionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        regionTableView.backgroundColor = .gray
        regionTableView.delegate = self
        regionTableView.dataSource = self
        regionTableView.register(RegionTableViewCell.self, forCellReuseIdentifier: "RegionTableViewCell")
        setupRegionTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionTableViewCell.reuseIdentifier, for: indexPath) as? RegionTableViewCell
        cell?.configure(region: self.tableViewCells[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = tableViewCells[indexPath.row]
        let vc = RegionDetailViewController()
        vc.configure(region: region)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
