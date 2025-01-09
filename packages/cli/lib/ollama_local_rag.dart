import "dart:io";
import "package:langchain/langchain.dart";
import "package:langchain_chroma/langchain_chroma.dart";
import "package:langchain_community/langchain_community.dart";
import "package:langchain_google/langchain_google.dart";
import "package:langchain_ollama/langchain_ollama.dart";

void main() async {
  // Initialize embeddings using Ollama
  final embeddings = OllamaEmbeddings(model: "nomic-embed-text", keepAlive: 30);

  // Initialize vector store (using Chroma in this example)
  final vectorStore = Chroma(
    embeddings: embeddings,
    collectionName: "renewable_energy_technologies",
    collectionMetadata: {
      "description": "Documents related to renewable energy technologies",
    },
  );

  const loader = DirectoryLoader(
    "../renewable_energy_technologies",
    glob: "*.txt",
  );

  final documents = await loader.load();

  // Split documents
  const textSplitter = RecursiveCharacterTextSplitter(
    chunkSize: 1000,
  );
  final splitDocuments = textSplitter.splitDocuments(documents);

  // Add documents to vector store
  await vectorStore.addDocuments(documents: splitDocuments);

  // Initialize chat model
  // final chatModel = ChatOllama(
  //   defaultOptions: const ChatOllamaOptions(
  //     // model: "gemma2",
  //     model: "llama3.2",
  //     temperature: 0,
  //     keepAlive: 30,
  //   ),
  // );

  final chatModel = ChatGoogleGenerativeAI(
    apiKey: Platform.environment["GOOGLEAI_API_KEY"],
    defaultOptions: const ChatGoogleGenerativeAIOptions(
      model: "gemini-1.5-pro",
      temperature: 0,
    ),
  );

  // Create retriever
  final retriever = vectorStore.asRetriever(
    defaultOptions: VectorStoreRetrieverOptions(
      searchType: VectorStoreSearchType.similarity(k: 5),
    ),
  );

  // Create RAG prompt template
  final ragPromptTemplate = ChatPromptTemplate.fromTemplates(const [
    (
      ChatMessageType.system,
      """
        You are an expert assistant providing precise answers based
        strictly on the given context.

        Context Guidelines:
        - Answer only from the provided context.
        - If no direct answer exists, clearly state "I cannot find a specific
          answer in the provided documents".
        - Prioritize accuracy over comprehensiveness.
        - If context is partially relevant, explain the limitation.
        - Cite the source you used to answer the question.

        Example:
        ""
        One sentence [1]. Another sentence [2]. 

        Sources:
        [1] https://example.com/1
        [2] https://example.com/2
        ""

        CONTEXT: {context}
        
        QUESTION: {question}
      """
    ),
    (ChatMessageType.human, "{question}"),
  ]);

  // Runnable<T, RunnableOptions, T> logOutput<T extends Object>(String stepName) {
  //   return Runnable.fromFunction<T, T>(
  //     invoke: (input, options) {
  //       print('Output from step "$stepName":\n$input\n---');
  //       return Future.value(input);
  //     },
  //     stream: (inputStream, options) {
  //       return inputStream.map((input) {
  //         print('Chunk from step "$stepName":\n$input\n---');
  //         return input;
  //       });
  //     },
  //   );
  // }

  // final formattedPrompt = ragPromptTemplate.formatPrompt({
  //   "context": retriever.pipe(
  //     Runnable.mapInput<List<Document>, String>((docs) => docs.join('\n')),
  //   ),
  //   "question": "What is a solar panel?",
  // }).toChatMessages();

  // print("formattedPrompt: $formattedPrompt");

  final ragChain = Runnable.fromMap<String>({
    "context": retriever.pipe(
      Runnable.mapInput<List<Document>, String>((docs) => docs.join("\n")),
    ),
    "question": Runnable.passthrough<String>(),
  }).pipe(ragPromptTemplate).pipe(chatModel).pipe(const StringOutputParser());

  print("Local RAG CLI Application");
  print('Type your question (or "quit" to exit):');

  // CLI interaction loop
  while (true) {
    stdout.write("> ");
    final userInput = stdin.readLineSync()?.trim();

    if (userInput == null || userInput.toLowerCase() == "quit") {
      break;
    }

    try {
      print("\nThinking...\n");

      final stream = ragChain.stream(userInput);

      await for (final chunk in stream) {
        stdout.write(chunk);
      }
      print("\n");
    } catch (e) {
      print("Error processing your question: $e");
    }
  }

  print("\nThank you for using Local RAG CLI!");
}
