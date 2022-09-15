//___FILEHEADER___

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View {
    // Injected dependencies
    @StateObject var model: ___VARIABLE_productName:identifier___Model
    let interactor: ___VARIABLE_productName:identifier___Interactable?
    let destination: ___VARIABLE_productName:identifier___Destination?

    var body: some View {
        Text("___VARIABLE_productName:identifier___")
            .task { await fetch() }
    }
}

// MARK: - Actions

private extension ___VARIABLE_productName:identifier___View {
    func fetch() async {
        let request = ___VARIABLE_productName:identifier___API.FetchRequest()
        await interactor?.fetch(with: request)
    }
}

// MARK: - Localization

/*private extension Text {
    static let navigationTitle = Text(
        "navigation_title",
        tableName: "___VARIABLE_productName:identifier___",
        comment: "The navigation bar title for the screen"
    )
}*/

// MARK: - Previews

#if DEBUG
struct ___VARIABLE_productName:identifier___View_Previews: PreviewProvider {
    static var previews: some View {
        ___VARIABLE_productName:identifier___View(
            model: ___VARIABLE_productName:identifier___Model(),
            interactor: nil,
            destination: nil
        )
    }
}
#endif
