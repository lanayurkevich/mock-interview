import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    @State private var isStartButtonTapped = false
    @State private var isConsentAccepted = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mock Interview for Any Position")
                    .font(.subheadline)
                    .padding()
                
                Image(.mockInterviewLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                
                Spacer()
                
                Button(action: {
                    showAlert = true
                }) {
                    Text("Start")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Consent for Data Usage"),
                        message: Text("""
                            Welcome to the Mock Interview app! To provide you with personalized feedback and enhance your interview experience, we utilize the OpenAI API, which includes features powered by Chat GPT. Before proceeding, we require your consent to collect and process your responses during the interview sessions.

                            By agreeing to this consent, you understand and agree to the following:

                            • Data Usage: Your interview responses, including text input, voice recordings, and video recordings, may be collected and processed by the OpenAI API to generate personalized feedback.
                            • Anonymity: Your responses will be anonymized and used solely for the purpose of improving the functionality and performance of the Mock Interview app. Your personal information will not be shared with any third parties.
                            • Data Security: We prioritize the security and confidentiality of your data. We implement robust measures to safeguard your information against unauthorized access, disclosure, or misuse.
                            • Opt-out Option: You have the option to opt-out of data collection and processing at any time. Simply navigate to the app settings and adjust your preferences accordingly.

                            By agreeing to this consent, you acknowledge that you have read and understood the terms outlined above, and you consent to the collection and processing of your interview responses by the OpenAI API.

                            If you have any questions or concerns regarding data usage and privacy, please contact us at [lana.yurkevich@icloud.com].

                            Thank you for your cooperation.
                        """),
                        primaryButton: .default(Text("Agree"), action: {
                            isConsentAccepted = true
                        }),
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
            .navigationTitle("Mock Interview")
            .padding()
            .background(
                NavigationLink(
                    destination: isConsentAccepted ? AnyView(InterviewQuestionsView().environment(viewModel)) : AnyView(EmptyView()),
                    isActive: $isConsentAccepted,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct InterviewQuestionsView: View {
    
    @Environment(ViewModel.self) private var viewModel: ViewModel
    
    @State private var selectedPosition = ""
    @State private var yearsOfExperience = ""
    @State private var generatedQuestions: [String] = []
    @State private var isQuestionsGenerated = false
    @State private var isLoading = false
    @State private var isDisabled = true

    @State private var errorMessage = ""
    @State private var showingAlert = false

    private let network = NetworkModel()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Position")) {
                    TextField("Enter position", text: $selectedPosition)
                        .disableAutocorrection(true) // Disable autocorrection
                }
                
                Section(header: Text("Years of Experience")) {
                    TextField("Enter years of experience", text: $yearsOfExperience)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true) // Disable autocorrection
                }
            }
            Button("Submit") {
                generateQuestions()
            }
            .buttonStyle(.bordered)
            .disabled(isDisabled || isLoading)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Interview Questions")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: selectedPosition) {
            isDisabled = selectedPosition.isEmpty || yearsOfExperience.isEmpty
        }
        .onChange(of: yearsOfExperience) {
            isDisabled = selectedPosition.isEmpty || yearsOfExperience.isEmpty
        }
        .onChange(of: isQuestionsGenerated) {
            if isQuestionsGenerated {
                viewModel.state = .question1
            }
        }
        .sheet(isPresented: $isQuestionsGenerated) {
            QuestionView(yearsOfExperience: yearsOfExperience, selectedPosition: selectedPosition, dismiss: {
                isQuestionsGenerated = false
                viewModel.reset()
            })
        }
        .alert(errorMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func generateQuestions() {
        isLoading = true
        
        guard let request = network.makeQuestionsRequest(selectedPosition: selectedPosition, yearsOfExperience: yearsOfExperience) else {
            return
        }
        network.fetchQuestions(request: request) { response in

            guard response.count == 4 else {
                errorMessage = "Bad response from Chat GPT. Sorry, try again."
                showingAlert = true
                isLoading = false
                return
            }

            DispatchQueue.main.async {
                self.generatedQuestions = response
                viewModel.questions = response
                viewModel.printedQuestion = response.first ?? "No Reponse"
                self.isQuestionsGenerated = true
                isLoading = false
            }
        }
    }
}
