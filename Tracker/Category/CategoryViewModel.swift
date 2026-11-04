//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Amir on 03.11.2026.
//
import Foundation

final class CategoryViewModel{
    var onCategoriesChanged: (() -> Void)?
    var onCategoriesSelected: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onSelectedCategoryDeleted: (() -> Void)?
    var onSelectedCategoryRenamed: ((String) -> Void)?
    
    private let store: TrackerCategoryStoreProtocol
    private var selectedCategory: String?
    private var categories: [String] = [] {
        didSet{
            self.onCategoriesChanged?()
        }
    }
    
    init(store: TrackerCategoryStoreProtocol, selectedCategory: String?){
        self.store = store
        self.selectedCategory = selectedCategory
    }
    
    var isEmpty: Bool { categories.isEmpty }
    
    func viewDidLoad(){
        loadCategories()
    }
    
    func numberOfRows() -> Int{
        categories.count
    }
    
    func cellViewModel(at index: Int) -> CategoryCellViewModel{
        let title = categories[index]
        return CategoryCellViewModel(title: title, isSelected: title == selectedCategory)
    }
    
    func didSelectRow(at index: Int){
        let title = categories[index]
        selectedCategory = title
        onCategoriesChanged?()
        onCategoriesSelected?(title)
    }
    
    func addCategory(title: String){
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        do{
            try store.createCategory(title: trimmed)
            loadCategories()
        }catch{
            onError?("Не удалось сохранить категорию")
        }
    }
    func getCategory(at index: Int) -> String{
        guard categories.indices.contains(index) else { return ""}
        let title = categories[index]
        return title
    }
    
    func editCategory(at index: Int, newTitle: String) {
        guard categories.indices.contains(index) else { return }
        let oldTitle = categories[index]
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != oldTitle else { return }

        do {
            try store.updateCategory(oldTitle: oldTitle, newTitle: trimmed)
            if oldTitle == selectedCategory {
                selectedCategory = trimmed
                onSelectedCategoryRenamed?(trimmed)
            }
            loadCategories()
        } catch {
            onError?("Не удалось переименовать категорию")
        }
    }
    
    func deleteCategory(at index: Int) {
        guard categories.indices.contains(index) else { return }
        let title = categories[index]
        do {
            try store.deleteCategory(title: title)
            if title == selectedCategory {
                selectedCategory = nil
                onSelectedCategoryDeleted?()
            }
            loadCategories()
        } catch {
            onError?("Не удалось удалить категорию")
        }
    }
    
    private func loadCategories(){
        do{
            categories = try store.fetchCategoryTitles()
        }catch{
            onError?("Не удалось загрузить категории")
        }
    }
}
