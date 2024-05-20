import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerStack: UIStackView!
    private var engineer: Engineer? = nil
    private var profileView: ProfileView? = nil

    static func loadController(with engineer: Engineer) -> QuestionsViewController {
        let viewController = QuestionsViewController.init(nibName: String.init(describing: self), bundle: Bundle(for: self))
        viewController.loadViewIfNeeded()
        viewController.setUp(with: engineer)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    func setUp(with engineer: Engineer) {
        loadViewIfNeeded()
        addProfileView(with: engineer)
        for question in engineer.questions {
            addQuestion(with: question)
        }
    }

    private func addQuestion(with data: Question) {
        guard let cardView = QuestionCardView.loadView() else { return }
        cardView.setUp(with: data.questionText,
                       options: data.answerOptions,
                       selectedIndex: data.answer?.index)
        containerStack.addArrangedSubview(cardView)
    }
    
    private func addProfileView(with data: Engineer) {
        self.engineer = data
        guard let profileView = ProfileView.loadView() else { return }
        profileView.configure(with: .init(ID: data.ID, title: data.name, subtitle: data.role, stats: data.quickStats, iconImagePath: ""), actionHandler: {
            self.openImageGallery()
        })
        containerStack.addArrangedSubview(profileView)
        self.profileView = profileView
    }
    
    private func openImageGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary
        navigationController?.present(imagePickerController, animated: true, completion: nil)
    }
}

extension QuestionsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //do nothing for now
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let imageUrl = info[.imageURL],
              let image = info[.originalImage],
              let engineer = self.engineer
        else { return }
        ImageLoader.shared.loadImage(from: imageUrl as! URL, image: image as! UIImage)
        ImageLoader.shared.mapImageUrlWithEngineer(id: engineer.ID, profileImageUrl: imageUrl as! URL)
        self.profileView?.reloadProfileImage()
        dismiss(animated: true)
    }
}
