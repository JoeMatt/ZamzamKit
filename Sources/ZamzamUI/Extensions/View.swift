//
//  View.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Returns a type-erased view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

public extension View {
    /// Binds the height of the view to a property.
    func assign(heightTo height: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear { height.wrappedValue = geometry.size.height }
            }
        )
    }
}

#if os(iOS)
struct RoundedRect: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}

public extension View {
    /// Clips this view to its bounding frame, with the specified corner radius.
    ///
    ///     Text("Rounded Corners")
    ///         .frame(width: 175, height: 75)
    ///         .foregroundColor(Color.white)
    ///         .background(Color.black)
    ///         .cornerRadius(25, corners: [.topLeft, .topRight])
    ///
    /// Creates and returns a new Bézier path object with a rectangular path rounded at the specified corners.
    /// For rounding all corners, use the native `.cornerRadius(_ radius:)` function.
    ///
    /// - Parameters:
    ///   - radius: The corner radius.
    ///   - corners: A bitmask value that identifies the corners that you want rounded.
    ///     You can use this parameter to round only a subset of the corners of the rectangle.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedRect(radius: radius, corners: corners))
    }
}
#endif
