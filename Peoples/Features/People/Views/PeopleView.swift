//
//  PeopleView.swift
//  Peoples
//
//  Created by David OH on 23/06/2023.
//

import SwiftUI

struct PeopleView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var users: [User] = []
    @State private var showCreate = false
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(users,id: \.id){user in
                            NavigationLink(destination: DetailView(), label: {
                                PersonItemView(user: user)
                            })
                        }.padding()
                    }
                }
                .navigationTitle("People")
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        create
                    }
                }
            }
            .onAppear{
                do{
                    let res = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
                    users = res.data
                } catch{
                    print (error)
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateView()
            }
        }
    }
}

private extension PeopleView{
    var create: some View{
        Button{
            showCreate.toggle()
        }label: {
            Symbols.plus
                .font(.system(.headline,design: .rounded).bold())
        }
    }
    
    var background: some View{
        Theme.background.ignoresSafeArea(edges:.top)
    }
}




struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
