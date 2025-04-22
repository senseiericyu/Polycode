//  Drag and Drop

import SwiftUI

struct TokenView: View {
    let question: String
    let originalTokens: [String]
    let correctOrder: [Int]
    var onAnswered: ((Bool) -> Void)? = nil
    
    @State private var currentOrder: [String]? = nil
    @State private var isAnswered = false
    @State private var isCorrect = false
    
    @State var progress: CGFloat = 0
    @State var dropComponents: [DropComponents] = dropcomponents_
    
    //MARK: Custom Grid Arrays
    // for Drag Part
    @State var shuffledRows: [[DropComponents]] = []
    // for Drop Part
    @State var rows: [[DropComponents]] = []
    
    // animation
    @State var animateWrongText: Bool = false
    @State var droppedCount: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 15) {
            NavBar()
            
            VStack(alignment: .leading, spacing: 30) {
                //MARK: question
                Text(question)
                    .font(.title2.bold())
            }
            .padding(.top, 30)
            
            //MARK: Drag Drop Area
            DropArea()
                .padding(.vertical, 30)
            DragArea()
        }
        .padding()
        .onAppear {
            if rows.isEmpty {
                // creating shuffled one
                // then normal one
                dropComponents = dropComponents.shuffled()
                shuffledRows = generateGrid()
                dropComponents = dropcomponents_
                rows = generateGrid()
                
            }
        }
        .offset(x: animateWrongText ? -30 : 0)
        
        
        
        Spacer()
    }
    
    //MARK: Drop Area
    @ViewBuilder
    func DropArea() -> some View {
        VStack(spacing: 12) {
            ForEach($rows, id: \.self) { $row in
                HStack(spacing: 10) {
                    ForEach($row) { $item in
                        DropTokenView(item: $item) { providers in
                            if let first = providers.first {
                                let _ = first.loadObject(ofClass: URL.self) { value, error in
                                    guard let url = value else { return }
                                    
                                    if item.id == "\(url)" {
                                        droppedCount += 1
                                        let progress = droppedCount / CGFloat(dropComponents.count)
                                        withAnimation {
                                            item.isShowing = true
                                            updateShuffledArray(dropComponents: item)
                                            self.progress = progress
                                        }
                                    } else {
                                        animateView()
                                    }
                                }
                            }
                            return false
                        }
                    }
                }

                if rows.last != row {
                    Divider()
                }
            }
        }
    }

//    @ViewBuilder
//    func DropArea()->some View {
//        VStack(spacing: 12) {
//            ForEach($rows, id: \.self) { $row in
//                HStack(spacing: 10) {
//                    ForEach($row) {$item in
//                        
//                        Text(item.value)
//                            .font(.system(size: item.fontSize))
//                            .padding(.vertical, 5)
//                            .padding(.horizontal, item.padding)
//                            .opacity(item.isShowing ? 1 : 0)
//                            .background {
//                                RoundedRectangle(cornerRadius: 6, style: .continuous)
//                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
//                            }
//                            .background {
//                                // if item is dropped into correct place
//                                RoundedRectangle(cornerRadius: 6, style: .continuous)
//                                    .stroke(.gray)
//                                    .opacity(item.isShowing ? 1 : 0)
//                            }
//                        // MARK: Adding Drop Operation
//                            .onDrop(of: [.url], isTarged: .constant(false)) {
//                                providers in
//                                
//                                if let first = providers.first{
//                                    let _ = first.loadObject(ofClass: URL.self) { value,error in
//                                        
//                                        guard let url = value else {return}
//                                        if item.id == "\(url)" {
//                                            droppedCount += 1
//                                            let progress = (droppedCount / CGFloat(dropComponents.count))
//                                            withAnimation{
//                                                item.isShowing = true
//                                                updateShuffledArray(dropComponents: item)
//                                                self.progress = progress
//                                            }
//                                        }
//                                        else {
//                                            // animating when wrong text dropped
//                                            animateView()
//                                        }
//                                    }
//                                }
//                                
//                                return false
//                            }
//                    }
//                }
//                
//                if rows.last != row {
//                    Divider()
//                }
//            }
//        }
//    }
    
    @ViewBuilder
    func DragArea()->some View {
        VStack(spacing: 12) {
            ForEach(shuffledRows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row) {item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                        //MARK: Adding Drag Operation
                            .onDrag {
                                // Returning id to find which item is moving
                                return .init(contentsOf: URL(string: item.id))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                    }
                }
                
                if shuffledRows.last != row {
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func NavBar()->some View {
        HStack(spacing: 18){
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.25))
                    
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 20)
        }
    }
    
    //MARK: Generating Custom Grid Columns
    func generateGrid()->[[DropComponents]]{
        // Step1
        // Identifying Each Text Width and updating it into State Variable
        for item in dropComponents.enumerated() {
            let textSize = textSize(dropComponent: item.element)
            
            dropComponents[item.offset].textSize = textSize
        }
        
        var gridArray: [[DropComponents]] = []
        var tempArray: [DropComponents] = []
        
        // current width
        var currentWidth: CGFloat = 0
        // -30 --> horizontal padding
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for dropComponent in dropComponents {
            currentWidth += dropComponent.textSize
            
            if currentWidth < totalScreenWidth {
                tempArray.append(dropComponent)
            }
            else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = dropComponent.textSize
                tempArray.append(dropComponent)
            }
        }
        
        // Edge case checks
        if !tempArray.isEmpty {
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    //MARK: Identifying Text Size
    func textSize(dropComponent: DropComponents)->CGFloat{
        let font = UIFont.systemFont(ofSize: dropComponent.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (dropComponent.value as NSString).size(withAttributes: attributes)
        
        // horizontal padding
        // Adding HStack Spacing
        return size.width + (dropComponent.padding * 2) + 15
    }
    
    // MARK: Updating Shuffled Array
    func updateShuffledArray(dropComponents: DropComponents) {
        for index in shuffledRows.indices {
            for subIndex in shuffledRows[index].indices {
                if shuffledRows[index][subIndex].id == dropComponents.id {
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    // MARK: Animating View When Wrong Text Dropped
    func animateView() {
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
                animateWrongText = false
            }
        }
    }
}

struct DropTokenView: View {
    @Binding var item: DropComponents
    let onDrop: ([NSItemProvider]) -> Bool

    var body: some View {
        Text(item.value)
            .font(.system(size: item.fontSize))
            .padding(.vertical, 5)
            .padding(.horizontal, item.padding)
            .opacity(item.isShowing ? 1 : 0)
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
            }
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.gray)
                    .opacity(item.isShowing ? 1 : 0)
            }
            .onDrop(of: [.url], isTargeted: .constant(false), perform: onDrop)
    }
}



#Preview {
    TokenView(question: "Reorder tokens to define a function that returns 10.", originalTokens: ["def", "ten", "(", ")", ":", "return", "10"], correctOrder: [0, 1, 2, 3, 4, 5, 6])
}

 
