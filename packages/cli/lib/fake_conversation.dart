import "dart:io";
import "package:langchain/langchain.dart";
import "package:langchain_google/langchain_google.dart";

void main() async {
  final chatModel = ChatGoogleGenerativeAI(
    apiKey: Platform.environment["GOOGLEAI_API_KEY"],
    defaultOptions: const ChatGoogleGenerativeAIOptions(
      model: "gemini-1.5-pro",
      temperature: 0,
    ),
  );

  // Define the system message template
  const systemTemplate = """
  Analyze the sentiment of the text below.
  Respond only with one word to describe the sentiment.
  """;

  // Define the few-shot examples
  final fewShotPrompts = ChatPromptTemplate.fromPromptMessages([
    SystemChatMessagePromptTemplate.fromTemplate(systemTemplate),
    HumanChatMessagePromptTemplate.fromTemplate("I am so happy today!"),
    AIChatMessagePromptTemplate.fromTemplate("POSITIVE"),
    HumanChatMessagePromptTemplate.fromTemplate("The sky is blue."),
    AIChatMessagePromptTemplate.fromTemplate("NEUTRAL"),
    HumanChatMessagePromptTemplate.fromTemplate(
        "I am very disappointed with the service.",),
    AIChatMessagePromptTemplate.fromTemplate("NEGATIVE"),
    HumanChatMessagePromptTemplate.fromTemplate("I enjoy reading books."),
  ]);

  // final fewShotPrompts = ChatPromptTemplate.fromTemplates([
  //   (ChatMessageType.system, systemTemplate),
  //   (ChatMessageType.human, 'I am so happy today!'),
  //   (ChatMessageType.ai, 'POSITIVE'),
  //   (ChatMessageType.human, 'The sky is blue.'),
  //   (ChatMessageType.ai, 'NEUTRAL'),
  //   (ChatMessageType.human, "I am very disappointed with the service."),
  //   (ChatMessageType.ai, 'NEGATIVE'),
  //   (ChatMessageType.human, 'I enjoy reading books.'),
  // ]);

  final aiChatMessage = await chatModel.call(fewShotPrompts.formatMessages());

  print(aiChatMessage.content); // Outputs: POSITIVE
}
