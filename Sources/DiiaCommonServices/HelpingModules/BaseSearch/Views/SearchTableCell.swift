import UIKit
import DiiaUIComponents

class SearchTableCell: BaseTableNibCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setTitle(title: String) {
        titleLabel.setTextWithCurrentAttributes(text: title, font: FontBook.bigText)
    }
}
