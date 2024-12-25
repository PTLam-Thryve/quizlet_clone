# Project Architecture

## Architecture Layers

1. `UI` Layer
    - **Responsibilities**:
        - Receive user input and send it to the `business_logic` layer.
        - Listen to changes from the `business_logic` layer and rebuild widgets accordingly.
    - **Components**:
        - Flutter widgets (e.g., Scaffold, ListView, TextField).
        - Flutter navigation setup (e.g., Navigator, MaterialPageRoute).
        - Flutter theme setup (e.g., ThemeData, ColorScheme).

2. `Model` Layer
    - **Responsibilities**:
        - Defines the application’s core data structures and their relationships.
    - **Components**:
        - Dart classes representing domain entities (e.g., User, FlashcardSet, Flashcard).
    - **Example**: Flashcard model class:
   ```dart
   class Flashcard {
      final String id;
      final String question;
      final String answer;
   
      Flashcard({required this.id, required this.question, required this.answer});
   
      // Helper methods (e.g., for JSON serialization/deserialization)
      factory Flashcard.fromJson(Map<String, dynamic> json) {
         return Flashcard(
            id: json['id'],
            question: json['question'],
            answer: json['answer'],
         );
      }
   
      Map<String, dynamic> toJson() {
         return {
            'id': id,
            'question': question,
            'answer': answer,
         };
      }
   }
   ```
3. `Business Logic` Layer (`BLoC` using `ChangeNotifier`)
    - **Responsibilities**:
        - Acts as the mediator between the `UI` and `Data` layers.
        - Manages application state and business rules.
            - Handle user input from the `UI` layer.
            - Fetch and manipulate data via the `Data` layer.
            - Notify the `UI` layer when the state changes.
    - **Components**:
        - `ChangeNotifier` classes for state management.
        - Business logic to handle user actions, data processing, and interaction with the data
          layer.
    - **Example**:
   ```dart
   class FlashcardSetChangeNotifier extends ChangeNotifier {
     final FlashcardService _flashcardService;
   
     List<FlashcardSet> _flashcardSets = [];
     Object? error;
   
     List<FlashcardSet> get flashcardSets => _flashcardSets;
   
     FlashcardSetChangeNotifier(this._firebaseService);
   
     Future<void> fetchFlashcardSets() async {
       try {
         _flashcardSets = await _flashcardService.getFlashcardSets();
         error = null;
       } catch (e) {
         error = e;
       } finally {
         notifyListeners();
       }
     }
   } 
   ```
4. `Data Layer`
    - **Responsibilities**:
        - Abstract away the details of Firebase data storage and retrieval..
        - Provide a simple interface for the business logic layer to interact with Firebase.
        - Handle data serialization/deserialization (converting Firebase data to `model`, f.e.
          `Flashcard`).
    - **Components**:
        - Services for Firebase Authentication (e.g., sign-up, sign-in).
        - Services for Firestore operations (e.g., CRUD operations for flashcards and flashcard
          sets).
    - **Example**:
   ```dart
   class FlashcardService {
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   
     Future<List<FlashcardSet>> getFlashcardSets() async {
       try {
         final snapshot = await _firestore.collection('flashcard_sets').get();
         return snapshot.docs.map((doc) {
           return FlashcardSet.fromJson(doc.data());
         }).toList();
       } catch (e) {
         // Handle error (e.g., log it, rethrow it, return an empty list, etc.)
         print('Error fetching flashcard sets: $e');
         return [];
       }
     }
   
     Future<void> createFlashcardSet(FlashcardSet set) async {
       try {
         await _firestore.collection('flashcard_sets').add(set.toJson());
       } catch (e) {
   // Handle error (e.g., log it, rethrow it, etc.)
         print('Error creating flashcard set: $e');
       }
     }
   }
   ```

---

## Folder Structure

Organize the project into a clean, maintainable structure:

```
lib/
├── data/
│   ├── authentication_service.dart
│   ├── flashcard_service.dart
│   ├── flashcard_set_service.dart
│   └── ...
├── models/
│   ├── flashcard.dart
│   ├── flashcard_set.dart
│   ├── user.dart
│   └── ...
├── business_logic/
│   ├── authentication_bloc.dart
│   ├── flashcard_set_list_bloc.dart
│   ├── flashcard_set_form_bloc.dart
│   ├── flashcard_form_bloc.dart
│   ├── flashcard_list_bloc.dart
│   └── ...
├── ui/
│   ├── pages/
│       ├── home_page.dart
│       ├── signin_page.dart
│       ├── signup_page.dart
│       ├── quiz_page.dart
│       └── ...
│   ├── widgets/
│       ├── flashcard_list.dart
│       ├── flashcard_form.dart
│       ├── flashcard_set_list.dart
│       ├── flashcard_set_form.dart
│       └── ...
├── main.dart
```

# Step-by-Step Guide To Implement A Feature

#### General Steps:

1. Create a model to define the structure of your data.
2. Implement business logic with mock data using `ChangeNotifier`.
3. Build the `UI` widgets and connect it to the `business_logic` layer using `Provider`.
4. Replace mock data with a data service in the `business_logic` layer.
5. Ensure seamless updates and test the functionality.

## Feature Example: Flashcard Sets List

> **NOTE**: This example does not cover all details of the implementation, but provides a general
> example for implementing a feature.

#### Step 1: Create a Model

Define the Model Class that represents the data structure for a flashcard set:

```dart
class FlashcardSet {
  final String id;
  final String name;
  final String color;

  FlashcardSet({
    required this.id,
    required this.name,
    required this.color,
  });

  // JSON serialization methods (for Firestore integration)
  factory FlashcardSet.fromJson(Map<String, dynamic> json) {
    return FlashcardSet(
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
```

#### Step 2: Create Business Logic with Mock Data

Define the Business Logic Layer using ChangeNotifier to manage the state:

- Use ChangeNotifier to manage state.
- Use mock data to simulate the behavior until the data layer is ready.

```dart
class FlashcardSetChangeNotifier extends ChangeNotifier {
  List<FlashcardSet> _flashcardSets = [];

  List<FlashcardSet> get flashcardSets => _flashcardSets;

  void fetchFlashcardSets() {
    _flashcardSets = [
      FlashcardSet(id: '1', name: 'Math', color: '#FF0000'),
      FlashcardSet(id: '2', name: 'Science', color: '#00FF00'),
    ];
    notifyListeners();
  }
}
```

#### Step 3: Create the UI

1. Define the Screen to Display Flashcard Sets:

```dart
class FlashcardSetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcard Sets')),
      body: Consumer<FlashcardSetProvider>(
        builder: (context, provider, child) {
          final sets = provider.flashcardSets;
          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final set = sets[index];
              return ListTile(
                title: Text(set.name),
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse('0xFF${set.color.substring(1)}')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

2. Use ChangeNotifierProvider to connect the FlashcardSetProvider to the UI.
    - Typically in main.dart or MaterialApp:
   ```dart
      void main() {
        runApp(
          ChangeNotifierProvider(
            create: (_) => FlashcardSetChangeNotifier(),
            child: MaterialApp(
              home: ...,
            ),
          ),
        );
      }
   ```
    - Or for specific page:
   ```dart
      class HomePage extends StatelessWidget {
      const HomePage({super.key});
   
      @override
      Widget build(BuildContext context) {
         return ChangeNotifierProvider(
            create: (_) => FlashcardSetChangeNotifier(),
            child: Scaffold(
               body: FlashcardSetsScreen(),
            ),
         )
      }
   }
   ```

#### Step 4: Replace Mock Data with Data Service

1. Create the Data Service that connects to Firebase Firestore.

```dart
class FlashcardSetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FlashcardSet>> getFlashcardSets() async {
    final snapshot = await _firestore.collection('flashcard_sets').get();
    return snapshot.docs.map((doc) {
      return FlashcardSet.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
```

2. Update the business logic to Use the Data Service and replace mock data with data service
   integration.

```dart
class FlashcardSetChangeNotifier extends ChangeNotifier {
  final FlashcardSetService _flashcardSetService;

  FlashcardSetProvider(this._flashcardSetService);

  List<FlashcardSet> _flashcardSets = [];

  List<FlashcardSet> get flashcardSets => _flashcardSets;

  Future<void> fetchFlashcardSets() async {
    _flashcardSets = await _flashcardSetService.getFlashcardSets();
    notifyListeners();
  }
}
```

3. Inject the Data Service to business logic component:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FlashcardSetChangeNotifier(FlashcardSetService()),
      child: MaterialApp(
        home: FlashcardSetsScreen(),
      ),
    ),
  );
}
```

4. Call fetchFlashcardSets in the UI and ensure data is fetched when the screen is loaded.

```dart
class FlashcardSetsScreen extends StatefulWidget {
  @override
  _FlashcardSetsScreenState createState() => _FlashcardSetsScreenState();
}

class _FlashcardSetsScreenState extends State<FlashcardSetsScreen> {
  late final FlashcardSetChangeNotifier _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Provider.of<FlashcardSetChangeNotifier>(context, listen: false);
    _bloc.fetchFlashcardSets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcard Sets')),
      body: Consumer<FlashcardSetChangeNotifier>(
        builder: (context, bloc, child) {
          final sets = bloc.flashcardSets;
          if (sets.isEmpty) {
            return Center(child: Text('No flashcard sets found.'));
          }
          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final set = sets[index];
              return ListTile(
                title: Text(set.name),
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse('0xFF${set.color.substring(1)}')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```
