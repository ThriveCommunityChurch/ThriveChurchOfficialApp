//
//  ListenCollectionViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/19/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ListenCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	var sermonSeries = [SermonSeriesSummary]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
		
		collectionView?.dataSource = self
		collectionView?.delegate = self

        // Register cell classes
		collectionView?.register(SermonsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		
        // call the API and determine how many of them there are
		//sermonSeries = GetAllSermonSeries()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SermonsCollectionViewCell
		
		// AsyncLoadUIImage(uri: "https://thrive-fl.org/wp-content/uploads/2018/02/Selfless_Art.jpg", cell: cell)
		//cell.seriesArt = UIImageView()
		
        // Configure the cell
    
        return cell
    }

	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}

}
