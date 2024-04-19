//
//  ViewController.swift
//  Demo-App-Unsplash
//
//  Created by Rajesh Jha on 18/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    let APIKey = "GzNM_E4Q0gIWiHGAtgHlPElNrpAZFdr1d7_U3jT_f9Y"
    var pageNumber : Int = 0
    var isPageRefreshing : Bool = false
    let photoView = PhotoView()
    var pictureInfo = [ImageInfo]() {
        didSet{
            DispatchQueue.main.async {
                self.photoView.myCollectionView.reloadData()
                print(self.pictureInfo[0].urls)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view = photoView
        photoView.myCollectionView.dataSource = self
        photoView.myCollectionView.delegate = self
        fetchImages(page: pageNumber)
    }
    
    //MARK: - Functions
        
    func fetchImages(page:Int) {
        let address = "https://api.unsplash.com/photos/?client_id=\(APIKey)&order_by=latest&per_page=10&page=\(String(page))"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    do{
                        let decoder = JSONDecoder()
                        let picInfo = try decoder.decode([ImageInfo].self, from: data)
                        self.pictureInfo.append(contentsOf: picInfo)
                        self.isPageRefreshing = false
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
        
    }
    
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictureInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.collectionViewId, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        DispatchQueue.main.async {
            cell.myImageView.loadImages(from: self.pictureInfo[indexPath.row].urls.regularUrl)
        }
        
        return cell
    }
    
    // MARK: On end Scroll
       func scrollViewDidScroll(_ scrollView: UIScrollView) {
          if(photoView.myCollectionView.contentOffset.y >= (photoView.myCollectionView.contentSize.height - photoView.myCollectionView.bounds.size.height)) {
              if !isPageRefreshing {
                  isPageRefreshing = true
                  pageNumber = pageNumber + 1
                  fetchImages(page: pageNumber)
              }
          }
      }
    
    
}

