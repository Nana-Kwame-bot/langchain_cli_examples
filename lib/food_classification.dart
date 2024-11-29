import 'dart:io';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

void main() async {
  final embeddings = GoogleGenerativeAIEmbeddings(
    apiKey: Platform.environment['GOOGLEAI_API_KEY'],
  );

  final documents = [
    Document(
      pageContent: '''
      Bruschetta with Tomato and Basil
      Toasted baguette slices topped with a mix of diced tomatoes, fresh basil, garlic, olive oil, and a dash of balsamic vinegar.,

      Spinach and Artichoke Dip
      A creamy blend of spinach, artichoke hearts, cream cheese, sour cream, and Parmesan cheese, served warm with tortilla chips or bread.,

      Stuffed Mushrooms
      Button mushrooms filled with a mixture of cream cheese, garlic, breadcrumbs, and herbs, then baked to golden perfection.
      ''',
      metadata: {'title': 'Appetizer'},
    ),
    Document(
      pageContent: '''
      Grilled Lemon Herb Chicken
      Juicy chicken breasts marinated in a zesty lemon, garlic, and herb mix, grilled until perfectly charred.,

      Vegetable Stir-Fry with Tofu
      A colorful mix of bell peppers, broccoli, carrots, and tofu, stir-fried in a savory soy and ginger sauce, served over steamed rice.',

      Beef Lasagna
      Layers of rich meat sauce, creamy ricotta, pasta sheets, and melted mozzarella, baked until bubbly.
      ''',
      metadata: {'title': 'Main'},
    ),
    Document(
      pageContent: '''
      Tiramisu
      A classic Italian dessert made with coffee-soaked ladyfingers layered with mascarpone cream and dusted with cocoa powder.

      Chocolate Lava Cake
      Molten chocolate cakes with a gooey center, served warm with a scoop of vanilla ice cream.,

      Fruit Tart
      A buttery tart crust filled with creamy custard, topped with a vibrant arrangement of fresh fruits, glazed with apricot jam.
      ''',
      metadata: {'title': 'Dessert'},
    ),
  ];

  // Generate embeddings for the existing documents
  final documentsEmbeddings = await embeddings.embedDocuments(documents);

  // New recipe to classify
  final newRecipe = '''
    **Classic Moist Chocolate Cake**

    This recipe delivers a rich, moist chocolate cake that's
    perfect for any occasion.

    Ingredients:
    * 1 ¾ cups all-purpose flour
    * 2 cups granulated sugar
    * ¾ cup unsweetened cocoa powder
    * 1 ½ teaspoons baking powder
    * 1 ½ teaspoons baking soda
    * 1 teaspoon salt
    * 2 large eggs
    * 1 cup milk
    * ½ cup vegetable oil
    * 2 teaspoons vanilla extract
    * 1 cup boiling water

    Instructions:
    * Preheat oven to 350°F (175°C). Grease and flour two 9-inch
      round cake pans.
    * Combine dry ingredients: In a large bowl, whisk together flour,
      sugar, cocoa powder, baking powder, baking soda, and salt.
    * Add wet ingredients: Beat in eggs, milk, oil, and vanilla until
      combined.
    * Stir in boiling water: Carefully stir in boiling water. The
      batter will be thin.
    * Bake: Pour batter evenly into prepared pans. Bake for 30-35
      minutes, or until a toothpick inserted into the center comes
      out clean.
    * Cool: Let cakes cool in pans for 10 minutes before transferring
      to a wire rack to cool completely.
  ''';

  // Generate embedding for the new recipe
  final newRecipeEmbedding = await embeddings.embedQuery(newRecipe);

  // Use LangChain's method to find the most similar embedding
  final mostSimilarIndex =
      getIndexesMostSimilarEmbeddings(newRecipeEmbedding, documentsEmbeddings)
          .first;

  // Get the category based on the most similar document
  final category = documents[mostSimilarIndex].metadata['title'];

  print('The new recipe belongs to the category: $category');
}
