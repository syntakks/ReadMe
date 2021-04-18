//
//  DetailViewController.swift
//  ReadMe
//
//  Created by Steve Wall on 4/10/21.
//

import UIKit

class DetailViewController: UITableViewController {
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    // Properties
    var book: Book
    
    @IBOutlet var readMeButton: UIButton!
    
    @IBAction func toggleReadMe() {
        book.readMe.toggle()
        let image = book.readMe
            ? LibrarySymbol.bookmarkFill.image
            : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) { fatalError("This should never be called")}
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = book.title
        authorLabel.text = book.author
        imageView.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
        imageView.layer.cornerRadius = 16
        
        let image = book.readMe
            ? LibrarySymbol.bookmarkFill.image
            : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
        
        if let review = book.review {
            reviewTextView.text = review
        }
        reviewTextView.addDoneButton()
    }
    
    @IBAction func saveChanges() {
        book.review = reviewTextView.text
        Library.update(book: book)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType =
            UIImagePickerController.isSourceTypeAvailable(.camera)
            ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

}

// MARK: - Photo Picker Delegate
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        book.image = selectedImage
        dismiss(animated: true)
    }
}

// MARK: - Text View Delegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
}
