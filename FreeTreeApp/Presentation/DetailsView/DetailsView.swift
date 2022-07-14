//
//  DetailsView.swift
//  FreeTreeApp
//
//  Created by Ercília Regina Silva Dantas on 12/07/22.
//

import SwiftUI
import UIKit

struct DetailsView: View {
    
    var treeTags = ["boo", "foo", "boo", "boo", "foo", "boo", "boo", "foo", "boo", "boo", "foo", "boo", "boo", "foo", "boo"]
    var images = ["treeExample", "treeExample", "treeExample"]
    
    var body: some View {
        VStack{
            // Title and close action
            HStack{
                Text("Limoeiro da Prefeitura")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    print("Close it")
                },label: {
                    Image(systemName: "xmark" )
                        .font(Font.system(size: 20, weight: .bold))
                        .accentColor(.gray)
                        .padding(10)
                        .background(.gray)
                        .opacity(0.3)
                })
                .cornerRadius(30)
            }
            
            Spacer().frame(height: 15)
            
            // Tags
            TagsView(tags: getTagsAndSizes())
            
            Spacer().frame(height: 15)
            
            // TODO: Distance
            //            HStack{
            //                Image(systemName: "mappin.and.ellipse")
            //                    .accentColor(.gray)
            //                Text("2,3 Km de distância")
            //            }
            //
            //            Spacer().frame(height: 10)
            
            // Actions buttons
            HStack{
                Button(action: {
                    print("Rote it")
                },label: {
                    HStack{
                        Spacer()
                        Image(systemName: "arrow.up.right.diamond.fill" )
                        Text("Rotas")
                        Spacer()
                    }
                    .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .frame(height: 40)
                })
                .background(.orange)
                .cornerRadius(10)
                
                
                Spacer().frame(width: 10)
                
                Button(action: {
                    let shareImage = images[0]
                    let shareText = "Venha se conectar com a natureza você também!. Disponível para iOS 15.0 na App Store: https://apps.apple.com/app/XXXXXXXX"
                    
                    let shareItem = shareImage.isEmpty ? [shareText] :[shareText, UIImage(contentsOfFile: shareImage)!]
                    let activityVC = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
                    
                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    
                },label: {
                    Image(systemName: "square.and.arrow.up" )
                        .font(Font.system(size: 20, weight: .regular))
                        .foregroundColor(.orange)
                        .frame(width: 40, height: 40)
                })
                
                Spacer().frame(width: 10)
                
                Button(action: {
                    print("Favorite it")
                },label: {
                    // TODO: If favorite
                    // let isFavorite = true
                    // isFavorite ? "heart.fill" : "heart"
                    Image(systemName: "heart" )
                        .font(Font.system(size: 20, weight: .regular))
                        .foregroundColor(.orange)
                        .frame(width: 40, height: 40)
                })
            }
            
            Spacer().frame(height: 10)
            
            // Tree images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(images, id:\.self){ image in
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            
            Spacer().frame(height: 10)
            
            // Tree interactions
            VStack {
                List{
                    Section{
                        Button(action: {
                            // Add action call
                        },
                               label: {HStack {
                            Image(systemName: "camera.fill")
                                .font(Font.system(size: 20, weight: .regular))
                            Text("Adiconar fotos")
                        }
                        })
                        .foregroundColor(.orange)
                        
                        Button(action: {
                            // Add action call
                        }, label: {
                            HStack {
                                Image(systemName: "exclamationmark.bubble.fill")
                                    .font(Font.system(size: 20, weight: .regular))
                                Text("Comunicar problema")
                            }
                        })
                        .foregroundColor(.orange)
                        
                    }
                    .padding(0)
                    
                }
                .listStyle(.insetGrouped)
                .padding(EdgeInsets(top: -35, leading: -20, bottom: 0, trailing: -20))
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                    UITableView.appearance().isScrollEnabled = false
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    func getTagsAndSizes() -> [Tag] {
        return treeTags.map{ tag in
            Tag(text: tag, size: (tag as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]).width)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
