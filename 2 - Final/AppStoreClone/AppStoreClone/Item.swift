import Foundation


/*
 個々のアイテムのデータを示します。
 
 https://techlife.cookpad.com/entry/2020/12/24/130000 より
 下記のような形にして、enumのassociated valueで値を渡しても良い。
 enum Item: Hashable {
     case media(media: TsukurepoViewItem.Media?, tsukurepo: TsukurepoViewItem.Tsukurepo?)
     case margin
     case recipeTitle(TsukurepoViewItem.RecipeOverview?)
     case recipeDescription(String)
     case ingredientsHeader
     case ingredients(TsukurepoViewItem.Ingredients)
     case showMore
 }
 */
struct Item: Hashable {
    let id = UUID()
    let tagline: String
    let title: String
    let subtitle: String

    init(tagline: String = "", title: String = "", subtitle: String = "") {
        self.tagline = tagline
        self.title = title
        self.subtitle = subtitle
    }
}
