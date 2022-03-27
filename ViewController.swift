//
//  ViewController.swift
//  MovieFlix
//
//  Created by Shruti on 25/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flixCollectionView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    
    private var flixViewModel : FlixViewModel!
    
    var collDelegate = FlixCollectionViewDelegate()
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: SCREEN_WIDTH-10, height: SCREEN_WIDTH-150)
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    
    private var dataSource : FlixCollectionViewCellDataSource<FlixCollectionViewCell,PlayingResults>!
    
    var arrResults: [PlayingResults]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        
        setUpCollectionView()
        callToViewModelForUIUpdate()
        
    }
    
    func setUpCollectionView() {
        self.flixCollectionView.collectionViewLayout = flowLayout
        self.flixCollectionView.register(UINib(nibName: "FlixCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FlixCollectionViewCell")
        self.flixCollectionView.register(UINib(nibName: "FlixUnpopularCell", bundle: nil), forCellWithReuseIdentifier: "FlixUnpopularCell")
    }
    
    func callToViewModelForUIUpdate(){
        
        self.flixViewModel =  FlixViewModel()
        self.flixViewModel.bindFlixViewModelToController = {
            self.arrResults = self.flixViewModel.nowPlayingData.results
            self.updateDataSource()
            self.delegateCall()
        }
    }
    
    func updateDataSource(){
        
        
        self.dataSource = FlixCollectionViewCellDataSource(items: arrResults, configureCell: { (cell, fnp, index) in
            
            var posterUrl = URL(string: "")
            let posterString = fnp.vote_count > 20 ? "original\(fnp.backdrop_path)" : "w342\(fnp.poster_path)"
            if let strUrl = "\(IMG_URL)\(posterString)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                  let imgUrl = URL(string: strUrl) {
                posterUrl = imgUrl
            }
            
            switch cell {
            case let cell as FlixCollectionViewCell:
                cell.imgPoster.loadImageWithUrl(posterUrl!)
                cell.btnDelete.tag = index
                cell.btnDelete.addTarget(self, action: #selector(self.onClickDelete(_:)), for: .touchUpInside)
            case let cell as FlixUnpopularCell:
                cell.imgPoster.loadImageWithUrl(posterUrl!)
                cell.lblTitle.text = fnp.original_title
                cell.lblDesc.text = fnp.overview
                cell.btnDelete.tag = index
                cell.btnDelete.addTarget(self, action: #selector(self.onClickDelete(_:)), for: .touchUpInside)
            default:
                fatalError("Unkown cell type")
            }
               
            
        })
        
        DispatchQueue.main.async {
            self.flixCollectionView.dataSource = self.dataSource
            self.flixCollectionView.delegate = self.collDelegate
            self.flixCollectionView.reloadData()
        }
    }
    
    func delegateCall() {
        collDelegate.selectedSetting = { [unowned self] selection in
            let data = self.flixViewModel.nowPlayingData.results[selection]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            vc.data = data
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
    }
   
    @IBAction func onClickSearch(_ sender: Any) {
        
        let searchTerm = txtSearch.text!
        
        if searchTerm != "" {
        arrResults = self.flixViewModel.nowPlayingData.results.filter{
            return $0.original_title.lowercased().contains(searchTerm)
        }
        }else {
            arrResults = self.flixViewModel.nowPlayingData.results
        }
        updateDataSource()
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        
        flixCollectionView.performBatchUpdates({ [self] in
            arrResults.remove(at: sender.tag)
            let indexPath = IndexPath(row: sender.tag, section: 0)
            flixCollectionView.deleteItems(at: [indexPath])

        }) { finished in
            self.updateDataSource()
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchTerm = txtSearch.text! + string
        
        if searchTerm != "" {
            arrResults = self.flixViewModel.nowPlayingData.results.filter{
                return $0.original_title.lowercased().contains(searchTerm)
            }
        }else {
            arrResults = self.flixViewModel.nowPlayingData.results
        }
        updateDataSource()
        
        return true
    }
    
}
