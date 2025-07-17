# 🐾 Pet Monitor

### _Monitoramento inteligente para o bem-estar do seu melhor amigo._

![Banner do Pet Monitor](https://i.imgur.com/8i2Dk4G.png) 
*Sugestão: Crie um banner legal para o projeto e substitua o link acima.*

<p align="center">
  <img alt="Linguagem" src="https://img.shields.io/badge/Linguagem-Dart-blue.svg">
  <img alt="Framework" src="https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter">
  <img alt="Licença" src="https://img.shields.io/badge/Licen%C3%A7a-MIT-green.svg">
  <img alt="Status" src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow.svg">
</p>

## 📖 Sobre o Projeto

O **Pet Monitor** é um aplicativo multiplataforma desenvolvido em Flutter, projetado para ser o anjo da guarda digital dos seus animais de estimação. A aplicação permitirá o monitoramento em tempo real dos sinais vitais dos pets, utilizando sensores de hardware (como **DS18B20** para temperatura e **MAX30102** para frequência cardíaca e SpO₂) integrados via Node-RED.

Este projeto não é apenas uma ferramenta útil para donos de pets, mas também um campo de estudo e aprimoramento em desenvolvimento mobile, gerenciamento de estado e integração com hardware (IoT).

## ✨ Funcionalidades Principais

* **📈 Monitoramento em Tempo Real:** Acompanhe os sinais vitais do seu pet, incluindo frequência cardíaca, temperatura e saturação de oxigênio (SpO₂).
* **📊 Gráficos Históricos:** Visualize o histórico de dados vitais em gráficos intuitivos e fáceis de entender.
* **🐶 Gestão de Pets:** Adicione, edite e remova múltiplos perfis de pets, com foto, nome, raça e idade.
* **🔔 Sistema de Alertas:** Defina limites de sinais vitais personalizados para cada pet e receba alertas caso algo esteja fora do normal.
* **📱 Interface Moderna:** Uma UI limpa e amigável, com suporte a temas claro e escuro.
* **👤 Autenticação de Usuário:** Tela de login para acesso seguro à aplicação.

## 🛠️ Tecnologias Utilizadas

Este projeto foi construído com as seguintes tecnologias:

* **Frontend:** Flutter e Dart
* **Gerenciamento de Estado:** `provider`
* **Gráficos:** `fl_chart`
* **Seleção de Imagens:** `image_picker`
* **IoT (Planejado):** Node-RED, ESP32/ESP8266
* **Sensores (Planejado):** DS18B20 (Temperatura), MAX30102 (Frequência Cardíaca e SpO₂)

## 📸 Telas do App

<table>
  <tr>
    <td align="center"><strong>Login</strong></td>
    <td align="center"><strong>Home (Seus Pets)</strong></td>
     <td align="center"><strong>Medições</strong></td>
  </tr>
  <tr>
    <td><img src="https://i.imgur.com/your-login-screenshot.png" width="200" alt="Tela de Login"></td>
    <td><img src="https://i.imgur.com/your-home-screenshot.png" width="200" alt="Tela Home"></td>
    <td><img src="https://i.imgur.com/your-measurements-screenshot.png" width="200" alt="Tela de Medições"></td>
  </tr>
    <tr>
    <td align="center"><strong>Alertas</strong></td>
    <td align="center"><strong>Adicionar/Editar Pet</strong></td>
     <td align="center"><strong>Configurações</strong></td>
  </tr>
  <tr>
    <td><img src="https://i.imgur.com/your-alerts-screenshot.png" width="200" alt="Tela de Alertas"></td>
    <td><img src="https://i.imgur.com/your-form-screenshot.png" width="200" alt="Formulário de Pet"></td>
    <td><img src="https://i.imgur.com/your-settings-screenshot.png" width="200" alt="Tela de Configurações"></td>
  </tr>
</table>

*Sugestão: Tire screenshots das telas do seu app, faça o upload em um site como o [Imgur](https://imgur.com/) e substitua os links acima.*

## 🚀 Como Executar o Projeto

Siga os passos abaixo para executar o projeto em sua máquina local.

### **Pré-requisitos**

* Você precisa ter o **[Flutter SDK](https://flutter.dev/docs/get-started/install)** instalado em sua máquina.
* Um editor de código como **VS Code** ou **Android Studio**.

### **Instalação**

1.  **Clone o repositório:**
    ```sh
    git clone [https://github.com/zraul2007/flutter_application_1.git](https://github.com/zraul2007/flutter_application_1.git)
    ```
2.  **Navegue até o diretório do projeto:**
    ```sh
    cd flutter_application_1
    ```
3.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```
4.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

## 📂 Estrutura do Projeto

O código-fonte está organizado da seguinte forma para facilitar a manutenção e escalabilidade:


lib
├── models/         # Classes de modelo de dados (Pet, Alert, etc.)
├── pages/          # As telas principais do aplicativo (Home, Login, etc.)
├── providers/      # Lógica de negócio e gerenciamento de estado (PetProvider)
├── services/       # Serviços de dados (simulados ou reais)
├── widgets/        # Widgets reutilizáveis (PetCard, VitalsChart, etc.)
└── main.dart       # Ponto de entrada da aplicação


## 🗺️ Planos Futuros

Este projeto é uma base sólida, mas há muitas ideias para o futuro, alinhadas com o objetivo de criar uma solução completa e robusta:

* [ ] **Integração Real com Hardware:** Conectar o app ao Node-RED via MQTT ou WebSockets para receber dados reais dos sensores.
* [ ] **Contas de Usuário Completas:** Implementar cadastro e recuperação de senha.
* [ ] **Banco de Dados na Nuvem:** Sincronizar os dados dos pets e usuários com um serviço como Firebase ou Supabase.
* [ ] **Notificações Push:** Enviar alertas para o celular do usuário mesmo com o app fechado.
* [ ] **Relatórios Avançados:** Gerar relatórios em PDF sobre a saúde do pet.

## 📜 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

---

<p align="center">
  Feito com ❤️ por <b>Raul</b>
</p>
