import "dart:io";
import "package:langchain/langchain.dart";
import "package:langchain_google/langchain_google.dart";

void main() async {
  final embeddings = GoogleGenerativeAIEmbeddings(
    apiKey: Platform.environment["GOOGLEAI_API_KEY"],
  );

  final documents = [
    const Document(
      pageContent: """
      The Hobbit by J.R.R. Tolkien
      A classic fantasy novel following the journey of Bilbo Baggins as he embarks on a quest to help dwarves reclaim their homeland from a dragon.,

      Harry Potter and the Sorcerer's Stone by J.K. Rowling
      A young wizard discovers his magical heritage and attends Hogwarts School, where he makes friends, uncovers secrets, and battles dark forces.,

      The Name of the Wind by Patrick Rothfuss
      The story of Kvothe, a gifted young man, and his rise from humble beginnings to a legendary figure.
      """,
      metadata: {"title": "Fantasy"},
    ),
    const Document(
      pageContent: """
      1984 by George Orwell
      A dystopian novel set in a totalitarian society under constant surveillance, exploring themes of control, truth, and rebellion.,

      Brave New World by Aldous Huxley
      A chilling vision of a future society where individuals are conditioned to conform, and emotions and individuality are suppressed.,

      Fahrenheit 451 by Ray Bradbury
      A story about a fireman in a future society where books are banned and burned to suppress dissenting ideas.
      """,
      metadata: {"title": "Dystopian"},
    ),
    const Document(
      pageContent: """
      Pride and Prejudice by Jane Austen
      A romantic novel about Elizabeth Bennet and her evolving relationship with the wealthy Mr. Darcy, set in 19th-century England.,

      The Notebook by Nicholas Sparks
      A tale of enduring love between Noah and Allie, spanning decades and overcoming obstacles.,

      Me Before You by Jojo Moyes
      A story about a young woman who becomes a caregiver for a paralyzed man, and the life-changing relationship they develop.
      """,
      metadata: {"title": "Romance"},
    ),
  ];

  // Generate embeddings for the existing documents
  final documentsEmbeddings = await embeddings.embedDocuments(documents);

  // New book description to classify
  const newBook = """
    **The Fellowship of the Ring by J.R.R. Tolkien**

    This epic novel is the first installment of The Lord of the Rings trilogy. 
    It follows Frodo Baggins as he begins his journey to destroy the One Ring, 
    accompanied by a fellowship of friends and allies.

    Themes:
    * Adventure and camaraderie
    * The battle between good and evil
    * Sacrifice and heroism

    Setting:
    * The rich, fantastical world of Middle-earth, with locations like the Shire, Rivendell, and Moria.

    Characters:
    * Frodo Baggins, Samwise Gamgee, Aragorn, Gandalf, and more.
  """;

  // Generate embedding for the new book
  final newBookEmbedding = await embeddings.embedQuery(newBook);

  // Use LangChain's method to find the most similar embedding
  final mostSimilarIndex =
      getIndexesMostSimilarEmbeddings(newBookEmbedding, documentsEmbeddings)
          .first;

  // Get the category based on the most similar document
  final category = documents[mostSimilarIndex].metadata["title"];

  print("The new book belongs to the genre: $category"); // Outputs: Fantasy
}
