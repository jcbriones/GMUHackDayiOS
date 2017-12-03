//
//  ItemTableViewController.swift
//  GMU HackDayiOS
//
//  Created by John Christopher Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class ItemTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	@IBOutlet weak var adTable: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var searchFilterText: UILabel!
	
	var Ads = [Ad]()
	var filteredAds = [Ad]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Get all loan forms from the database
		fetchAllAds()
		
		searchFilterText.alpha = 0.0
		adTable.delegate = self
		adTable.dataSource = self
		
		// Setup the Search Bar
		searchBar.placeholder = "Search Item"
		definesPresentationContext = true
		
		// Setup Search Bar Delegate
		searchBar.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func includeArchives(_ sender: UISwitch) {
		// Get all loan forms from the database again
		fetchAllAds()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		setIsFilteringToShow(filteredItemCount: filteredAds.count, of: Ads.count)
		return filteredAds.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as? AdTableViewCell  else {
			fatalError("The dequeued cell is not an instance of AdTableViewCell.")
		}
		
		// Fetches the appropriate meal for the data source layout.
		let ad = filteredAds[indexPath.row]
		
		cell.titleLabel.text = ad.title
		cell.price.text = ad.price
		if ad.image != "" {
			let dataDecoded : Data = Data(base64Encoded: ad.image, options: .ignoreUnknownCharacters)!
			let decodedimage:UIImage = UIImage(data: dataDecoded)!
			cell.imageLabel.image = decodedimage
		}
		
		return cell
	}
	
	// MARK: - Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let nextScene = segue.destination as? AdViewController, let indexPath = self.adTable.indexPathForSelectedRow {
			let selected = filteredAds[indexPath.row]
			nextScene.ad = selected
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}

	// Search bar
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		filteredAds = Ads.filter({ Ad -> Bool in
			if searchText.isEmpty { return true }
			return Ad.title.lowercased().contains(searchText.lowercased())
		})
		adTable.reloadData()
	}
	
	public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
		if (filteredItemCount == totalItemCount) {
			hideFilter()
		} else if (filteredItemCount == 0) {
			searchFilterText.text = "No items match your query"
			showFilter()
		} else {
			searchFilterText.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
			showFilter()
		}
	}
	
	fileprivate func hideFilter() {
		UITextView.animate(withDuration: 0.7) {[unowned self] in
			self.searchFilterText.alpha = 0.0
		}
	}
	
	fileprivate func showFilter() {
		UITextView.animate(withDuration: 0.7) {[unowned self] in
			self.searchFilterText.alpha = 1.0
		}
	}
	
	// Private funcs
	private func fetchAllAds() {
		let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		loadingSpinner.center = self.view.center
		self.view.addSubview(loadingSpinner)
		loadingSpinner.startAnimating()
		
		ConnectToAPI().getAds() {
			(Ads, error) in
			if let Ads = Ads {
				
				// Stop loading
				loadingSpinner.stopAnimating()
				loadingSpinner.removeFromSuperview()
				
				// Successful get
				self.Ads = Ads
				self.filteredAds = self.Ads
				self.adTable.reloadData()
			} else {
				// Stop loading
				loadingSpinner.stopAnimating()
				loadingSpinner.removeFromSuperview()
				
				// Failed get
				let alertController = UIAlertController(title: "Loan Forms", message: error, preferredStyle: UIAlertControllerStyle.alert)
				alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
				self.present(alertController, animated: true, completion: nil)
			}
			
			// Redo the search again
			self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
		}
	}
}
