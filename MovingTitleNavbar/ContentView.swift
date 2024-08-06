//
//  ContentView.swift
//  MovingTitleNavbar
//
//  Created by Moamen Hassaballah on 06/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedPage = "Home"
    
    var body: some View {
        VStack {
            
            Text(selectedPage)
                .font(.largeTitle.weight(.black))
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            
            
            CustomNavBar(
                itemsList: [
                    NavBarItem(title: "Home", icon: Image(systemName: "house")),
                    NavBarItem(title: "Favorites", icon: Image(systemName: "heart")),
                    NavBarItem(title: "Settings", icon: Image(systemName: "gear")),
                    NavBarItem(title: "Profile", icon: Image(systemName: "person"))
                ],
                onItemSelected: { position, item in
                   selectedPage =  item.title
                }
            )
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .shadow(radius: 50)
            
        }
        .padding()
    }
}


struct CustomNavBar : View{
    
    var barHeight: Int = 50
    var itemsList: [NavBarItem] = []
    var onItemSelected: (Int, NavBarItem) -> Void
    var indicatorColor: Color = .yellow
    
    @State var selectedItem = 0
    @State var titlePosition = 0
    @State var titleString = ""
    
    var body: some View {
        
        
        GeometryReader { barProxy in
            
            VStack(alignment: .leading) {
                HStack(spacing: 0){
                    
                    ForEach(
                        
                        Array(itemsList.enumerated()),
                        id: \.offset
                        
                    ){index, element in
                        
                        ZStack{
                            
                            //Add item indicator
                            if selectedItem == index {
                                Circle()
                                    .scale(0.5, anchor: .center)
                                    .fill(indicatorColor)
                                    .offset(x: 10, y:  -10)
                                    .blur(radius: 10.0)
                            }
                           
                            
                            //Add item image
                            element.icon
                                .resizable()
                                .foregroundStyle(
                                    selectedItem == index ? .black : .gray
                                )
                                .frame(
                                    width: 30,
                                    height: 30
                                )
        
                                
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                        .offset(y: selectedItem == index ? -3 : 0)
                        .animation(.spring, value: selectedItem)
                        .onTapGesture {
                            selectedItem = index
                            onItemSelected(index, element)
                            titleString = itemsList[selectedItem].title
                            
                            withAnimation(.spring, {
                                titlePosition = (Int(barProxy.size.width) / itemsList.count) *  selectedItem
                            })
                            
                        }
                        
                    }
                    
                }
                
                
                //Add item title
                Text(
                    titleString
                )
                .font(.system(size: 20, weight: .semibold))
                .frame(
                    width: barProxy.size.width / CGFloat(itemsList.count)
                )
                .offset(
                    x: CGFloat(titlePosition)
                )
                .onAppear{
                    if !itemsList.isEmpty {
                        titleString = itemsList[selectedItem].title
                    }
                }
                
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: CGFloat(barHeight)
        )
        
    }
    
    
}


#Preview {
    ContentView()
}
