//
//  ConfigTimerView.swift
//  PomodoroApp
//
//  Created on 10/03/24.
//

import SwiftUI

struct ConfigTimerView: View {
    @EnvironmentObject var pomodoroFlow: PomodoroFlow
    @StateObject var viewModel = ConfigTimerViewModel()
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 45) {
            TitleView(title: "Configuração do Timer")
                .padding(.top, 29)

            bluetoothButton

            gridTimers

            button
            Spacer()
        }
        .overlay(
            CustomAlertView(title: "Conexão não efetuada", text: "Não foi possível conectar ao dispositivo. Tente novamente.", isPresented: $showAlert),
            alignment: .center // Alinha ao centro da tela
        )
        .onAppear{
            bluetoothManager.connectToPeripheral()
        }
    }
    
    var button: some View {
        HStack {
            Spacer()
            Button(action: {
//                bluetoothManager.sendData(pomodoroFlow.intListToData())
                pomodoroFlow.saveTime(customTimer: viewModel.customTime)
            }) {
                Image("play")
                    .foregroundStyle(Color.white)
                    .frame(width: 43, height: 43)
                    .padding(24)
                    .background(Color(UIColor.playButtonColor.asColor))
                    .clipShape(Circle())
            }
            Spacer()
        }
        .padding(.top, 30)
        
    }
    var bluetoothButton: some View {
        HStack {
            Spacer()
            Button(action: {
                bluetoothManager.connectToPeripheral()
            }) {
                bluetoothText
            }
            .disabled(bluetoothManager.isConnected)
            .shadow(color: Color.black.opacity(0.20), radius: 4, x: 0, y: 1)
            Spacer()
        }
        
    }
    
    var gridTimers: some View {
        VStack(alignment: .center ,spacing: 50) {
            configItem(name: "Rounds", value: "\(viewModel.customTime.rounds)", subFunc: viewModel.removeRound, addFunc: viewModel.addRound)
            configItem(name: "Tempo de Foco", value: "\(viewModel.customTime.focusTime):00", subFunc: viewModel.removeFocusTime, addFunc: viewModel.addFocusTime)
            configItem(name: "Pausa Curta", value: "\(viewModel.customTime.quickStop):00", subFunc: viewModel.removeQuickStop, addFunc: viewModel.addQuickStop)
            configItem(name: "Pausa Longa", value: "\(viewModel.customTime.longStop):00", subFunc: viewModel.removeLongStop, addFunc: viewModel.addLongStop)
        }
    }
    
    
    var bluetoothText: some View {
        if (bluetoothManager.isConnected) {
            Text("Conectado ao dispositivo")
                .foregroundStyle(Color(UIColor.mainColor.asColor))
                .font(.custom("ZillaSlab-Bold", size: 18))
                .padding(.vertical, 6)
                .padding(.horizontal, 16 )
                .background(Color(UIColor.whiteButton.asColor))
                .cornerRadius(50)
                .overlay(
                     RoundedRectangle(cornerRadius: 50)
                         .stroke(Color.black, lineWidth: 0)
                 )



        } else {
            Text("Clique para conectar ao dispositivo")
                .foregroundStyle(Color(UIColor.mainColor.asColor))
                .font(.custom("ZillaSlab-Bold", size: 18))
                .padding(.vertical, 6)
                .padding(.horizontal, 16 )
                .background(Color(UIColor.connectcolor.asColor))
                .cornerRadius(50)
                .overlay(
                     RoundedRectangle(cornerRadius: 50)
                         .stroke(Color(UIColor.mainColor.asColor), lineWidth: 1)
                 )
        }
    }
    
    private func configItem(name: String, value: String, subFunc: @escaping () -> Void, addFunc: @escaping () -> Void) -> some View {
        HStack {
            Text(name)
                .font(.custom("ZillaSlab-Medium", size: 20))
            Spacer()
            HStack {
                ButtonView(text: "-", action: subFunc)
                Text(value)
                    .frame(width: 55)
                    .font(.custom("ZillaSlab-Regular", size: 20))
                ButtonView(text: "+", action: addFunc)
            }
            .frame(width: 128)

        }
        .padding(.horizontal, 43)
    }
}

#Preview {
    ConfigTimerView()
}
