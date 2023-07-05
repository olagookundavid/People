//
//  PeopleView.swift
//  Peoples
//
//  Created by David OH on 23/06/2023.
//
import SwiftUI

struct PeopleView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @StateObject private var pvm = PeopleViewModel()
    @State private var showCreate = false
    @State private var shouldShowSuccess = false
    @State private var hasAppeared = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                
                if pvm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(pvm.users,id: \.id){user in
                                NavigationLink(destination: DetailView(userId: user.id), label: {
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
                        ToolbarItem(placement: .navigationBarLeading){
                            refresh
                        }
                    }
                    
                }
            }
            .task{
                if(!hasAppeared){
                    await pvm.fetchUsers()
                    hasAppeared.toggle()
                }
                
            }
            .sheet(isPresented: $showCreate) {
                CreateView{
                    haptic(notification: .success)
                    withAnimation(.spring().delay(0.25)){
                        self.shouldShowSuccess.toggle()
                    }
                }
            }
            .alert(isPresented: $pvm.hasError, error: pvm.error) {
                Button("Retry"){
                    Task {
                        await  pvm.fetchUsers()
                    }
                }
                
            }
            .overlay{
                if shouldShowSuccess{
                    CheckMarkPopOverViews()
                        .transition(.scale.combined(with: .opacity))
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                                withAnimation(.spring()){
                                    shouldShowSuccess.toggle()
                                }
                            }
                        }
                }
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
        }.disabled(pvm.isLoading)
    }
    var refresh: some View{
        Button{
            Task{
                await pvm.fetchUsers()
            }
        }label: {
            Symbols.refresh
                .font(.system(.headline,design: .rounded).bold())
        }.disabled(pvm.isLoading)
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
