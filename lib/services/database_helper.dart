// lib/services/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'quiz_quest.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo_name TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        xp INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE Categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        icon_asset TEXT,
        color_hex TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        question_text TEXT NOT NULL,
        options TEXT NOT NULL,
        correct_answer_index INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES Categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE QuizResults (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        category_id INTEGER,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        date_played TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES Users (id),
        FOREIGN KEY (category_id) REFERENCES Categories (id)
      )
    ''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    // =========================================================================
    // CATEGORY 1: HISTORY
    // =========================================================================
    int historyId = await db.insert('Categories', {'name': 'History', 'description': 'Journey through time!', 'icon_asset': 'assets/icons/history.png', 'color_hex': 'FFC107'});
    // --- Easy (4) ---
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'In which year did the Titanic sink?', 'options': jsonEncode(['1905', '1912', '1918', '1923']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Who was the famous queen of ancient Egypt known for her beauty?', 'options': jsonEncode(['Hatshepsut', 'Nefertiti', 'Cleopatra', 'Sobekneferu']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Which country gifted the Statue of Liberty to the USA?', 'options': jsonEncode(['United Kingdom', 'France', 'Spain', 'Italy']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Great Wall of China was built to protect against which group?', 'options': jsonEncode(['The Romans', 'The Vikings', 'The Mongols', 'The Japanese']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    // --- Normal (7) ---
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Who was the first emperor of Rome?', 'options': jsonEncode(['Julius Caesar', 'Augustus', 'Nero', 'Caligula']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Magna Carta was signed by which English king?', 'options': jsonEncode(['King Henry VIII', 'King Richard I', 'King John', 'King Edward I']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Renaissance, a period of great cultural change, began in which country?', 'options': jsonEncode(['France', 'Greece', 'Spain', 'Italy']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'What ancient civilization built the city of Machu Picchu?', 'options': jsonEncode(['The Aztecs', 'The Maya', 'The Inca', 'The Olmec']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Battle of Waterloo in 1815 marked the final defeat of which leader?', 'options': jsonEncode(['Genghis Khan', 'Alexander the Great', 'Napoleon Bonaparte', 'Attila the Hun']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Who was the leader of the Soviet Union during World War II?', 'options': jsonEncode(['Vladimir Lenin', 'Mikhail Gorbachev', 'Leon Trotsky', 'Joseph Stalin']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The famous "I have a dream" speech was delivered by which activist?', 'options': jsonEncode(['Malcolm X', 'Martin Luther King Jr.', 'Rosa Parks', 'Nelson Mandela']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    // --- Hard (11) ---
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Thirty Years\' War was primarily fought in which modern-day country?', 'options': jsonEncode(['Spain', 'Russia', 'Sweden', 'Germany']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'What was the "Manhattan Project"?', 'options': jsonEncode(['A plan to invade Japan', 'The development of the atomic bomb', 'A New York City building project', 'The creation of the United Nations']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Who was the last Tsar of Russia?', 'options': jsonEncode(['Peter the Great', 'Ivan the Terrible', 'Nicholas II', 'Alexander III']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The ancient city of Carthage was located on the coast of which modern-day country?', 'options': jsonEncode(['Egypt', 'Greece', 'Libya', 'Tunisia']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'What was the name of the treaty that officially ended World War I?', 'options': jsonEncode(['The Treaty of Paris', 'The Geneva Convention', 'The Treaty of Versailles', 'The Yalta Conference']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The Ottoman Empire was centered in what modern-day country?', 'options': jsonEncode(['Greece', 'Iran', 'Egypt', 'Turkey']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Which dynasty ruled China for the longest period of time?', 'options': jsonEncode(['Han Dynasty', 'Tang Dynasty', 'Ming Dynasty', 'Zhou Dynasty']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The "Bay of Pigs" invasion was a failed attempt by the USA to overthrow which leader?', 'options': jsonEncode(['Ho Chi Minh', 'Fidel Castro', 'Mao Zedong', 'Augusto Pinochet']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'Who was the primary author of the U.S. Declaration of Independence?', 'options': jsonEncode(['George Washington', 'Benjamin Franklin', 'Thomas Jefferson', 'John Adams']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'The "War of the Roses" was a series of civil wars for the throne of which country?', 'options': jsonEncode(['France', 'Spain', 'Scotland', 'England']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': historyId, 'question_text': 'In what year did the Berlin Wall fall, leading to the reunification of Germany?', 'options': jsonEncode(['1985', '1991', '1989', '1993']), 'correct_answer_index': 2, 'difficulty': 'Hard'});


    // =========================================================================
    // CATEGORY 2: SCIENCE
    // =========================================================================
    int scienceId = await db.insert('Categories', {'name': 'Science', 'description': 'Explore the universe.', 'icon_asset': 'assets/icons/science.png', 'color_hex': '4CAF50'});
    // --- Easy (5) ---
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the powerhouse of the cell?', 'options': jsonEncode(['Nucleus', 'Ribosome', 'Mitochondrion', 'Golgi Apparatus']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What planet is known as the Red Planet?', 'options': jsonEncode(['Jupiter', 'Mars', 'Venus', 'Saturn']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is H2O also known as?', 'options': jsonEncode(['Salt', 'Sugar', 'Water', 'Oxygen']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What force pulls objects towards the center of the Earth?', 'options': jsonEncode(['Magnetism', 'Friction', 'Gravity', 'Tension']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'How many planets are in our solar system?', 'options': jsonEncode(['7', '8', '9', '10']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    // --- Normal (6) ---
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the chemical symbol for gold?', 'options': jsonEncode(['Ag', 'Au', 'Pb', 'Fe']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the largest organ in the human body?', 'options': jsonEncode(['Liver', 'Brain', 'Heart', 'Skin']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'Photosynthesis is a process used by which organisms?', 'options': jsonEncode(['Animals', 'Fungi', 'Plants', 'Bacteria']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the hardest natural substance on Earth?', 'options': jsonEncode(['Gold', 'Iron', 'Quartz', 'Diamond']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'The Earth\'s atmosphere is primarily composed of which gas?', 'options': jsonEncode(['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What type of star is the Sun?', 'options': jsonEncode(['Red Giant', 'White Dwarf', 'Yellow Dwarf', 'Blue Supergiant']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    // --- Hard (10) ---
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'E = mc^2 is an equation from which theory?', 'options': jsonEncode(['General Relativity', 'Quantum Mechanics', 'String Theory', 'Special Relativity']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the most abundant element in the Earth\'s crust?', 'options': jsonEncode(['Iron', 'Silicon', 'Oxygen', 'Aluminum']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What does "DNA" stand for?', 'options': jsonEncode(['Deoxyribonucleic Acid', 'Dironucleic Acid', 'Denatured Ribosome Acid', 'Digital Nucleic Archive']), 'correct_answer_index': 0, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'Which of these is NOT a noble gas?', 'options': jsonEncode(['Helium', 'Neon', 'Argon', 'Chlorine']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the study of fungi called?', 'options': jsonEncode(['Botany', 'Zoology', 'Mycology', 'Virology']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the speed of light in a vacuum (approximately)?', 'options': jsonEncode(['300,000 km/h', '300,000 km/s', '3,000,000 km/s', '30,000 km/s']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'Which scientist is credited with the laws of motion and universal gravitation?', 'options': jsonEncode(['Albert Einstein', 'Galileo Galilei', 'Isaac Newton', 'Nikola Tesla']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'What is the process of a solid changing directly into a gas called?', 'options': jsonEncode(['Evaporation', 'Condensation', 'Melting', 'Sublimation']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'How many bones are in the adult human body?', 'options': jsonEncode(['206', '212', '198', '221']), 'correct_answer_index': 0, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': scienceId, 'question_text': 'Which particle is responsible for carrying the electric current in metals?', 'options': jsonEncode(['Proton', 'Neutron', 'Electron', 'Photon']), 'correct_answer_index': 2, 'difficulty': 'Hard'});

    // =========================================================================
    // CATEGORY 3: GEOGRAPHY
    // =========================================================================
    int geoId = await db.insert('Categories', {'name': 'Geography', 'description': 'Explore the world!', 'icon_asset': 'assets/icons/geography.png', 'color_hex': '2196F3'});
    // --- Easy (4) ---
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the capital of Japan?', 'options': jsonEncode(['Kyoto', 'Osaka', 'Tokyo', 'Hiroshima']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which is the largest continent by land area?', 'options': jsonEncode(['Africa', 'North America', 'Asia', 'Europe']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which desert is the largest in the world?', 'options': jsonEncode(['Sahara Desert', 'Gobi Desert', 'Antarctic Polar Desert', 'Arabian Desert']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the capital of France?', 'options': jsonEncode(['Lyon', 'Marseille', 'Paris', 'Nice']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    // --- Normal (5) ---
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which river is the longest in the world?', 'options': jsonEncode(['Amazon', 'Nile', 'Yangtze', 'Mississippi']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Mount Everest is located in which mountain range?', 'options': jsonEncode(['The Andes', 'The Rockies', 'The Alps', 'The Himalayas']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the smallest country in the world?', 'options': jsonEncode(['Monaco', 'Nauru', 'Vatican City', 'San Marino']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which country has the most natural lakes?', 'options': jsonEncode(['USA', 'Australia', 'India', 'Canada']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the capital of Australia?', 'options': jsonEncode(['Sydney', 'Melbourne', 'Canberra', 'Perth']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    // --- Hard (10) ---
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'The Atacama Desert is located on which continent?', 'options': jsonEncode(['Africa', 'Australia', 'North America', 'South America']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the only city in the world located on two continents?', 'options': jsonEncode(['Cairo', 'Istanbul', 'Panama City', 'Suez']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which country is known as the "Land of a Thousand Lakes"?', 'options': jsonEncode(['Sweden', 'Norway', 'Finland', 'Switzerland']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the world\'s most populous landlocked country?', 'options': jsonEncode(['Ethiopia', 'Uganda', 'Afghanistan', 'Nepal']), 'correct_answer_index': 0, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'The Strait of Gibraltar separates the Iberian Peninsula from which continent?', 'options': jsonEncode(['Asia', 'Africa', 'South America', 'Australia']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the deepest point in the world\'s oceans?', 'options': jsonEncode(['Tonga Trench', 'Puerto Rico Trench', 'Mariana Trench', 'Java Trench']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Which of these countries does NOT border the Black Sea?', 'options': jsonEncode(['Romania', 'Turkey', 'Ukraine', 'Hungary']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the name of the sea that separates Australia and New Zealand?', 'options': jsonEncode(['Coral Sea', 'Tasman Sea', 'Arafura Sea', 'Timor Sea']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'Victoria Falls is located on the border of which two countries?', 'options': jsonEncode(['Kenya and Tanzania', 'Zambia and Zimbabwe', 'South Africa and Botswana', 'Angola and Namibia']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': geoId, 'question_text': 'What is the northernmost capital city in the world?', 'options': jsonEncode(['Oslo, Norway', 'Helsinki, Finland', 'Reykjavik, Iceland', 'Stockholm, Sweden']), 'correct_answer_index': 2, 'difficulty': 'Hard'});

    // =========================================================================
    // CATEGORY 4: MOVIES
    // =========================================================================
    int movieId = await db.insert('Categories', {'name': 'Movies', 'description': 'Lights, Camera, Action!', 'icon_asset': 'assets/icons/movies.png', 'color_hex': 'E91E63'});
    // --- Easy (5) ---
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which movie features the character "Darth Vader"?', 'options': jsonEncode(['Star Trek', 'The Lord of the Rings', 'Star Wars', 'Harry Potter']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'In "The Lion King", what is Simba\'s father\'s name?', 'options': jsonEncode(['Scar', 'Mufasa', 'Zazu', 'Timon']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What kind of fish is Nemo in "Finding Nemo"?', 'options': jsonEncode(['Goldfish', 'Pufferfish', 'Clownfish', 'Angelfish']), 'correct_answer_index': 2, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which school does Harry Potter attend?', 'options': jsonEncode(['Durmstrang', 'Beauxbatons', 'Ilvermorny', 'Hogwarts']), 'correct_answer_index': 3, 'difficulty': 'Easy'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is the name of the friendly ghost in a 1995 film?', 'options': jsonEncode(['Beetlejuice', 'Casper', 'Swayze', 'Slimer']), 'correct_answer_index': 1, 'difficulty': 'Easy'});
    // --- Normal (6) ---
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Who directed the movie "Pulp Fiction"?', 'options': jsonEncode(['Steven Spielberg', 'Martin Scorsese', 'James Cameron', 'Quentin Tarantino']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'In "The Matrix", what color pill does Neo take?', 'options': jsonEncode(['The Blue Pill', 'The Green Pill', 'The Red Pill', 'The Yellow Pill']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which actor plays the character of Iron Man?', 'options': jsonEncode(['Chris Evans', 'Chris Hemsworth', 'Mark Ruffalo', 'Robert Downey Jr.']), 'correct_answer_index': 3, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is the name of the fictional African country in "Black Panther"?', 'options': jsonEncode(['Genosha', 'Wakanda', 'Sokovia', 'Latveria']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which 1994 film starring Tom Hanks won the Academy Award for Best Picture?', 'options': jsonEncode(['Pulp Fiction', 'Forrest Gump', 'The Shawshank Redemption', 'Quiz Show']), 'correct_answer_index': 1, 'difficulty': 'Normal'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is the name of the hobbit who takes the One Ring to Mordor?', 'options': jsonEncode(['Bilbo Baggins', 'Samwise Gamgee', 'Frodo Baggins', 'Pippin Took']), 'correct_answer_index': 2, 'difficulty': 'Normal'});
    // --- Hard (10) ---
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which film won the first-ever Academy Award for Best Picture?', 'options': jsonEncode(['The Jazz Singer', 'Wings', 'Metropolis', 'Sunrise']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'In the movie "Blade Runner", what are the bioengineered androids called?', 'options': jsonEncode(['Cylons', 'Synthetics', 'Replicants', 'Terminators']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is the name of the hotel in Stanley Kubrick\'s "The Shining"?', 'options': jsonEncode(['The Overlook Hotel', 'The Grand Budapest Hotel', 'The Bates Motel', 'The Dolphin Hotel']), 'correct_answer_index': 0, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Who directed the 2001 film "Spirited Away"?', 'options': jsonEncode(['Isao Takahata', 'Satoshi Kon', 'Katsuhiro Otomo', 'Hayao Miyazaki']), 'correct_answer_index': 3, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is "Rosebud" in the film "Citizen Kane"?', 'options': jsonEncode(['His wife\'s nickname', 'His secret lover', 'His childhood sled', 'His hidden fortune']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which Alfred Hitchcock film was the first American movie to show a flushing toilet?', 'options': jsonEncode(['Vertigo', 'North by Northwest', 'Psycho', 'The Birds']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which movie is famous for the line, "I drink your milkshake!"?', 'options': jsonEncode(['No Country for Old Men', 'The Departed', 'There Will Be Blood', 'Goodfellas']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'What is the occupation of the protagonist, Rick Deckard, in "Blade Runner"?', 'options': jsonEncode(['Police Officer', 'Private Detective', 'Bounty Hunter', 'Smuggler']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'In "2001: A Space Odyssey", what is the name of the rebellious AI?', 'options': jsonEncode(['Skynet', 'HAL 9000', 'GLaDOS', 'VIKI']), 'correct_answer_index': 1, 'difficulty': 'Hard'});
    await db.insert('Questions', {'category_id': movieId, 'question_text': 'Which film by Andrei Tarkovsky involves a mysterious, wish-granting location called "The Zone"?', 'options': jsonEncode(['Solaris', 'Andrei Rublev', 'Stalker', 'The Mirror']), 'correct_answer_index': 2, 'difficulty': 'Hard'});
  }

  Future<User?> registerUser(String pseudo, String email, String password) async {
    final db = await database;
    try {
      int id = await db.insert('Users', {
        'pseudo_name': pseudo,
        'email': email,
        'password_hash': _hashPassword(password)
      }, conflictAlgorithm: ConflictAlgorithm.fail);
      final newUserMap = await db.query('Users', where: 'id = ?', whereArgs: [id]);
      return User.fromMap(newUserMap.first);
    } catch (e) {
      print("Error registering user (likely a duplicate email/pseudo): $e");
      return null;
    }
  }
//login ---to ---database
  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email, _hashPassword(password)],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUserXp(int userId, int xpGained) async {
    final db = await database;
    await db.rawUpdate('UPDATE Users SET xp = xp + ? WHERE id = ?', [xpGained, userId]);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('Categories');
  }

  Future<List<Map<String, dynamic>>> getQuestionsForCategory(int categoryId, String difficulty, {required int limit}) async {
    final db = await database;
    return await db.query(
      'Questions',
      where: 'category_id = ? AND difficulty = ?',
      whereArgs: [categoryId, difficulty],
      orderBy: 'RANDOM()',
      limit: limit,
    );
  }

  Future<void> saveResult(int userId, int categoryId, int score, int totalQuestions) async {
    final db = await database;
    await db.insert('QuizResults', {
      'user_id': userId,
      'category_id': categoryId,
      'score': score,
      'total_questions': totalQuestions,
      'date_played': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getResultsForUser(int userId, int categoryId) async {
    final db = await database;
    return await db.query(
        'QuizResults',
        where: 'user_id = ? AND category_id = ?',
        whereArgs: [userId, categoryId],
        orderBy: 'date_played ASC'
    );
  }
}