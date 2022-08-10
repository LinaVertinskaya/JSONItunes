//
//  ViewController.swift
//  JSONItunes
//
//  Created by Лина Вертинская on 9.08.22.
//

import UIKit

class ViewController: UIViewController {

    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?

    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchBar()
    }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        print("track?.artworkUrl60:", track?.artworkUrl60)
        cell.textLabel?.text = track?.trackName
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponse) in
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
        })
    }
}

