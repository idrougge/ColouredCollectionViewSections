//
//  ViewController.swift
//  DecorationView
//
//  Created by Iggy Drougge on 2019-05-17 🇳🇴
//  Translated from "ECDecorationView" by Eric Chapman
//

import UIKit

private let kDecorationReuseIdentifier = "section_background"
private let kCellReuseIdentifier = "view_cell"

class ECCollectionViewLayout: UICollectionViewFlowLayout {
    override class var layoutAttributesClass: AnyClass {
        return ECCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 8
        self.minimumInteritemSpacing = 8
        self.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.itemSize = CGSize(width: 148, height: 115)
        
        self.register(ECCollectionReusableView.self, forDecorationViewOfKind: kDecorationReuseIdentifier)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var allAttributes = attributes
        
        for attribute in attributes {
            
            // Look for the first item in a row
            if attribute.representedElementCategory == .cell,
                attribute.frame.origin.x == self.sectionInset.left {
                
                // Create decoration attributes
                let decorationAttributes =
                    ECCollectionViewLayoutAttributes(forDecorationViewOfKind: kDecorationReuseIdentifier,
                                                     with: attribute.indexPath)
                
                // Because the convenience init above can't be overridden, we set up the colour here instead
                if attribute.indexPath.section % 2 == 0 {
                    decorationAttributes.colour = .red
                } else {
                    decorationAttributes.colour = .blue
                }
                
                // Make the decoration view span the entire row (you can do item by item as well.
                // I just chose to do it this way)
                let y = attribute.frame.origin.y - sectionInset.top
                let width = collectionViewContentSize.width
                let height = itemSize.height + minimumLineSpacing + sectionInset.top + sectionInset.bottom
                decorationAttributes.frame = CGRect(x: 0, y: y, width: width, height: height)

                // Set the zIndex to be behind the item
                decorationAttributes.zIndex = attribute.zIndex - 1
                
                // Add the attribute to the list
                allAttributes.append(decorationAttributes)
            }
        }
        
        return allAttributes
    }
}

class ECCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var colour: UIColor?
    
    // All UICollectionViewLayoutAttributes subclasses "must" override this
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ECCollectionViewLayoutAttributes
        copy.colour = self.colour
        return copy
    }
    // All subclasses "must" override this
    override func isEqual(_ object: Any?) -> Bool {
        guard
            let object = object as? ECCollectionViewLayoutAttributes,
            object.colour == self.colour
            else { return false }
        
        return super.isEqual(object)
    }
}

class ECCollectionReusableView : UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let ecLayoutAttributes = layoutAttributes as? ECCollectionViewLayoutAttributes
        self.backgroundColor = ecLayoutAttributes?.colour
    }
}

class ViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseIdentifier)
        self.collectionView.collectionViewLayout = ECCollectionViewLayout()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}

