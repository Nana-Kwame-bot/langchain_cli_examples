import 'dart:io';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

// Enum to represent sentiment
enum Sentiment { positive, neutral, negative }

void main() async {
  final chatModel = ChatGoogleGenerativeAI(
    apiKey: Platform.environment["GOOGLEAI_API_KEY"],
    defaultOptions: ChatGoogleGenerativeAIOptions(
        responseMimeType: "application/json",
        model: "gemini-1.5-flash",
        temperature: 0,
        responseSchema: {
          "type": "object",
          "properties": {
            "sentiment": {
              "type": "string",
              "enum": Sentiment.values.map((e) => e.name).toList()
            }
          },
          "required": ["sentiment"]
        }),
  );

  final promptTemplate = PromptTemplate.fromTemplate(
    '''
    Analyze the sentiment of the text below.
    Respond with a JSON object containing the sentiment.

    Text: {text}
    ''',
  );

  final chain = promptTemplate.pipe(chatModel).pipe(JsonOutputParser());

  final resultJson =
      await chain.invoke({"text": "The food here is absolutely delicious!"});

  final sentiment = Sentiment.values.byName(resultJson['sentiment']);

  print(Sentiment.values);

  print(sentiment); // Outputs: Sentiment.positive
}
