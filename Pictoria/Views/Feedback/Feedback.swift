//
//  Feedback.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI
import CustomTextField

struct Feedback: View {

    @State var maxCount: Int = 160
    
    @State private var nameText: String = ""
    @State private var surName: String = ""
    @State private var email: String = ""
    @State private var message = "Enter your message"
    
    @State private var errorEmail = "Wrong E-mail type"
    @State private var errorName = "Name is empty"
    @State private var errorSurename = "Surename is empty"
    
    @State private var isValidName = false
    @State private var isNeedToShowNameError = false
    
    @State private var isValidSurname = false
    @State private var isNeedToShowSurnameError = false
    
    @State private var isValidEmail = false
    @State private var isNeedToShowEmailError = false
    
    @State private var isValidMessage = false

    
    var body: some View {
        VStack {
            Text("Fill in the fields below so we can contact you")
                .foregroundColor(Colors.blacker)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            Text("We will definitely answer you")
                .foregroundColor(Colors.blacker)
                .font(.system(size: 17, weight: .light))
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(spacing: 22) {
                    EGTextField(text: $nameText)
                        .setBorderColor(Colors.deepGray)
                        .setPlaceHolderText("Name")
                        .setFocusedBorderColorEnable(true)
                        .setFocusedBorderColor(Colors.deepBlue)
                        .setPlaceHolderTextColor(.red)
                        .setError(errorText: $errorName, error: $isNeedToShowNameError)
                        .setCornerRadius(10)
                        .onChange(of: email) { newValue in
                            var value = newValue.trimmingCharacters(in: .whitespaces)

                            if value.isEmpty {
                                isNeedToShowNameError = false
                            } else {
                                isNeedToShowNameError = !isValidSurname(value)
                            }
                            isValidName = isValidName(value)
                        }
                    
        
                    EGTextField(text: $surName)
                        .setBorderColor(Colors.deepGray)
                        .setPlaceHolderText("Surname")
                        .setFocusedBorderColorEnable(true)
                        .setPlaceHolderTextColor(Colors.deepBlue)
                        .setFocusedBorderColor(.red)
                        .setError(errorText: $errorSurename, error: $isNeedToShowSurnameError)
                        .setCornerRadius(10)
                        .onChange(of: email) { newValue in
                            var value = newValue.trimmingCharacters(in: .whitespaces)
                            
                            if value.isEmpty {
                                isNeedToShowSurnameError = false
                            } else {
                                isNeedToShowSurnameError = !isValidSurname(value)
                            }
                            isValidSurname = isValidSurname(value)
                        }
                    
                    EGTextField(text: $email)
                        .setBorderColor(Colors.deepGray)
                        .setPlaceHolderText("E-mail")
                        .setFocusedBorderColorEnable(true)
                        .setPlaceHolderTextColor(Colors.deepBlue)
                        .setFocusedBorderColor(.red)
                        .setError(errorText: $errorEmail, error: $isNeedToShowEmailError)
                        .setCornerRadius(10)
                        .onChange(of: email) { newValue in
                            var value = newValue.trimmingCharacters(in: .whitespaces)

                            if value.isEmpty {
                                isNeedToShowEmailError = false
                            } else {
                                isNeedToShowEmailError = !isValidEmail(value)
                            }
                            isValidEmail = isValidEmail(value)
                        }
                    
                    ZStack {
                        VStack {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $message)
                                    .foregroundColor(message == "Enter your message" ? Colors.deepGray : .black)
                                    .frame(height: 140)
                                    .padding()
                                    .padding(.leading, -5)
                                    .onTapGesture {
                                        message = ""
                                    }
                                    .onChange(of: message) { newValue in
                                        if newValue == "Enter your message" && newValue != "" {
                                            message = "Enter your message"
                                        }
                                        isValidMessage = isValidMessage(newValue)
                                    }
                            }
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color(hex: "D6D6D6"), lineWidth: 1)
                            )
                            .cornerRadius(10)
                            .frame(height: 160)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(5)
                        }
                    }
                }
                .padding(.top, 40)
                
            }
            Spacer()
            
            Button {
                nameText = ""
                surName = ""
                email = ""
                message = "Enter your message"
                
                UIApplication.shared.sendAction(#selector( UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            } label: {
                Text("Send")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            isValidName && isValidSurname && isValidEmail ? Colors.deepBlue : Colors.blacker.opacity(0.5),
                            isValidName && isValidSurname && isValidEmail ? Colors.deepBlue : Colors.blacker.opacity(0.5)
                        ]
                    ),
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
                .cornerRadius(15)
            )
            .padding(.bottom, 28)
            .disabled(!isValidName && !isValidSurname && !isValidEmail)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
    
    private func isValidMessage(_ message: String) -> Bool {
        withAnimation {
            return !message.isEmpty && message.count <= 160
        }
    }
    
    private func isValidName(_ name: String) -> Bool {
        withAnimation {
            return !name.isEmpty
        }
    }
    
    private func isValidSurname(_ surname: String) -> Bool {
        withAnimation {
            return !surname.isEmpty
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        withAnimation {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    }
}
