//
//  AdViewController.swift
//  GMU HackDayiOS
//
//  Created by JC Briones on 12/2/17.
//  Copyright © 2017 John Christopher Briones. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {

	
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var seller: UILabel!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var desc: UITextView!
	
	var ad: Ad!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if ad.image != "" {
			let dataDecoded : Data = Data(base64Encoded: ad.image, options: .ignoreUnknownCharacters)!
			let decodedimage:UIImage = UIImage(data: dataDecoded)!
			image.image = decodedimage
		}
		seller.text = ad.seller
		price.text = ad.price
		desc.text = ad.desc
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
