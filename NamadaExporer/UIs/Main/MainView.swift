//
//  MainView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct MainView: View {
    @State private var currentState: MainState = .home
    @State private var isShowingMenu = false
    
    init() {
        UINavigationBar.appearance().scrollEdgeAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.white
            return appearance
        }()
    }
    
    var body: some View {
        ZStack {
            content
            
            if isShowingMenu {
                Color.black.opacity(0.5)
                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
                    .onTapGesture {
                        withAnimation {
                            isShowingMenu = false
                        }
                    }
                    .ignoresSafeArea()
            }
            
            HStack {
                navDrawer
                    .frame(width: navDrawerWidth)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(Color.white)
                    .offset(x: isShowingMenu ? 0: -navDrawerWidth)
                
                Spacer()
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(currentState.title)
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button {
                    withAnimation {
                        isShowingMenu.toggle()
                    }
                } label: {
                    Image(systemName: isShowingMenu ? "xmark" : "line.horizontal.3")
                        .renderingMode(.template)
                        .colorMultiply(.black)
                        .frame(width: 28)
                }
            }
            
        }
    }
}

extension MainView {
    var navDrawerWidth: CGFloat {
        UIScreen.main.bounds.width * 2 / 3
    }
    
    private var content: some View {
        ZStack {
            ForEach(MainState.allCases, id: \.self) { state in
                tabScreen(state)
                    .opacity(state == currentState ? 1 : 0)
            }
        }
    }
    
    @ViewBuilder func tabScreen(_ state: MainState) -> some View {
        switch state {
        case .home:
            HomeView()
        case .validators:
            ValidatorsView()
        case .blocks:
            BlocksView()
        case .transactions:
            TransactionsView()
        case .governance:
            TransactionsView()
        case .parameters:
            GovernanceView()
        }
    }
    
    var navDrawer: some View {
        ScrollView {
            VStack(alignment: .center) {
                ForEach(MainState.allCases, id: \.self) { state in
                    Button {
                        currentState = state
                        
                        withAnimation {
                            isShowingMenu.toggle()
                        }
                    } label: {
                        Text(state.title)
                            .foregroundColor(currentState == state ? .black: .gray)
                            .bold()
                            .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                            .padding(.all, 16)
                    }
                }
                
                Button {
                    if let url = URL(string: "https://docs.namada.info/") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("Docs")
                        .foregroundColor(.gray)
                        .bold()
                        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                        .padding(.all, 16)
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
