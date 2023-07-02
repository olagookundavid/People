//
//  DetailView.swift
//  Peoples
//
//  Created by David OH on 24/06/2023.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var dvm = DetailViewModel()
    let userId: Int
    
    var body: some View {
        ZStack {
            background
            
            if(dvm.isLoading){
                ProgressView()
            }
            else{
                ScrollView{
                    VStack(alignment: .leading, spacing: 18){
                    avatar
                    Group{
                           General
                            link
                       }
                       .padding(.horizontal,8)
                       .padding(.vertical,18)
                       .background(Theme.detailBackground,in:RoundedRectangle(cornerRadius: 16,style: .continuous))
                        
                        
                        
                    }.padding()
                }
            }
            
        }
        .navigationTitle("Details")
        .onAppear{
            dvm.fetchUsers(userId: userId)
        } .alert(isPresented: $dvm.hasError, error: dvm.error) {
            
        }
    }
}

private extension DetailView{
 
    
    var background: some View{
        Theme.background.ignoresSafeArea(edges:.top)
    }
    
    @ViewBuilder
    var avatar: some View{
        
        if let avatarString =  dvm.userInfo?.data.avatar,
           let avatarUrl = URL(string: avatarString){
            
            AsyncImage(url: avatarUrl) { Image in
                Image
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(height: 130)
                    .clipped()
            } placeholder: {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame( height: 130)
            }
            
        }}
    
  @ViewBuilder
    var link: some View{
        if let supportAbsString = dvm.userInfo?.support.url,
           let supportUrl = URL(string: supportAbsString),
           let supportTxt = dvm.userInfo?.support.text{
            
          Link(destination: supportUrl){
                HStack{
                    VStack(alignment: .leading, spacing: 8){
                        Text(supportTxt)
                            .foregroundColor(Theme.text)
                            .font(.system(.body, design: .rounded)
                                .weight(.semibold))
                            .multilineTextAlignment(.leading)
                        Text(supportAbsString)
                    }
                    Spacer()
                    Symbols.link
                        .font(.system(.title3,design: .rounded))
                }
            }
        }
        
        
        
      
    }
}

private extension DetailView{
 
    var General : some View{
        VStack(alignment: .leading, spacing: 8){
            PillView(id: dvm.userInfo?.data.id  ?? 0)
            
            Group{
               FirstName
                LastName
                Email
            }
                
        }
       
    }
    
    
    @ViewBuilder
    var FirstName: some View{
        Text("First Name")
            .font(.system(.body, design: .rounded)
                .weight(.semibold))
        Text(dvm.userInfo?.data.firstName ?? "__")
            .font(.system(.subheadline, design: .rounded)
                )
        Divider()
    }
    @ViewBuilder
    var LastName: some View{
        Text("Last Name")
            .font(.system(.body, design: .rounded)
                .weight(.semibold))
        Text(dvm.userInfo?.data.lastName ?? "__")
            .font(.system(.subheadline, design: .rounded)
                )
        Divider()
    }
    @ViewBuilder
    var Email: some View{
        Text("Email")
            .font(.system(.body, design: .rounded)
                .weight(.semibold))
        Text(dvm.userInfo?.data.email ?? "__")
            .font(.system(.subheadline, design: .rounded)
                )
    }
}


struct DetailView_Previews: PreviewProvider {
    private static var previewUserId: Int{
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        return users.data.first!.id
    }
    
    
    static var previews: some View {
        NavigationView {
            DetailView(userId: previewUserId)
        }
    }
}
