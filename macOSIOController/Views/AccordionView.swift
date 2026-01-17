import SwiftUI

struct AccordionView<Content: View>: View {
    let title: String
    let systemImage: String
    let section: AccordionSection
    @Binding var expandedSection: AccordionSection?
    var onExpand: (() -> Void)? = nil
    @ViewBuilder let content: () -> Content

    private var isExpanded: Bool {
        expandedSection == section
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isExpanded {
                        expandedSection = nil
                    } else {
                        expandedSection = section
                        onExpand?()
                    }
                }
            }) {
                HStack {
                    Image(systemName: systemImage)
                        .frame(width: 20)
                    Text(title)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
