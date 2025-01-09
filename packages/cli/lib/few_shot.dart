import "dart:io";
import "package:langchain/langchain.dart";
import "package:langchain_google/langchain_google.dart";

void main() async {
  final chatModel = ChatGoogleGenerativeAI(
    apiKey: Platform.environment["GOOGLEAI_API_KEY"],
    defaultOptions: const ChatGoogleGenerativeAIOptions(
      model: "gemini-1.5-flash",
      temperature: 0,
    ),
  );

  final promptTemplate = PromptTemplate.fromTemplate(
    """
    Analyze the sentiment of the text below.
    Respond only with one word to describe the sentiment.

    INPUT: I absolutely adore sunny days!
    OUTPUT: POSITIVE

    INPUT: The sky is blue, and clouds are white.
    OUTPUT: NEUTRAL

    INPUT: I can't believe they canceled the show; it's so frustrating!
    OUTPUT: NEGATIVE

    INPUT: {text}
    OUTPUT:
    """,
  );

  // final chain = promptTemplate | chatModel | const StringOutputParser();

  final chain = promptTemplate.pipe(chatModel).pipe(const StringOutputParser());

  final sentiment =
      await chain.invoke({"text": "The food here is absolutely delicious!"});

  // final res = promptTemplate
  //     .format({"text": " The food here is absolutely delicious!"});

  // final sentiment = await chatModel.invoke(PromptValue.string(res));

  print(sentiment); // Outputs: POSITIVE
}
