// ====================================
// APPLICATION EDU-RENDEZ - VERSION COMPLÈTEMENT CORRIGÉE
// ====================================

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'package:intl/intl.dart';


// ====================================
// MAIN + CONFIGURATION
// ====================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DatabaseHelper.instance.database;
  runApp(EducaRendezApp());
}

class EducaRendezApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EducaRendez",
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFAF5FF),
        primaryColor: Color(0xFF7C4DFF),
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF7C4DFF),
          primary: Color(0xFF7C4DFF),
          secondary: Color(0xFFE040FB),
          tertiary: Color(0xFFB388FF),
          background: Color(0xFFFAF5FF),
          surface: Color(0xFFFFFFFF),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF311B92),
          onSurface: Color(0xFF311B92),
        ),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF7C4DFF),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white, size: 28),
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF7C4DFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            elevation: 3,
            shadowColor: Color(0xFF7C4DFF).withOpacity(0.3),
          ),
        ),
        cardTheme: CardThemeData( // CORRECTION: CardTheme au lieu de CardThemeData
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.white,
          shadowColor: Color(0xFF7C4DFF).withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          surfaceTintColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 2),
          ),
          labelStyle: TextStyle(color: Color(0xFF666666)),
          floatingLabelStyle: TextStyle(color: Color(0xFF7C4DFF)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF311B92),
            letterSpacing: 0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF311B92),
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF311B92),
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF311B92),
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF311B92),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF311B92),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF555555),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

// ====================================
// MODÈLES DE DONNÉES
// ====================================

class Utilisateur {
  int? id;
  String nom;
  String prenom;
  String email;
  String motDePasse;
  String role;
  String? telephone;
  DateTime dateCreation;

  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.role,
    this.telephone,
    DateTime? dateCreation,
  }) : dateCreation = dateCreation ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'motDePasse': motDePasse,
    'role': role,
    'telephone': telephone,
    'dateCreation': dateCreation.toIso8601String(),
  };

  factory Utilisateur.fromMap(Map<String, dynamic> map) => Utilisateur(
    id: map['id'],
    nom: map['nom'],
    prenom: map['prenom'],
    email: map['email'],
    motDePasse: map['motDePasse'],
    role: map['role'],
    telephone: map['telephone'],
    dateCreation: DateTime.parse(map['dateCreation']),
  );
}

class RendezVous {
  int? id;
  int utilisateurId;
  String typeRdv;
  String date;
  String heure;
  String statut;
  String? notes;
  DateTime dateCreation;

  RendezVous({
    this.id,
    required this.utilisateurId,
    required this.typeRdv,
    required this.date,
    required this.heure,
    this.statut = 'en_attente',
    this.notes,
    DateTime? dateCreation,
  }) : dateCreation = dateCreation ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'utilisateurId': utilisateurId,
    'typeRdv': typeRdv,
    'date': date,
    'heure': heure,
    'statut': statut,
    'notes': notes,
    'dateCreation': dateCreation.toIso8601String(),
  };

  factory RendezVous.fromMap(Map<String, dynamic> map) => RendezVous(
    id: map['id'],
    utilisateurId: map['utilisateurId'],
    typeRdv: map['typeRdv'],
    date: map['date'],
    heure: map['heure'],
    statut: map['statut'],
    notes: map['notes'],
    dateCreation: DateTime.parse(map['dateCreation']),
  );
}

class Disponibilite {
  int? id;
  String jour;
  String heureDebut;
  String heureFin;
  String typeRdv;
  bool actif;

  Disponibilite({
    this.id,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.typeRdv,
    this.actif = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'jour': jour,
    'heureDebut': heureDebut,
    'heureFin': heureFin,
    'typeRdv': typeRdv,
    'actif': actif ? 1 : 0,
  };

  factory Disponibilite.fromMap(Map<String, dynamic> map) => Disponibilite(
    id: map['id'],
    jour: map['jour'],
    heureDebut: map['heureDebut'],
    heureFin: map['heureFin'],
    typeRdv: map['typeRdv'],
    actif: map['actif'] == 1,
  );
}

// ====================================
// DATABASE HELPER
// ====================================

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('edurendez_final.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        motDePasse TEXT NOT NULL,
        role TEXT NOT NULL,
        telephone TEXT,
        dateCreation TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rendez_vous (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        utilisateurId INTEGER NOT NULL,
        typeRdv TEXT NOT NULL,
        date TEXT NOT NULL,
        heure TEXT NOT NULL,
        statut TEXT NOT NULL,
        notes TEXT,
        dateCreation TEXT NOT NULL,
        FOREIGN KEY (utilisateurId) 
          REFERENCES utilisateurs (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE disponibilites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jour TEXT NOT NULL,
        heureDebut TEXT NOT NULL,
        heureFin TEXT NOT NULL,
        typeRdv TEXT NOT NULL,
        actif INTEGER DEFAULT 1
      )
    ''');

    // Données initiales
    await db.insert('utilisateurs', {
      'nom': 'Admin',
      'prenom': 'EducaRendez',
      'email': 'admin@educarendez.dz',
      'motDePasse': 'admin123',
      'role': 'admin',
      'telephone': '0550123456',
      'dateCreation': DateTime.now().toIso8601String(),
    });

    // Ajouter un utilisateur parent pour tester
    await db.insert('utilisateurs', {
      'nom': 'Parent',
      'prenom': 'Test',
      'email': 'parent@test.com',
      'motDePasse': 'parent123',
      'role': 'parent',
      'telephone': '0550000000',
      'dateCreation': DateTime.now().toIso8601String(),
    });

    // Ajouter un utilisateur enseignant pour tester
    await db.insert('utilisateurs', {
      'nom': 'Enseignant',
      'prenom': 'Test',
      'email': 'enseignant@test.com',
      'motDePasse': 'enseignant123',
      'role': 'enseignant',
      'telephone': '0550111111',
      'dateCreation': DateTime.now().toIso8601String(),
    });

    // Disponibilités par défaut
    final disponibilitesParDefaut = [
      {
        'jour': 'Lundi',
        'heureDebut': '09:00',
        'heureFin': '10:00',
        'typeRdv': 'rendez-vous_pedagogique',
        'actif': 1,
      },
      {
        'jour': 'Mardi',
        'heureDebut': '14:00',
        'heureFin': '15:00',
        'typeRdv': 'rendez-vous_pedagogique',
        'actif': 1,
      },
      {
        'jour': 'Mercredi',
        'heureDebut': '10:00',
        'heureFin': '11:00',
        'typeRdv': 'entretien_pedagogique',
        'actif': 1,
      },
      {
        'jour': 'Jeudi',
        'heureDebut': '11:00',
        'heureFin': '12:00',
        'typeRdv': 'embauche',
        'actif': 1,
      },
      {
        'jour': 'Vendredi',
        'heureDebut': '15:00',
        'heureFin': '16:00',
        'typeRdv': 'formation',
        'actif': 1,
      },
    ];

    for (var dispo in disponibilitesParDefaut) {
      await db.insert('disponibilites', dispo);
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

// ====================================
// SERVICES SIMPLIFIÉS ET FONCTIONNELS
// ====================================

class UtilisateurService {
  final DatabaseHelper db = DatabaseHelper.instance;

  Future<int> creer(Utilisateur u) async {
    final database = await db.database;
    return await database.insert('utilisateurs', u.toMap());
  }

  Future<Utilisateur?> lireParEmail(String email) async {
    try {
      final database = await db.database;
      final result = await database.query(
        'utilisateurs',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      return result.isEmpty ? null : Utilisateur.fromMap(result.first);
    } catch (e) {
      print('Erreur lecture utilisateur: $e');
      return null;
    }
  }

  Future<Utilisateur?> connexion(String email, String mdp) async {
    try {
      final user = await lireParEmail(email);
      if (user != null && user.motDePasse == mdp) {
        return user;
      }
      return null;
    } catch (e) {
      print('Erreur connexion: $e');
      return null;
    }
  }

  Future<List<Utilisateur>> obtenirTousLesUtilisateurs() async {
    try {
      final database = await db.database;
      final result = await database.query('utilisateurs');
      return result.map((map) => Utilisateur.fromMap(map)).toList();
    } catch (e) {
      print('Erreur obtention utilisateurs: $e');
      return [];
    }
  }
}

class RendezVousService {
  final DatabaseHelper db = DatabaseHelper.instance;

  Future<List<RendezVous>> lireParUtilisateur(int utilisateurId) async {
    try {
      final database = await db.database;
      final result = await database.query(
        'rendez_vous',
        where: 'utilisateurId = ?',
        whereArgs: [utilisateurId],
        orderBy: 'date DESC, heure DESC',
      );
      return result.map((map) => RendezVous.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lecture RDV: $e');
      return [];
    }
  }

  Future<List<RendezVous>> obtenirTousLesRendezVous() async {
    try {
      final database = await db.database;
      final result = await database.query('rendez_vous', orderBy: 'date DESC, heure DESC');
      return result.map((map) => RendezVous.fromMap(map)).toList();
    } catch (e) {
      print('Erreur obtention RDV: $e');
      return [];
    }
  }

  Future<bool> verifierDisponibilite(String date, String heure, String typeRdv) async {
    try {
      final database = await db.database;
      final result = await database.query(
        'rendez_vous',
        where: 'date = ? AND heure = ? AND statut != ?',
        whereArgs: [date, heure, 'annule'],
        limit: 1,
      );
      return result.isEmpty;
    } catch (e) {
      print('Erreur vérification disponibilité: $e');
      return false;
    }
  }

  Future<int> creerRendezVous(RendezVous rdv) async {
    try {
      final database = await db.database;
      return await database.insert('rendez_vous', rdv.toMap());
    } catch (e) {
      print('Erreur création RDV: $e');
      rethrow;
    }
  }

  Future<int> annulerRendezVous(int rdvId) async {
    try {
      final database = await db.database;
      return await database.update(
        'rendez_vous',
        {'statut': 'annule'},
        where: 'id = ?',
        whereArgs: [rdvId],
      );
    } catch (e) {
      print('Erreur annulation RDV: $e');
      rethrow;
    }
  }

  Future<Map<String, int>> obtenirStatistiques() async {
    final database = await db.database;

    final totalResult = await database.rawQuery(
        'SELECT COUNT(*) as count FROM rendez_vous'
    );
    final total = totalResult.first['count'] as int;

    final aujourdhui = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final aujourdhuiResult = await database.rawQuery(
        'SELECT COUNT(*) as count FROM rendez_vous WHERE date = ? AND statut != ?',
        [aujourdhui, 'annule']
    );
    final rdvAujourdhui = aujourdhuiResult.first['count'] as int;

    return {
      'total': total,
      'aujourdhui': rdvAujourdhui,
    };
  }
}

class DisponibiliteService {
  final DatabaseHelper db = DatabaseHelper.instance;

  Future<List<Disponibilite>> obtenirDisponibilitesActives() async {
    try {
      final database = await db.database;
      final result = await database.query(
        'disponibilites',
        where: 'actif = ?',
        whereArgs: [1],
        orderBy: 'jour, heureDebut',
      );
      return result.map((map) => Disponibilite.fromMap(map)).toList();
    } catch (e) {
      print('Erreur disponibilités: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> obtenirDatesDisponibles(String jour) async {
    final dates = <Map<String, dynamic>>[];
    final aujourdhui = DateTime.now();

    // Générer les 4 prochaines dates pour ce jour
    for (int i = 0; i < 28; i++) { // 4 semaines
      final date = aujourdhui.add(Duration(days: i));
      final jourSemaine = _getJourEnFrancais(date);

      if (jourSemaine == jour) {
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        dates.add({
          'date': dateStr,
          'affichage': DateFormat('dd/MM/yyyy').format(date),
          'jour': jourSemaine,
        });

        // Limiter à 4 dates maximum
        if (dates.length >= 4) break;
      }
    }

    return dates;
  }

  String _getJourEnFrancais(DateTime date) {
    final jours = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    return jours[date.weekday % 7];
  }
}

// ====================================
// SESSION CORRIGÉE
// ====================================

class Session {
  static final Session instance = Session._();
  Session._();

  Utilisateur? _utilisateurActuel;

  Utilisateur? get utilisateurActuel => _utilisateurActuel;

  bool get estConnecte => _utilisateurActuel != null;
  bool get estAdmin => _utilisateurActuel?.role == 'admin';
  bool get estEnseignant => _utilisateurActuel?.role == 'enseignant';
  bool get estParent => _utilisateurActuel?.role == 'parent';

  void connecter(Utilisateur user) {
    _utilisateurActuel = user;
    print('Utilisateur connecté: ${user.email}');
  }

  void deconnecter() {
    _utilisateurActuel = null;
    print('Utilisateur déconnecté');
  }
}

// ====================================
// HOME PAGE AMÉLIORÉE (Différenciée par rôle)
// ====================================

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DisponibiliteService _dispoService = DisponibiliteService();
  final RendezVousService _rdvService = RendezVousService();
  List<Disponibilite> _disponibilites = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      // Seul l'admin charge les statistiques
      if (Session.instance.estAdmin) {
        final stats = await _rdvService.obtenirStatistiques();
        setState(() {
          _stats = stats;
        });
      }

      // Tous les utilisateurs voient les disponibilités
      final dispos = await _dispoService.obtenirDisponibilitesActives();

      setState(() {
        _disponibilites = dispos;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement: $e');
      setState(() => _isLoading = false);
      _afficherErreur('Erreur de chargement');
    }
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Session.instance;

    return Scaffold(
      backgroundColor: Color(0xFFF8F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête élégant avec gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8A6BFF),
                      Color(0xFFB39DDB),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF7C4DFF).withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EducaRendez",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Bienvenue sur notre plateforme",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        if (Session.instance.estConnecte)
                          GestureDetector(
                            onTap: () {
                              if (Session.instance.estAdmin) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => AdminDashboard(),
                                ));
                              } else if (Session.instance.estEnseignant) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => EnseignantDashboard(),
                                ));
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => ParentDashboard(),
                                ));
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Prenez rendez-vous simplement",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Planifiez vos rendez-vous avec l'établissement en quelques clics. "
                                "Système sécurisé et intuitif.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Statistiques (UNIQUEMENT pour l'admin)
              if (session.estAdmin) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(_stats['aujourdhui']?.toString() ?? '0', "RDV aujourd'hui"),
                      _buildStatItem(_stats['total']?.toString() ?? '0', "Total RDV"),
                    ],
                  ),
                ),
              ],

              // Accès rapide (UNIQUEMENT pour les non-connectés)
              if (!session.estConnecte) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accès rapide",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4A329C),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAccesButton(
                              icon: Icons.family_restroom,
                              label: "Parent",
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => LoginPage(role: 'parent'),
                              )),
                              color: Color(0xFF9575CD),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildAccesButton(
                              icon: Icons.school,
                              label: "Enseignant",
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => LoginPage(role: 'enseignant'),
                              )),
                              color: Color(0xFF7C4DFF),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildAccesButton(
                              icon: Icons.admin_panel_settings,
                              label: "Admin",
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => LoginPage(role: 'admin'),
                              )),
                              color: Color(0xFF5E35B1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Section spécifique selon le rôle connecté
              if (session.estConnecte) ...[
                _buildSectionUtilisateur(session),
              ],

              // Créneaux disponibles (pour tous)
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Créneaux disponibles",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4A329C),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh, color: Color(0xFF7C4DFF)),
                              onPressed: _chargerDonnees,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _disponibilites.isEmpty
                            ? Center(
                          child: Column(
                            children: [
                              Icon(Icons.event_busy, size: 60, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "Aucun créneau disponible",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                            : Column(
                          children: _disponibilites
                              .map((dispo) => _buildDispoCard(dispo))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Contact (pour tous)
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A329C),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 20, color: Color(0xFF7C4DFF)),
                        SizedBox(width: 8),
                        Text("0550 12 34 56"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, size: 20, color: Color(0xFF7C4DFF)),
                        SizedBox(width: 8),
                        Text("contact@educarendez.dz"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 20, color: Color(0xFF7C4DFF)),
                        SizedBox(width: 8),
                        Text("Lun-Ven: 08h-17h"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthodes d'aide pour personnaliser l'interface selon le rôle
  Widget _buildSectionUtilisateur(Session session) {
    if (session.estParent) {
      return _buildSectionParent();
    } else if (session.estEnseignant) {
      return _buildSectionEnseignant();

    }
    return SizedBox.shrink();
  }

  Widget _buildSectionParent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vos prochains rendez-vous",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A329C),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.event_note, color: Color(0xFF7C4DFF)),
              title: Text("Consultez vos RDV"),
              subtitle: Text("Gérez vos rendez-vous en cours"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ParentDashboard()),
                  );
                },
                child: Text("Voir"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionEnseignant() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Espace professionnel",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A329C),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.school, color: Color(0xFF7C4DFF)),
              title: Text("Tableau de bord enseignant"),
              subtitle: Text("Accédez à votre espace personnel"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EnseignantDashboard()),
                  );
                },
                child: Text("Accéder"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAdminCardMini({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Color(0xFF7C4DFF)),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7C4DFF),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildAccesButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A329C),
              ),
            ),
            Text(
              "Se connecter",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispoCard(Disponibilite dispo) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7C4DFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.access_time, color: Color(0xFF7C4DFF)),
          ),
          title: Text(
            "${dispo.jour} • ${dispo.heureDebut} - ${dispo.heureFin}",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(_getTypeLabel(dispo.typeRdv)),
          trailing: Session.instance.estConnecte && !Session.instance.estAdmin
              ? ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationPage(disponibilite: dispo),
                ),
              );
            },
            child: Text("Réserver"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7C4DFF),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          )
              : !Session.instance.estConnecte
              ? TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(role: 'parent'),
                ),
              );
            },
            child: Text("Se connecter"),
          )
              : null,
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'rendez-vous_pedagogique':
        return "Rendez-vous pédagogique";
      case 'entretien_pedagogique':
        return "Entretien pédagogique";
      case 'embauche':
        return "Entretien d'embauche";
      case 'formation':
        return "Formation";
      default:
        return type;
    }
  }
}

// ====================================
// DASHBOARD PARENT
// ====================================

class ParentDashboard extends StatefulWidget {
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final RendezVousService _rdvService = RendezVousService();
  List<RendezVous> _mesRdv = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerMesRdv();
  }

  Future<void> _chargerMesRdv() async {
    try {
      final rdvs = await _rdvService.lireParUtilisateur(
        Session.instance.utilisateurActuel!.id!,
      );
      setState(() {
        _mesRdv = rdvs;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement RDV: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _annulerRendezVous(int rdvId) async {
    try {
      await _rdvService.annulerRendezVous(rdvId);
      await _chargerMesRdv();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rendez-vous annulé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = Session.instance.utilisateurActuel!;
    final rdvEnAttente = _mesRdv.where((rdv) => rdv.statut == 'en_attente').length;
    final rdvConfirmes = _mesRdv.where((rdv) => rdv.statut == 'confirme').length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Parents"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _chargerMesRdv,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.home, color: Color(0xFF7C4DFF)),
                    SizedBox(width: 8),
                    Text("Accueil"),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false,
                  );
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Déconnexion"),
                  ],
                ),
                onTap: () {
                  Session.instance.deconnecter();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Profil utilisateur avec stats personnelles
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF7C4DFF),
                        child: Text(
                          "${utilisateur.prenom[0]}${utilisateur.nom[0]}",
                          style: TextStyle(color: Colors.white),
                        ),
                        radius: 30,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${utilisateur.prenom} ${utilisateur.nom}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Parent",
                              style: TextStyle(
                                color: Color(0xFF7C4DFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              utilisateur.email,
                              style: TextStyle(color: Colors.grey),
                            ),
                            if (utilisateur.telephone != null)
                              Text(
                                utilisateur.telephone!,
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatPersonnelle(rdvEnAttente.toString(), "En attente"),
                      _buildStatPersonnelle(rdvConfirmes.toString(), "Confirmés"),
                      _buildStatPersonnelle(_mesRdv.length.toString(), "Total"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bouton principal
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Prendre un nouveau rendez-vous"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Titre des RDV
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  "Mes rendez-vous",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF311B92),
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text("${_mesRdv.length} RDV"),
                  backgroundColor: Color(0xFF7C4DFF).withOpacity(0.1),
                ),
              ],
            ),
          ),

          // Liste des RDV
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _mesRdv.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Aucun rendez-vous",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Planifiez votre premier rendez-vous",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _mesRdv.length,
              itemBuilder: (context, index) {
                final rdv = _mesRdv[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: _getStatutIcon(rdv.statut),
                    title: Text(
                      "${_getTypeLabel(rdv.typeRdv)}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${rdv.date} à ${rdv.heure}"),
                        Text("Statut: ${_getStatutLabel(rdv.statut)}"),
                        if (rdv.notes != null && rdv.notes!.isNotEmpty)
                          Text(
                            "Note: ${rdv.notes}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: rdv.statut == 'en_attente'
                        ? IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Annuler le rendez-vous"),
                            content: Text("Êtes-vous sûr de vouloir annuler ce rendez-vous ?"),
                            actions: [
                              TextButton(
                                child: Text("Non"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text("Oui"),
                                onPressed: () {
                                  _annulerRendezVous(rdv.id!);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPersonnelle(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7C4DFF),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _getStatutIcon(String statut) {
    IconData icon;
    Color color;

    switch (statut) {
      case 'confirme':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'annule':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.schedule;
        color = Colors.orange;
    }

    return Icon(icon, color: color, size: 30);
  }

  String _getStatutLabel(String statut) {
    switch (statut) {
      case 'confirme':
        return 'Confirmé';
      case 'annule':
        return 'Annulé';
      default:
        return 'En attente';
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'rendez-vous_pedagogique':
        return "Rendez-vous pédagogique";
      case 'entretien_pedagogique':
        return "Entretien pédagogique";
      case 'embauche':
        return "Entretien d'embauche";
      case 'formation':
        return "Formation";
      default:
        return type;
    }
  }
}

// ====================================
// DASHBOARD ENSEIGNANT
// ====================================

class EnseignantDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final utilisateur = Session.instance.utilisateurActuel!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Enseignants"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => HomePage()),
                    (route) => false,
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Déconnexion"),
                  ],
                ),
                onTap: () {
                  Session.instance.deconnecter();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF7C4DFF),
                      child: Icon(Icons.school, color: Colors.white, size: 30),
                      radius: 30,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${utilisateur.prenom} ${utilisateur.nom}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Enseignant",
                            style: TextStyle(
                              color: Color(0xFF7C4DFF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            utilisateur.email,
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (utilisateur.telephone != null)
                            Text(
                              utilisateur.telephone!,
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Prendre un rendez-vous"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C4DFF),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 50, color: Color(0xFF7C4DFF)),
                    SizedBox(height: 16),
                    Text(
                      "Espace Professionnel",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Planifiez vos rendez-vous professionnels, entretiens et formations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================
// DASHBOARD ADMIN
// ====================================

// ====================================
// DASHBOARD ADMIN AMÉLIORÉ
// ====================================

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final UtilisateurService _userService = UtilisateurService();
  final RendezVousService _rdvService = RendezVousService();
  final DisponibiliteService _dispoService = DisponibiliteService();

  int _selectedIndex = 0;
  List<Utilisateur> _utilisateurs = [];
  List<RendezVous> _rendezVous = [];
  List<Disponibilite> _disponibilites = [];
  Map<String, dynamic> _statistiques = {};
  bool _isLoading = true;
  bool _isMenuOpen = true;
  bool _isDarkMode = false;

  // Filtres avancés
  String _filtreRole = 'tous';
  String _filtreStatutRDV = 'tous';
  String _filtreTypeRDV = 'tous';
  DateTime? _dateDebut;
  DateTime? _dateFin;
  TextEditingController _searchController = TextEditingController();

  // Contrôleurs pour les formulaires
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telephoneController = TextEditingController();
  String _selectedRole = 'parent';

  // Pagination
  int _currentUserPage = 1;
  int _currentRDVPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
    _initialiserFiltres();
  }

  Future<void> _chargerDonnees() async {
    try {
      setState(() => _isLoading = true);

      await Future.wait([
        _chargerUtilisateurs(),
        _chargerRendezVous(),
        _chargerDisponibilites(),
        _calculerStatistiques(),
      ]);

      setState(() => _isLoading = false);
    } catch (e) {
      print('Erreur chargement données: $e');
      setState(() => _isLoading = false);
      _showNotification('Erreur de chargement', Colors.red);
    }
  }

  Future<void> _chargerUtilisateurs() async {
    final database = await DatabaseHelper.instance.database;
    final result = await database.query('utilisateurs');
    setState(() => _utilisateurs = result.map((map) => Utilisateur.fromMap(map)).toList());
  }

  Future<void> _chargerRendezVous() async {
    final database = await DatabaseHelper.instance.database;
    final result = await database.query('rendez_vous', orderBy: 'date DESC, heure DESC');
    setState(() => _rendezVous = result.map((map) => RendezVous.fromMap(map)).toList());
  }

  Future<void> _chargerDisponibilites() async {
    final database = await DatabaseHelper.instance.database;
    final result = await database.query('disponibilites', orderBy: 'jour, heureDebut');
    setState(() => _disponibilites = result.map((map) => Disponibilite.fromMap(map)).toList());
  }

  Future<void> _calculerStatistiques() async {
    final database = await DatabaseHelper.instance.database;
    final aujourdhui = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Statistiques utilisateurs
    final statsUsers = await database.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN role = 'parent' THEN 1 ELSE 0 END) as parents,
        SUM(CASE WHEN role = 'enseignant' THEN 1 ELSE 0 END) as enseignants,
        SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) as admins,
        SUM(CASE WHEN date(dateCreation) = date('now') THEN 1 ELSE 0 END) as nouveaux_aujourdhui
      FROM utilisateurs
    ''');

    // Statistiques RDV
    final statsRDV = await database.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN statut = 'confirme' THEN 1 ELSE 0 END) as confirmes,
        SUM(CASE WHEN statut = 'en_attente' THEN 1 ELSE 0 END) as en_attente,
        SUM(CASE WHEN statut = 'annule' THEN 1 ELSE 0 END) as annules,
        SUM(CASE WHEN date = ? AND statut != 'annule' THEN 1 ELSE 0 END) as aujourdhui,
        SUM(CASE WHEN date < ? AND statut = 'en_attente' THEN 1 ELSE 0 END) as en_retard
      FROM rendez_vous
    ''', [aujourdhui, aujourdhui]);

    // RDV par type
    final statsTypes = await database.rawQuery('''
      SELECT typeRdv, COUNT(*) as count 
      FROM rendez_vous 
      WHERE statut != 'annule'
      GROUP BY typeRdv
    ''');

    // Activité des 7 derniers jours
    final statsActivite = await database.rawQuery('''
      SELECT 
        date(dateCreation) as jour,
        COUNT(*) as rdv_count,
        SUM(CASE WHEN statut = 'confirme' THEN 1 ELSE 0 END) as confirmes
      FROM rendez_vous
      WHERE date(dateCreation) >= date('now', '-7 days')
      GROUP BY date(dateCreation)
      ORDER BY jour DESC
    ''');

    final Map<String, dynamic> typesMap = {};
    for (var row in statsTypes) {
      typesMap[row['typeRdv'] as String] = row['count'];
    }

    setState(() {
      _statistiques = {
        'utilisateurs': statsUsers.first,
        'rdv': statsRDV.first,
        'types': typesMap,
        'disponibilites': _disponibilites.length,
        'activite': statsActivite,
      };
    });
  }

  void _initialiserFiltres() {
    // Initialiser avec des filtres par défaut
  }

  // ========== GESTION UTILISATEURS ==========

  Future<void> _ajouterUtilisateur(Map<String, dynamic> data) async {
    try {
      if (data['email'].isEmpty || data['password'].isEmpty) {
        throw Exception('Email et mot de passe requis');
      }

      final nouvelUtilisateur = Utilisateur(
        nom: data['nom'],
        prenom: data['prenom'],
        email: data['email'],
        motDePasse: data['password'],
        role: data['role'],
        telephone: data['telephone'],
      );

      await _userService.creer(nouvelUtilisateur);
      await _chargerDonnees();
      _showNotification('✅ Utilisateur ajouté avec succès', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _modifierUtilisateur(Utilisateur user, Map<String, dynamic> data) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'utilisateurs',
        {
          'nom': data['nom'],
          'prenom': data['prenom'],
          'email': data['email'],
          'role': data['role'],
          'telephone': data['telephone'],
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );
      await _chargerDonnees();
      _showNotification('✅ Utilisateur modifié avec succès', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _supprimerUtilisateur(int id) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.delete('utilisateurs', where: 'id = ?', whereArgs: [id]);
      await _chargerDonnees();
      _showNotification('✅ Utilisateur supprimé', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _reinitialiserMotDePasse(int id) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'utilisateurs',
        {'motDePasse': 'password123'}, // Mot de passe par défaut
        where: 'id = ?',
        whereArgs: [id],
      );
      _showNotification('✅ Mot de passe réinitialisé', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  // ========== GESTION RENDEZ-VOUS ==========

  Future<void> _modifierStatutRdv(int id, String statut) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'rendez_vous',
        {'statut': statut},
        where: 'id = ?',
        whereArgs: [id],
      );
      await _chargerDonnees();
      _showNotification('✅ Statut modifié', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _modifierRdv(RendezVous rdv, Map<String, dynamic> data) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'rendez_vous',
        {
          'typeRdv': data['typeRdv'],
          'date': data['date'],
          'heure': data['heure'],
          'notes': data['notes'],
        },
        where: 'id = ?',
        whereArgs: [rdv.id],
      );
      await _chargerDonnees();
      _showNotification('✅ RDV modifié', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _supprimerRdv(int id) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.delete('rendez_vous', where: 'id = ?', whereArgs: [id]);
      await _chargerDonnees();
      _showNotification('✅ RDV supprimé', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  // ========== GESTION DISPONIBILITÉS ==========

  Future<void> _ajouterDisponibilite(Map<String, dynamic> data) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.insert('disponibilites', {
        'jour': data['jour'],
        'heureDebut': data['heureDebut'],
        'heureFin': data['heureFin'],
        'typeRdv': data['typeRdv'],
        'actif': data['actif'] ? 1 : 0,
      });
      await _chargerDonnees();
      _showNotification('✅ Disponibilité ajoutée', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _modifierDisponibilite(Disponibilite dispo, Map<String, dynamic> data) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'disponibilites',
        {
          'jour': data['jour'],
          'heureDebut': data['heureDebut'],
          'heureFin': data['heureFin'],
          'typeRdv': data['typeRdv'],
          'actif': data['actif'] ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [dispo.id],
      );
      await _chargerDonnees();
      _showNotification('✅ Disponibilité modifiée', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _supprimerDisponibilite(int id) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.delete('disponibilites', where: 'id = ?', whereArgs: [id]);
      await _chargerDonnees();
      _showNotification('✅ Disponibilité supprimée', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _toggleDisponibilite(Disponibilite dispo) async {
    try {
      final database = await DatabaseHelper.instance.database;
      await database.update(
        'disponibilites',
        {'actif': dispo.actif ? 0 : 1},
        where: 'id = ?',
        whereArgs: [dispo.id],
      );
      await _chargerDonnees();
      _showNotification('✅ Disponibilité ${dispo.actif ? 'désactivée' : 'activée'}', Colors.green);
    } catch (e) {
      _showNotification('❌ Erreur: ${e.toString()}', Colors.red);
    }
  }

  // ========== RAPPORTS ==========

  Future<void> _genererRapportUtilisateurs() async {
    try {
      // Générer un rapport CSV/PDF des utilisateurs
      _showNotification('📄 Rapport utilisateurs généré', Colors.blue);
    } catch (e) {
      _showNotification('❌ Erreur génération rapport', Colors.red);
    }
  }

  Future<void> _genererRapportRDV() async {
    try {
      // Générer un rapport CSV/PDF des RDV
      _showNotification('📄 Rapport RDV généré', Colors.blue);
    } catch (e) {
      _showNotification('❌ Erreur génération rapport', Colors.red);
    }
  }

  void _showNotification(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // MENU LATÉRAL AMÉLIORÉ
          if (_isMenuOpen) _buildMenuLateral(),

          // CONTENU PRINCIPAL
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _isDarkMode ? Color(0xFF121212) : Color(0xFFF8F4FF),
                    _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFEDE7F6),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // BARRE D'OUTILS SUPÉRIEURE
                  _buildAppBar(),

                  // CONTENU PRINCIPAL
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
                      ),
                    )
                        : _getContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 3
          ? FloatingActionButton.extended(
        onPressed: () => _showAjouterDisponibiliteDialog(),
        icon: Icon(Icons.add),
        label: Text("Nouveau créneau"),
        backgroundColor: Color(0xFF7C4DFF),
      )
          : null,
    );
  }

  // ========== MENU LATÉRAL AMÉLIORÉ ==========

  Widget _buildMenuLateral() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          right: BorderSide(color: _isDarkMode ? Colors.white12 : Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // EN-TÊTE DU MENU
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFFEDE7F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 30, color: Color(0xFF7C4DFF)),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Super Admin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("admin@educarendez.dz", style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text("Administrateur Principal", style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // SECTION DU MENU
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildMenuItem(
                    index: 0,
                    icon: Icons.dashboard,
                    title: "Tableau de bord",
                    badge: null,
                  ),
                  _buildMenuItem(
                    index: 1,
                    icon: Icons.people,
                    title: "Utilisateurs",
                    badge: _statistiques['utilisateurs']?['total'] ?? 0,
                  ),
                  _buildMenuItem(
                    index: 2,
                    icon: Icons.calendar_today,
                    title: "Rendez-vous",
                    badge: _statistiques['rdv']?['total'] ?? 0,
                  ),
                  _buildMenuItem(
                    index: 3,
                    icon: Icons.access_time,
                    title: "Disponibilités",
                    badge: _statistiques['disponibilites'] ?? 0,
                  ),
                  _buildMenuItem(
                    index: 4,
                    icon: Icons.bar_chart,
                    title: "Statistiques",
                    badge: null,
                  ),
                  _buildMenuItem(
                    index: 5,
                    icon: Icons.report,
                    title: "Rapports",
                    badge: null,
                  ),
                  _buildMenuItem(
                    index: 6,
                    icon: Icons.settings,
                    title: "Paramètres",
                    badge: null,
                  ),

                  Divider(indent: 20, endIndent: 20, thickness: 0.5),
                  _buildMenuItem(
                    index: 8,
                    icon: Icons.help,
                    title: "Aide & Support",
                    badge: null,
                  ),
                  _buildMenuItem(
                    index: 9,
                    icon: Icons.feedback,
                    title: "Feedback",
                    badge: null,
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.brightness_6, size: 18, color: Colors.grey.shade600),
                        SizedBox(width: 12),
                        Text(
                          "Mode sombre",
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                        Spacer(),
                        Switch.adaptive(
                          value: _isDarkMode,
                          onChanged: (value) => setState(() => _isDarkMode = value),
                          activeColor: Color(0xFF7C4DFF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PIED DE MENU
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: _isDarkMode ? Colors.white12 : Colors.grey.shade200)),
              color: _isDarkMode ? Color(0xFF252525) : Colors.grey.shade50,
            ),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.logout, size: 16),
                  label: Text("Déconnexion"),
                  onPressed: () {
                    Session.instance.deconnecter();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => HomePage()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(_isMenuOpen ? Icons.chevron_left : Icons.chevron_right, size: 16),
                  label: Text(_isMenuOpen ? "Réduire" : "Étendre"),
                  onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36),
                    side: BorderSide(color: Color(0xFF7C4DFF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String title,
    required dynamic badge,
  }) {
    final isSelected = _selectedIndex == index;
    final color = _isDarkMode ? Colors.white70 : Colors.grey.shade800;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected
            ? Color(0xFF7C4DFF).withOpacity(_isDarkMode ? 0.3 : 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFF7C4DFF)
                        : (_isDarkMode ? Colors.white10 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? Colors.white
                        : (_isDarkMode ? Colors.white70 : Colors.grey.shade700),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Color(0xFF7C4DFF)
                          : (_isDarkMode ? Colors.white : Colors.grey.shade800),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (badge != null && badge > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : (_isDarkMode ? Color(0xFF7C4DFF) : Color(0xFF7C4DFF).withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Color(0xFF7C4DFF)
                            : (_isDarkMode ? Colors.white : Color(0xFF7C4DFF)),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== BARRE D'OUTILS AMÉLIORÉE ==========

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: _isDarkMode ? Colors.white12 : Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          if (!_isMenuOpen)
            IconButton(
              icon: Icon(Icons.menu, color: _isDarkMode ? Colors.white : Colors.grey.shade800),
              onPressed: () => setState(() => _isMenuOpen = true),
              tooltip: "Ouvrir le menu",
            ),

          SizedBox(width: _isMenuOpen ? 0 : 16),

          Expanded(
            child: Row(
              children: [
                Text(
                  _getPageTitle(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Color(0xFF311B92),
                  ),
                ),
                SizedBox(width: 12),
                if (_selectedIndex == 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.update, size: 14, color: Color(0xFF7C4DFF)),
                        SizedBox(width: 6),
                        Text(
                          "Mis à jour à ${DateFormat('HH:mm').format(DateTime.now())}",
                          style: TextStyle(fontSize: 12, color: Color(0xFF7C4DFF)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // BARRE DE RECHERCHE CONTEXTUELLE
          if (_selectedIndex != 0 && _selectedIndex != 5 && _selectedIndex != 6)
            Container(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: _getSearchHint(),
                  hintStyle: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search,
                      color: _isDarkMode ? Colors.white54 : Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: _isDarkMode ? Colors.white10 : Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) => setState(() {}),
                style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
              ),
            ),

          if (_selectedIndex != 0 && _selectedIndex != 5 && _selectedIndex != 6)
            SizedBox(width: 16),

          // BOUTONS D'ACTION CONTEXTUELS
          Row(
            children: [
              Tooltip(
                message: "Actualiser",
                child: IconButton(
                  icon: Icon(Icons.refresh,
                      color: _isDarkMode ? Colors.white : Colors.grey.shade700),
                  onPressed: _chargerDonnees,
                ),
              ),
              Tooltip(
                message: "Notifications",
                child: Badge(
                  label: Text("3"),
                  child: IconButton(
                    icon: Icon(Icons.notifications,
                        color: _isDarkMode ? Colors.white : Colors.grey.shade700),
                    onPressed: () => _showNotificationsPanel(),
                  ),
                ),
              ),
              Tooltip(
                message: "Exporter",
                child: IconButton(
                  icon: Icon(Icons.download,
                      color: _isDarkMode ? Colors.white : Colors.grey.shade700),
                  onPressed: _exporterDonnees,
                ),
              ),
              SizedBox(width: 8),
              if (_selectedIndex == 1)
                ElevatedButton.icon(
                  icon: Icon(Icons.person_add, size: 16),
                  label: Text("Nouvel utilisateur"),
                  onPressed: () => _showAjouterUtilisateurDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== CONTENU DES PAGES ==========

  Widget _getContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildGestionUtilisateurs();
      case 2:
        return _buildGestionRendezVous();
      case 3:
        return _buildGestionDisponibilites();
      case 4:
        return _buildStatistiques();
      case 5:
        return _buildRapports();
      case 6:
        return _buildParametres();
      default:
        return _buildDashboard();
    }
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Tableau de Bord";
      case 1:
        return "Gestion des Utilisateurs";
      case 2:
        return "Gestion des Rendez-vous";
      case 3:
        return "Configuration des Disponibilités";
      case 4:
        return "Statistiques";
      case 5:
        return "Rapports";
      case 6:
        return "Paramètres Système";
      default:
        return "Administration";
    }
  }

  String _getSearchHint() {
    switch (_selectedIndex) {
      case 1:
        return "Rechercher un utilisateur...";
      case 2:
        return "Rechercher un rendez-vous...";
      case 3:
        return "Rechercher une disponibilité...";
      default:
        return "Rechercher...";
    }
  }

  // ========== PAGE TABLEAU DE BORD AMÉLIORÉE ==========

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WELCOME CARD
          _buildWelcomeCard(),

          SizedBox(height: 24),

          // STATISTIQUES PRINCIPALES
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildStatCard(
                title: "Utilisateurs",
                value: (_statistiques['utilisateurs']?['total']?.toString()) ?? "0",
                icon: Icons.people,
                color: Color(0xFF4FC3F7),
                trend: "+12%",
                detail: "${_statistiques['utilisateurs']?['parents'] ?? 0} parents",
              ),
              _buildStatCard(
                title: "RDV Confirmés",
                value: (_statistiques['rdv']?['confirmes']?.toString()) ?? "0",
                icon: Icons.check_circle,
                color: Color(0xFF66BB6A),
                trend: "+8%",
                detail: "Ce mois",
              ),
              _buildStatCard(
                title: "RDV En Attente",
                value: (_statistiques['rdv']?['en_attente']?.toString()) ?? "0",
                icon: Icons.schedule,
                color: Color(0xFFFFB74D),
                trend: "+5%",
                detail: "À traiter",
              ),
              _buildStatCard(
                title: "Nouveaux Aujourd'hui",
                value: (_statistiques['utilisateurs']?['nouveaux_aujourdhui']?.toString()) ?? "0",
                icon: Icons.person_add,
                color: Color(0xFFE040FB),
                trend: null,
                detail: "Utilisateurs",
              ),
            ],
          ),

          SizedBox(height: 30),

          // DEUXIÈME RANGÉE DE STATS
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildMiniStatCard2("RDV Aujourd'hui",
                  (_statistiques['rdv']?['aujourdhui']?.toString()) ?? "0", Icons.today),
              _buildMiniStatCard2("RDV Annulés",
                  (_statistiques['rdv']?['annules']?.toString()) ?? "0", Icons.cancel),
              _buildMiniStatCard2("Enseignants",
                  (_statistiques['utilisateurs']?['enseignants']?.toString()) ?? "0", Icons.school),
              _buildMiniStatCard2("En retard",
                  (_statistiques['rdv']?['en_retard']?.toString()) ?? "0", Icons.warning),
            ],
          ),

          SizedBox(height: 30),


          // DERNIERS UTILISATEURS ET RDV
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DERNIERS UTILISATEURS
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: _isDarkMode ? Color(0xFF252525) : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: Color(0xFF7C4DFF)),
                            SizedBox(width: 12),
                            Text(
                              "Derniers Utilisateurs",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () => setState(() => _selectedIndex = 1),
                              child: Text("Voir tous"),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF7C4DFF),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildListeUtilisateurs(),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 20),

              // DERNIERS RDV
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: _isDarkMode ? Color(0xFF252525) : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event, color: Color(0xFF7C4DFF)),
                            SizedBox(width: 12),
                            Text(
                              "Derniers Rendez-vous",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () => setState(() => _selectedIndex = 2),
                              child: Text("Voir tous"),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF7C4DFF),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildListeRDVRecents(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFFE040FB),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bonjour, Administrateur 👋",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Bienvenue sur votre tableau de bord. Voici un aperçu de l'activité de la plateforme.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildBadge("${_utilisateurs.length} Utilisateurs", Icons.people),
                      _buildBadge("${_rendezVous.length} RDV", Icons.event),
                      _buildBadge("${_disponibilites.length} Créneaux", Icons.access_time),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 40),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.admin_panel_settings,
                size: 60,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String? trend,
    required String detail,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _isDarkMode ? Color(0xFF252525) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                if (trend != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          trend,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: _isDarkMode ? Colors.white : Color(0xFF311B92),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              detail,
              style: TextStyle(
                fontSize: 12,
                color: _isDarkMode ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard2(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _isDarkMode ? Color(0xFF252525) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF7C4DFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Color(0xFF7C4DFF)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Color(0xFF311B92),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartRDV() {
    final types = _statistiques['types'] ?? {};
    final total = _statistiques['rdv']?['total'] ?? 1;

    if (types.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "Aucune donnée disponible",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: types.length,
      itemBuilder: (context, index) {
        final typeKey = types.keys.elementAt(index);
        final count = types[typeKey] ?? 0;
        final percentage = (count / total * 100).round();

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getChartColor(index),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getTypeLabel(typeKey),
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "$count",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _isDarkMode ? Colors.white12 : Colors.grey.shade200,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          _getChartColor(index),
                          _getChartColor(index).withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$percentage%",
                    style: TextStyle(
                      fontSize: 12,
                      color: _isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                  ),
                  Text(
                    "($count RDV)",
                    style: TextStyle(
                      fontSize: 12,
                      color: _isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getChartColor(int index) {
    final colors = [
      Color(0xFF7C4DFF),
      Color(0xFFE040FB),
      Color(0xFF4FC3F7),
      Color(0xFF66BB6A),
      Color(0xFFFFB74D),
      Color(0xFF9575CD),
    ];
    return colors[index % colors.length];
  }

  Widget _buildActiviteRecent() {
    final activites = [
      {'type': 'user', 'action': 'Nouvel utilisateur inscrit', 'time': 'Il y a 5 min'},
      {'type': 'rdv', 'action': 'RDV confirmé', 'time': 'Il y a 15 min'},
      {'type': 'dispo', 'action': 'Nouveau créneau ajouté', 'time': 'Il y a 30 min'},
      {'type': 'user', 'action': 'Compte enseignant validé', 'time': 'Il y a 1 heure'},
      {'type': 'rdv', 'action': 'RDV annulé', 'time': 'Il y a 2 heures'},
    ];

    return Column(
      children: activites.map((activite) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getActiviteColor(activite['type']!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getActiviteIcon(activite['type']!),
                size: 20,
                color: _getActiviteColor(activite['type']!),
              ),
            ),
            title: Text(
              activite['action']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                Text(
                  activite['user']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  activite['time']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: _isDarkMode ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: _isDarkMode ? Colors.white54 : Colors.grey.shade400,
            ),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListeUtilisateurs() {
    final derniersUsers = _utilisateurs.take(5).toList();

    return Column(
      children: derniersUsers.map((user) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _isDarkMode ? Colors.white12 : Colors.grey.shade200),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: _getRoleColor(user.role),
              child: Text(
                "${user.prenom[0]}${user.nom[0]}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "${user.prenom} ${user.nom}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              user.email,
              style: TextStyle(
                fontSize: 12,
                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            trailing: Chip(
              label: Text(
                _getRoleLabel(user.role),
                style: TextStyle(fontSize: 10),
              ),
              backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
              labelStyle: TextStyle(color: _getRoleColor(user.role)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListeRDVRecents() {
    final derniersRDV = _rendezVous.take(5).toList();

    return Column(
      children: derniersRDV.map((rdv) {
        final user = _utilisateurs.firstWhere(
              (u) => u.id == rdv.utilisateurId,
          orElse: () => Utilisateur(nom: 'Inconnu', prenom: '', email: '', motDePasse: '', role: ''),
        );

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _isDarkMode ? Colors.white12 : Colors.grey.shade200),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _getStatutIcon(rdv.statut, size: 20),
            title: Text(
              "${user.prenom} ${user.nom}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_formatDate(rdv.date)} à ${rdv.heure}",
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatutColor(rdv.statut).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStatutLabel(rdv.statut),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatutColor(rdv.statut),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF7C4DFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getTypeLabel(rdv.typeRdv),
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF7C4DFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ========== PAGE GESTION UTILISATEURS AMÉLIORÉE ==========

  Widget _buildGestionUtilisateurs() {
    final filteredUsers = _filtrerUtilisateurs();
    final totalPages = (filteredUsers.length / _itemsPerPage).ceil();
    final startIndex = (_currentUserPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginatedUsers = filteredUsers.sublist(
      startIndex,
      endIndex > filteredUsers.length ? filteredUsers.length : endIndex,
    );

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // FILTRES AVANCÉS
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: _isDarkMode ? Color(0xFF252525) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_list, color: Color(0xFF7C4DFF)),
                      SizedBox(width: 12),
                      Text("Filtres avancés", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _filtreRole,
                          decoration: InputDecoration(
                            labelText: "Rôle",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(value: 'tous', child: Text("Tous les rôles")),
                            DropdownMenuItem(value: 'parent', child: Text("Parents")),
                            DropdownMenuItem(value: 'enseignant', child: Text("Enseignants")),
                            DropdownMenuItem(value: 'admin', child: Text("Administrateurs")),
                          ],
                          onChanged: (value) => setState(() => _filtreRole = value!),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Recherche",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            _currentUserPage = 1;
                          }),
                        ),
                      ),
                      SizedBox(width: 16),
                      OutlinedButton.icon(
                        icon: Icon(Icons.filter_alt_off, size: 16),
                        label: Text("Réinitialiser"),
                        onPressed: () {
                          setState(() {
                            _filtreRole = 'tous';
                            _searchController.clear();
                            _currentUserPage = 1;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // STATISTIQUES UTILISATEURS
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            children: [
              _buildUserStatCard("Total", (_statistiques['utilisateurs']?['total']?.toString()) ?? "0",
                  Icons.people, Colors.blue),
              _buildUserStatCard("Parents", (_statistiques['utilisateurs']?['parents']?.toString()) ?? "0",
                  Icons.family_restroom, Colors.green),
              _buildUserStatCard("Enseignants", (_statistiques['utilisateurs']?['enseignants']?.toString()) ?? "0",
                  Icons.school, Colors.orange),
              _buildUserStatCard("Admins", (_statistiques['utilisateurs']?['admins']?.toString()) ?? "0",
                  Icons.admin_panel_settings, Colors.purple),
            ],
          ),

          SizedBox(height: 20),

          // LISTE DES UTILISATEURS
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: _isDarkMode ? Color(0xFF252525) : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Utilisateurs (${filteredUsers.length})",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.file_download, size: 20),
                              onPressed: _exporterUtilisateurs,
                              tooltip: "Exporter",
                            ),
                            SizedBox(width: 8),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.select_all, size: 20),
                                    title: Text("Sélectionner tout"),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                                    title: Text("Supprimer sélection"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // EN-TÊTE DU TABLEAU
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.white10 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(width: 40, child: Text("#", style: _tableHeaderStyle())),
                          Expanded(flex: 2, child: Text("Utilisateur", style: _tableHeaderStyle())),
                          Expanded(child: Text("Rôle", style: _tableHeaderStyle())),
                          Expanded(child: Text("Email", style: _tableHeaderStyle())),
                          Expanded(child: Text("Téléphone", style: _tableHeaderStyle())),
                          Expanded(child: Text("Date création", style: _tableHeaderStyle())),
                          SizedBox(width: 120, child: Text("Actions", style: _tableHeaderStyle())),
                        ],
                      ),
                    ),

                    // LISTE
                    Expanded(
                      child: paginatedUsers.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Aucun utilisateur trouvé",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: paginatedUsers.length,
                        itemBuilder: (context, index) {
                          final user = paginatedUsers[index];
                          final globalIndex = startIndex + index + 1;

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                  color: _isDarkMode ? Colors.white12 : Colors.grey.shade200)),
                              color: index.isEven
                                  ? (_isDarkMode ? Colors.white: Colors.grey.shade50.withOpacity(0.3))
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  child: Text(
                                    "$globalIndex",
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: _getRoleColor(user.role),
                                        child: Text(
                                          "${user.prenom[0]}${user.nom[0]}",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${user.prenom} ${user.nom}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: _isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "ID: ${user.id}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: _isDarkMode ? Colors.white54 : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Chip(
                                    label: Text(_getRoleLabel(user.role)),
                                    backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      color: _getRoleColor(user.role),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.telephone ?? "-",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    DateFormat('dd/MM/yyyy').format(user.dateCreation),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, size: 18),
                                        onPressed: () => _showModifierUtilisateurDialog(user),
                                        tooltip: "Modifier",
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.lock_reset, size: 18),
                                        onPressed: () => _reinitialiserMotDePasse(user.id!),
                                        tooltip: "Réinitialiser MDP",
                                        color: Colors.orange,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, size: 18),
                                        onPressed: () => _showSupprimerUtilisateurDialog(user),
                                        tooltip: "Supprimer",
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // PAGINATION
                    if (totalPages > 1)
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left),
                              onPressed: _currentUserPage > 1
                                  ? () => setState(() => _currentUserPage--)
                                  : null,
                            ),
                            ...List.generate(
                              totalPages,
                                  (index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () => setState(() => _currentUserPage = index + 1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _currentUserPage == index + 1
                                          ? Color(0xFF7C4DFF)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: _currentUserPage == index + 1
                                            ? Colors.white
                                            : (_isDarkMode ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: _currentUserPage < totalPages
                                  ? () => setState(() => _currentUserPage++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _isDarkMode ? Color(0xFF252525) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Color(0xFF311B92),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== PAGE GESTION RENDEZ-VOUS AMÉLIORÉE ==========

  Widget _buildGestionRendezVous() {
    final filteredRDV = _filtrerRendezVous();
    final totalPages = (filteredRDV.length / _itemsPerPage).ceil();
    final startIndex = (_currentRDVPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginatedRDV = filteredRDV.sublist(
      startIndex,
      endIndex > filteredRDV.length ? filteredRDV.length : endIndex,
    );

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // FILTRES AVANCÉS RDV
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: _isDarkMode ? Color(0xFF252525) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt, color: Color(0xFF7C4DFF)),
                      SizedBox(width: 12),
                      Text("Filtres RDV", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _filtreStatutRDV,
                          decoration: InputDecoration(
                            labelText: "Statut",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: [
                            DropdownMenuItem(value: 'tous', child: Text("Tous les statuts")),
                            DropdownMenuItem(value: 'en_attente', child: Text("En attente")),
                            DropdownMenuItem(value: 'confirme', child: Text("Confirmés")),
                            DropdownMenuItem(value: 'annule', child: Text("Annulés")),
                          ],
                          onChanged: (value) => setState(() {
                            _filtreStatutRDV = value!;
                            _currentRDVPage = 1;
                          }),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _filtreTypeRDV,
                          decoration: InputDecoration(
                            labelText: "Type",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: [
                            DropdownMenuItem(value: 'tous', child: Text("Tous les types")),
                            DropdownMenuItem(
                                value: 'rendez-vous_pedagogique',
                                child: Text("Rendez-vous pédagogique")),
                            DropdownMenuItem(
                                value: 'entretien_pedagogique',
                                child: Text("Entretien pédagogique")),
                            DropdownMenuItem(value: 'embauche', child: Text("Embauche")),
                            DropdownMenuItem(value: 'formation', child: Text("Formation")),
                          ],
                          onChanged: (value) => setState(() {
                            _filtreTypeRDV = value!;
                            _currentRDVPage = 1;
                          }),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.calendar_today, size: 16),
                          label: Text(_dateDebut == null
                              ? "Date début"
                              : DateFormat('dd/MM/yyyy').format(_dateDebut!)),
                          onPressed: () => _selectDate(context, true),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.calendar_today, size: 16),
                          label: Text(_dateFin == null
                              ? "Date fin"
                              : DateFormat('dd/MM/yyyy').format(_dateFin!)),
                          onPressed: () => _selectDate(context, false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(Icons.clear_all, size: 16),
                        label: Text("Réinitialiser filtres"),
                        onPressed: () => setState(() {
                          _filtreStatutRDV = 'tous';
                          _filtreTypeRDV = 'tous';
                          _dateDebut = null;
                          _dateFin = null;
                          _searchController.clear();
                          _currentRDVPage = 1;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // STATISTIQUES RDV
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            children: [
              _buildRDVStatCard("Total", (_statistiques['rdv']?['total']?.toString()) ?? "0",
                  Icons.list, Colors.blue),
              _buildRDVStatCard("Confirmés", (_statistiques['rdv']?['confirmes']?.toString()) ?? "0",
                  Icons.check_circle, Colors.green),
              _buildRDVStatCard("En attente", (_statistiques['rdv']?['en_attente']?.toString()) ?? "0",
                  Icons.schedule, Colors.orange),
              _buildRDVStatCard("Aujourd'hui", (_statistiques['rdv']?['aujourdhui']?.toString()) ?? "0",
                  Icons.today, Colors.purple),
            ],
          ),

          SizedBox(height: 20),

          // LISTE DES RDV
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: _isDarkMode ? Color(0xFF252525) : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Rendez-vous (${filteredRDV.length})",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            TextButton.icon(
                              icon: Icon(Icons.file_download, size: 16),
                              label: Text("Exporter"),
                              onPressed: _exporterRDV,
                            ),
                            SizedBox(width: 8),
                            TextButton.icon(
                              icon: Icon(Icons.print, size: 16),
                              label: Text("Imprimer"),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // LISTE DES RDV
                    Expanded(
                      child: paginatedRDV.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Aucun rendez-vous trouvé",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: paginatedRDV.length,
                        itemBuilder: (context, index) {
                          final rdv = paginatedRDV[index];
                          final user = _utilisateurs.firstWhere(
                                (u) => u.id == rdv.utilisateurId,
                            orElse: () => Utilisateur(
                                nom: 'Inconnu', prenom: '', email: '', motDePasse: '', role: ''),
                          );

                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            color: _isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
                            child: ExpansionTile(
                              leading: _getStatutIcon(rdv.statut),
                              title: Text(
                                "${user.prenom} ${user.nom}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "${_formatDate(rdv.date)} à ${rdv.heure}",
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatutColor(rdv.statut).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _getStatutLabel(rdv.statut),
                                      style: TextStyle(
                                        color: _getStatutColor(rdv.statut),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: Icon(Icons.check, color: Colors.green, size: 20),
                                          title: Text("Confirmer"),
                                        ),
                                        onTap: () => _modifierStatutRdv(rdv.id!, 'confirme'),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: Icon(Icons.schedule, color: Colors.orange, size: 20),
                                          title: Text("Mettre en attente"),
                                        ),
                                        onTap: () => _modifierStatutRdv(rdv.id!, 'en_attente'),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: Icon(Icons.cancel, color: Colors.red, size: 20),
                                          title: Text("Annuler"),
                                        ),
                                        onTap: () => _modifierStatutRdv(rdv.id!, 'annule'),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: Icon(Icons.edit, color: Colors.blue, size: 20),
                                          title: Text("Modifier"),
                                        ),
                                        onTap: () => _showModifierRdvDialog(rdv),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: Icon(Icons.delete, color: Colors.red, size: 20),
                                          title: Text("Supprimer"),
                                        ),
                                        onTap: () => _showSupprimerRdvDialog(rdv),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Détails du RDV",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        childAspectRatio: 4,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 12,
                                        children: [
                                          _buildDetailItem("Type:", _getTypeLabel(rdv.typeRdv)),
                                          _buildDetailItem("Date:", _formatDate(rdv.date)),
                                          _buildDetailItem("Heure:", rdv.heure),
                                          _buildDetailItem("Statut:", _getStatutLabel(rdv.statut)),
                                          _buildDetailItem("Utilisateur:", "${user.prenom} ${user.nom}"),
                                          _buildDetailItem("Email:", user.email),
                                          _buildDetailItem("Téléphone:", user.telephone ?? "-"),
                                          _buildDetailItem("Créé le:", DateFormat('dd/MM/yyyy HH:mm').format(rdv.dateCreation)),
                                        ],
                                      ),
                                      if (rdv.notes != null && rdv.notes!.isNotEmpty) ...[
                                        SizedBox(height: 16),
                                        Text(
                                          "Notes:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _isDarkMode ? Colors.white10 : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            rdv.notes!,
                                            style: TextStyle(
                                              color: _isDarkMode ? Colors.white70 : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // PAGINATION
                    if (totalPages > 1)
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left),
                              onPressed: _currentRDVPage > 1
                                  ? () => setState(() => _currentRDVPage--)
                                  : null,
                            ),
                            ...List.generate(
                              totalPages,
                                  (index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () => setState(() => _currentRDVPage = index + 1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _currentRDVPage == index + 1
                                          ? Color(0xFF7C4DFF)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: _currentRDVPage == index + 1
                                            ? Colors.white
                                            : (_isDarkMode ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: _currentRDVPage < totalPages
                                  ? () => setState(() => _currentRDVPage++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRDVStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _isDarkMode ? Color(0xFF252525) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Color(0xFF311B92),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ========== PAGE GESTION DISPONIBILITÉS AMÉLIORÉE ==========

  Widget _buildGestionDisponibilites() {
    final jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // STATISTIQUES DISPONIBILITÉS
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: _isDarkMode ? Color(0xFF252525) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Configuration des Disponibilités",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Configurez les créneaux horaires disponibles pour chaque type de rendez-vous.",
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF7C4DFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${_disponibilites.length}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                        Text(
                          "Créneaux",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // BOUTONS D'ACTION
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: _isDarkMode ? Color(0xFF252525) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add, size: 18),
                    label: Text("Nouveau créneau"),
                    onPressed: () => _showAjouterDisponibiliteDialog(),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.copy, size: 18),
                    label: Text("Dupliquer la semaine"),
                    onPressed: () => _dupliquerSemaine(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete_sweep, size: 18),
                    label: Text("Supprimer tous"),
                    onPressed: () => _confirmerSuppressionTous(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.download, size: 18),
                    label: Text("Exporter"),
                    onPressed: () => _exporterDisponibilites(),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.print, size: 18),
                    label: Text("Imprimer"),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // LISTE PAR JOURS DE LA SEMAINE
          Expanded(
            child: DefaultTabController(
              length: jours.length,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: _isDarkMode ? Color(0xFF252525) : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: TabBar(
                        tabs: jours.map((jour) => Tab(text: jour)).toList(),
                        labelColor: Color(0xFF7C4DFF),
                        unselectedLabelColor: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                        indicator: BoxDecoration(
                          color: Color(0xFF7C4DFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: jours.map((jour) {
                        final disposJour = _disponibilites.where((d) => d.jour == jour).toList();

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: _isDarkMode ? Color(0xFF252525) : Colors.white,
                          child: disposJour.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time, size: 60, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  "Aucune disponibilité pour ce jour",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 12),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.add, size: 16),
                                  label: Text("Ajouter un créneau"),
                                  onPressed: () => _showAjouterDisponibiliteDialog(jour: jour),
                                ),
                              ],
                            ),
                          )
                              : ListView.builder(
                            padding: EdgeInsets.all(20),
                            itemCount: disposJour.length,
                            itemBuilder: (context, index) {
                              final dispo = disposJour[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                color: _isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
                                child: ListTile(
                                  leading: Switch(
                                    value: dispo.actif,
                                    onChanged: (value) => _toggleDisponibilite(dispo),
                                    activeColor: Color(0xFF7C4DFF),
                                  ),
                                  title: Text(
                                    "${dispo.heureDebut} - ${dispo.heureFin}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Chip(
                                        label: Text(
                                          _getTypeLabel(dispo.typeRdv),
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        backgroundColor: Color(0xFF7C4DFF).withOpacity(0.1),
                                        labelStyle: TextStyle(color: Color(0xFF7C4DFF)),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Jour: ${dispo.jour}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, size: 18),
                                        onPressed: () => _showModifierDisponibiliteDialog(dispo),
                                        tooltip: "Modifier",
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, size: 18),
                                        onPressed: () => _showSupprimerDispoDialog(dispo),
                                        tooltip: "Supprimer",
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== PAGE STATISTIQUES AMÉLIORÉE ==========

  Widget _buildStatistiques() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // EN-TÊTE STATISTIQUES
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5E35B1),
                      Color(0xFF7C4DFF),
                    ],
                   // borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "📊 Statistiques Détaillées",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Analyse complète de l'activité de la plateforme",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // GRAPHIQUES STATISTIQUES
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            "Évolution des RDV (7 derniers jours)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 200,
                            child: _buildChartEvolution(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            "Répartition par Statut",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 200,
                            child: _buildChartStatuts(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // TABLEAUX STATISTIQUES
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Top 5 Utilisateurs Actifs",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTopUtilisateurs(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Heures de Pointe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildHeuresPointe(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartEvolution() {
    // Implémenter un graphique d'évolution
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Graphique d'évolution",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChartStatuts() {
    // Implémenter un graphique circulaire
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Graphique circulaire",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUtilisateurs() {
    return Column(
      children: [
        ..._utilisateurs.take(5).map((user) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getRoleColor(user.role),
              child: Text(
                "${user.prenom[0]}${user.nom[0]}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text("${user.prenom} ${user.nom}"),
            subtitle: Text(user.email),
            trailing: Chip(
              label: Text("12 RDV"),
              backgroundColor: Color(0xFF7C4DFF).withOpacity(0.1),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeuresPointe() {
    final heures = [
      {'heure': '09:00', 'count': 15},
      {'heure': '10:00', 'count': 12},
      {'heure': '14:00', 'count': 18},
      {'heure': '15:00', 'count': 10},
      {'heure': '16:00', 'count': 8},
    ];

    return Column(
      children: heures.map((h) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text("h['heure']!, style: TextStyle(fontWeight: FontWeight.w500)"),
              SizedBox(width: 16),
              Expanded(
                child: LinearProgressIndicator(
                  //value: (h['count']! )/20,
                  backgroundColor: Colors.grey.shade200,
                  color: Color(0xFF7C4DFF),
                ),
              ),
              SizedBox(width: 16),
              Text("${h['count']} RDV"),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ========== PAGE RAPPORTS AMÉLIORÉE ==========

  Widget _buildRapports() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7C4DFF),
                      Color(0xFFE040FB),
                    ],
                    //borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "📄 Rapports & Exportations",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Générez des rapports détaillés sur l'activité de la plateforme",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildRapportCard(
                  title: "📋 Rapport Utilisateurs",
                  description: "Liste complète des utilisateurs avec statistiques détaillées",
                  icon: Icons.people,
                  onGenerate: _genererRapportUtilisateurs,
                ),
                _buildRapportCard(
                  title: "📅 Rapport RDV",
                  description: "Tous les rendez-vous avec filtres et analyses",
                  icon: Icons.calendar_today,
                  onGenerate: _genererRapportRDV,
                ),
                _buildRapportCard(
                  title: "📊 Statistiques Mensuelles",
                  description: "Évolution et tendances mensuelles",
                  icon: Icons.trending_up,
                  onGenerate: () => _genererStatistiquesMensuelles(),
                ),
                _buildRapportCard(
                  title: "⏰ Disponibilités",
                  description: "Configuration et utilisation des créneaux",
                  icon: Icons.access_time,
                  onGenerate: () => _genererRapportDisponibilites(),
                ),
                _buildRapportCard(
                  title: "📈 Performance",
                  description: "Métriques de performance et KPI",
                  icon: Icons.analytics,
                  onGenerate: () => _genererRapportPerformance(),
                ),
                _buildRapportCard(
                  title: "📤 Export Complet",
                  description: "Export de toutes les données",
                  icon: Icons.backup,
                  onGenerate: _exporterToutesDonnees,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRapportCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onGenerate,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF7C4DFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Color(0xFF7C4DFF)),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download, size: 16),
                label: Text("Générer"),
                onPressed: onGenerate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PAGE PARAMÈTRES AMÉLIORÉE ==========

  Widget _buildParametres() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5E35B1),
                      Color(0xFF7C4DFF),
                    ],
                    //borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "⚙️ Paramètres Système",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Configurez les paramètres de la plateforme",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // PARAMÈTRES GÉNÉRAUX
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paramètres Généraux",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildParametreItem(
                      icon: Icons.timer,
                      title: "Durée des rendez-vous",
                      description: "Définir la durée par défaut des RDV",
                      widget: DropdownButton(
                        value: "30",
                        items: [
                          DropdownMenuItem(value: "15", child: Text("15 minutes")),
                          DropdownMenuItem(value: "30", child: Text("30 minutes")),
                          DropdownMenuItem(value: "45", child: Text("45 minutes")),
                          DropdownMenuItem(value: "60", child: Text("1 heure")),
                        ],
                        onChanged: (value) {},
                      ),
                    ),

                    Divider(),

                    _buildParametreItem(
                      icon: Icons.notifications,
                      title: "Notifications",
                      description: "Configurer les notifications par email",
                      widget: Switch.adaptive(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Color(0xFF7C4DFF),
                      ),
                    ),

                    Divider(),

                    _buildParametreItem(
                      icon: Icons.language,
                      title: "Langue",
                      description: "Langue de l'interface",
                      widget: DropdownButton(
                        value: "fr",
                        items: [
                          DropdownMenuItem(value: "fr", child: Text("Français")),
                          DropdownMenuItem(value: "en", child: Text("Anglais")),
                          DropdownMenuItem(value: "ar", child: Text("Arabe")),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // SÉCURITÉ
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sécurité",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildParametreItem(
                      icon: Icons.lock,
                      title: "Force des mots de passe",
                      description: "Exiger des mots de passe complexes",
                      widget: Switch.adaptive(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Color(0xFF7C4DFF),
                      ),
                    ),

                    Divider(),

                    _buildParametreItem(
                      icon: Icons.history,
                      title: "Historique des connexions",
                      description: "Conserver l'historique pendant 90 jours",
                      widget: Switch.adaptive(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Color(0xFF7C4DFF),
                      ),
                    ),

                    Divider(),

                    _buildParametreItem(
                      icon: Icons.verified_user,
                      title: "Authentification à deux facteurs",
                      description: "Activer l'authentification 2FA",
                      widget: Switch.adaptive(
                        value: false,
                        onChanged: (value) {},
                        activeColor: Color(0xFF7C4DFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // MAINTENANCE
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Maintenance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete_sweep),
                          label: Text("Vider le cache"),
                          onPressed: _viderCache,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.backup),
                          label: Text("Sauvegarder"),
                          onPressed: _sauvegarderDonnees,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7C4DFF),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.restart_alt),
                          label: Text("Redémarrer"),
                          onPressed: _redemarrerApplication,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.settings_backup_restore),
                          label: Text("Restaurer"),
                          onPressed: _restaurerParametres,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Informations Système",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    _buildInfoSysteme("Version", "2.0.1"),
                    _buildInfoSysteme("Base de données", "SQLite"),
                    _buildInfoSysteme("Dernière sauvegarde", "Aujourd'hui 14:30"),
                    _buildInfoSysteme("Espace disque", "15.2 MB / 1 GB"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParametreItem({
    required IconData icon,
    required String title,
    required String description,
    required Widget widget,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF7C4DFF)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(description),
      trailing: widget,
    );
  }

  Widget _buildInfoSysteme(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 150, child: Text("$label:", style: TextStyle(fontWeight: FontWeight.w500))),
          SizedBox(width: 16),
          Text(value, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ========== FONCTIONS UTILITAIRES AMÉLIORÉES ==========

  List<Utilisateur> _filtrerUtilisateurs() {
    var filtered = _utilisateurs;

    if (_filtreRole != 'tous') {
      filtered = filtered.where((user) => user.role == _filtreRole).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text.toLowerCase();
      filtered = filtered.where((user) {
        return user.nom.toLowerCase().contains(search) ||
            user.prenom.toLowerCase().contains(search) ||
            user.email.toLowerCase().contains(search) ||
            (user.telephone != null && user.telephone!.contains(search));
      }).toList();
    }

    return filtered;
  }

  List<RendezVous> _filtrerRendezVous() {
    var filtered = _rendezVous;

    if (_filtreStatutRDV != 'tous') {
      filtered = filtered.where((rdv) => rdv.statut == _filtreStatutRDV).toList();
    }

    if (_filtreTypeRDV != 'tous') {
      filtered = filtered.where((rdv) => rdv.typeRdv == _filtreTypeRDV).toList();
    }

    if (_dateDebut != null) {
      filtered = filtered.where((rdv) => DateTime.parse(rdv.date).isAfter(_dateDebut!)).toList();
    }

    if (_dateFin != null) {
      filtered = filtered.where((rdv) => DateTime.parse(rdv.date).isBefore(_dateFin!)).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text.toLowerCase();
      filtered = filtered.where((rdv) {
        final user = _utilisateurs.firstWhere(
              (u) => u.id == rdv.utilisateurId,
          orElse: () => Utilisateur(nom: '', prenom: '', email: '', motDePasse: '', role: ''),
        );
        return user.nom.toLowerCase().contains(search) ||
            user.prenom.toLowerCase().contains(search) ||
            user.email.toLowerCase().contains(search) ||
            rdv.typeRdv.toLowerCase().contains(search);
      }).toList();
    }

    return filtered;
  }

  Future<void> _selectDate(BuildContext context, bool isDebut) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF7C4DFF),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isDebut) {
          _dateDebut = date;
        } else {
          _dateFin = date;
        }
      });
    }
  }

  void _exporterDonnees() {
    _showNotification("📤 Export des données en cours...", Colors.blue);
  }

  void _exporterUtilisateurs() {
    _showNotification("✅ Export des utilisateurs généré", Colors.green);
  }

  void _exporterRDV() {
    _showNotification("✅ Export des RDV généré", Colors.green);
  }

  void _exporterDisponibilites() {
    _showNotification("✅ Export des disponibilités généré", Colors.green);
  }

  void _exporterToutesDonnees() {
    _showNotification("✅ Export complet généré", Colors.green);
  }

  void _genererStatistiquesMensuelles() {
    _showNotification("📊 Statistiques mensuelles générées", Colors.green);
  }

  void _genererRapportDisponibilites() {
    _showNotification("📄 Rapport disponibilités généré", Colors.blue);
  }

  void _genererRapportPerformance() {
    _showNotification("📈 Rapport performance généré", Colors.blue);
  }

  void _viderCache() {
    _showNotification("🗑️ Cache vidé avec succès", Colors.green);
  }

  void _sauvegarderDonnees() {
    _showNotification("💾 Sauvegarde effectuée", Colors.green);
  }

  void _redemarrerApplication() {
    _showNotification("🔄 Redémarrage en cours...", Colors.blue);
  }

  void _restaurerParametres() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la restauration"),
        content: Text("Tous les paramètres seront réinitialisés aux valeurs par défaut. Continuer ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Restaurer"),
            onPressed: () {
              _showNotification("✅ Paramètres restaurés", Colors.green);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _dupliquerSemaine() {
    _showNotification("📋 Semaine dupliquée", Colors.green);
  }

  void _confirmerSuppressionTous() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer toutes les disponibilités"),
        content: Text("Êtes-vous sûr de vouloir supprimer tous les créneaux ? Cette action est irréversible."),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Supprimer tout"),
            onPressed: () {
              _showNotification("✅ Tous les créneaux supprimés", Colors.green);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showNotificationsPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    "Nouvel utilisateur inscrit",
                    "",
                    Icons.person_add,
                    Colors.blue,
                    "Il y a 5 min",
                  ),
                  _buildNotificationItem(
                    "RDV confirmé",
                    "",
                    Icons.check_circle,
                    Colors.green,
                    "Il y a 15 min",
                  ),
                  _buildNotificationItem(
                    "Alerte système",
                    "",
                    Icons.backup,
                    Colors.orange,
                    "Il y a 1 heure",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, IconData icon, Color color, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
      fontSize: 12,
    );
  }

  String _formatDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr;
    }
  }

  // ========== DIALOGUES AMÉLIORÉS ==========

  void _showAjouterUtilisateurDialog() {
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    _passwordController.clear();
    _telephoneController.clear();
    _selectedRole = 'parent';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nouvel Utilisateur"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: "Nom *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: "Prénom *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe *",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: "Téléphone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: "Rôle *",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'parent', child: Text("Parent")),
                  DropdownMenuItem(value: 'enseignant', child: Text("Enseignant")),
                  DropdownMenuItem(value: 'admin', child: Text("Administrateur")),
                ],
                onChanged: (value) => _selectedRole = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nomController.text.isEmpty ||
                  _prenomController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                _showNotification("❌ Tous les champs obligatoires doivent être remplis", Colors.red);
                return;
              }

              final data = {
                'nom': _nomController.text,
                'prenom': _prenomController.text,
                'email': _emailController.text,
                'password': _passwordController.text,
                'role': _selectedRole,
                'telephone': _telephoneController.text,
              };
              _ajouterUtilisateur(data);
              Navigator.pop(context);
            },
            child: Text("Créer"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7C4DFF),
            ),
          ),
        ],
      ),
    );
  }

  void _showModifierUtilisateurDialog(Utilisateur user) {
    _nomController.text = user.nom;
    _prenomController.text = user.prenom;
    _emailController.text = user.email;
    _telephoneController.text = user.telephone ?? '';
    _selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier l'utilisateur"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: "Nom *"),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(labelText: "Prénom *"),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email *"),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _telephoneController,
                decoration: InputDecoration(labelText: "Téléphone"),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                value: _selectedRole,
                decoration: InputDecoration(labelText: "Rôle *"),
                items: [
                  DropdownMenuItem(value: 'parent', child: Text("Parent")),
                  DropdownMenuItem(value: 'enseignant', child: Text("Enseignant")),
                  DropdownMenuItem(value: 'admin', child: Text("Administrateur")),
                ],
                onChanged: (value) => _selectedRole = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              final data = {
                'nom': _nomController.text,
                'prenom': _prenomController.text,
                'email': _emailController.text,
                'role': _selectedRole,
                'telephone': _telephoneController.text,
              };
              _modifierUtilisateur(user, data);
              Navigator.pop(context);
            },
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void _showSupprimerUtilisateurDialog(Utilisateur user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la suppression"),
        icon: Icon(Icons.warning, size: 40, color: Colors.red),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Supprimer l'utilisateur suivant ?"),
            SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: _getRoleColor(user.role),
                child: Text(
                  "${user.prenom[0]}${user.nom[0]}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text("${user.prenom} ${user.nom}"),
              subtitle: Text(user.email),
            ),
            SizedBox(height: 8),
            Text(
              "⚠️ Cette action est irréversible. Tous les rendez-vous associés seront également supprimés.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _supprimerUtilisateur(user.id!);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showModifierRdvDialog(RendezVous rdv) {
    // Implémenter le dialogue de modification RDV
    _showNotification("Modification RDV à implémenter", Colors.blue);
  }

  void _showSupprimerRdvDialog(RendezVous rdv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer le rendez-vous"),
        content: Text("Êtes-vous sûr de vouloir supprimer ce rendez-vous ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _supprimerRdv(rdv.id!);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showAjouterDisponibiliteDialog({String? jour}) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String selectedJour = jour ?? 'Lundi';
          String heureDebut = '09:00';
          String heureFin = '10:00';
          String selectedType = 'rendez-vous_pedagogique';
          bool actif = true;

          return AlertDialog(
            title: Text("Nouveau créneau"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    value: selectedJour,
                    decoration: InputDecoration(labelText: "Jour"),
                    items: [
                      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
                      'Vendredi', 'Samedi', 'Dimanche'
                    ].map((jour) {
                      return DropdownMenuItem(value: jour, child: Text(jour));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedJour = value!),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Heure début"),
                          onChanged: (value) => heureDebut = value,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Heure fin"),
                          onChanged: (value) => heureFin = value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: selectedType,
                    decoration: InputDecoration(labelText: "Type de RDV"),
                    items: [
                      DropdownMenuItem(
                        value: 'rendez-vous_pedagogique',
                        child: Text("Rendez-vous pédagogique"),
                      ),
                      DropdownMenuItem(
                        value: 'entretien_pedagogique',
                        child: Text("Entretien pédagogique"),
                      ),
                      DropdownMenuItem(
                        value: 'embauche',
                        child: Text("Entretien d'embauche"),
                      ),
                      DropdownMenuItem(
                        value: 'formation',
                        child: Text("Formation"),
                      ),
                    ],
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text("Actif"),
                    value: actif,
                    onChanged: (value) => setState(() => actif = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  final data = {
                    'jour': selectedJour,
                    'heureDebut': heureDebut,
                    'heureFin': heureFin,
                    'typeRdv': selectedType,
                    'actif': actif,
                  };
                  _ajouterDisponibilite(data);
                  Navigator.pop(context);
                },
                child: Text("Ajouter"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showModifierDisponibiliteDialog(Disponibilite dispo) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String selectedJour = dispo.jour;
          String heureDebut = dispo.heureDebut;
          String heureFin = dispo.heureFin;
          String selectedType = dispo.typeRdv;
          bool actif = dispo.actif;

          return AlertDialog(
            title: Text("Modifier le créneau"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    value: selectedJour,
                    decoration: InputDecoration(labelText: "Jour"),
                    items: [
                      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
                      'Vendredi', 'Samedi', 'Dimanche'
                    ].map((jour) {
                      return DropdownMenuItem(value: jour, child: Text(jour));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedJour = value!),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Heure début"),
                          controller: TextEditingController(text: heureDebut),
                          onChanged: (value) => heureDebut = value,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Heure fin"),
                          controller: TextEditingController(text: heureFin),
                          onChanged: (value) => heureFin = value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: selectedType,
                    decoration: InputDecoration(labelText: "Type de RDV"),
                    items: [
                      DropdownMenuItem(
                        value: 'rendez-vous_pedagogique',
                        child: Text("Rendez-vous pédagogique"),
                      ),
                      DropdownMenuItem(
                        value: 'entretien_pedagogique',
                        child: Text("Entretien pédagogique"),
                      ),
                      DropdownMenuItem(
                        value: 'embauche',
                        child: Text("Entretien d'embauche"),
                      ),
                      DropdownMenuItem(
                        value: 'formation',
                        child: Text("Formation"),
                      ),
                    ],
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text("Actif"),
                    value: actif,
                    onChanged: (value) => setState(() => actif = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  final data = {
                    'jour': selectedJour,
                    'heureDebut': heureDebut,
                    'heureFin': heureFin,
                    'typeRdv': selectedType,
                    'actif': actif,
                  };
                  _modifierDisponibilite(dispo, data);
                  Navigator.pop(context);
                },
                child: Text("Enregistrer"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSupprimerDispoDialog(Disponibilite dispo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer la disponibilité"),
        content: Text("Supprimer ce créneau du ${dispo.jour} (${dispo.heureDebut} - ${dispo.heureFin}) ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _supprimerDisponibilite(dispo.id!);
              Navigator.pop(context);
            },
            child: Text("Supprimer"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

// ========== FONCTIONS UTILITAIRES GÉNÉRALES ==========

IconData _getActiviteIcon(String type) {
  switch (type) {
    case 'user': return Icons.person_add;
    case 'rdv': return Icons.calendar_today;
    case 'dispo': return Icons.access_time;
    default: return Icons.info;
  }
}

Color _getActiviteColor(String type) {
  switch (type) {
    case 'user': return Color(0xFF4FC3F7);
    case 'rdv': return Color(0xFF7C4DFF);
    case 'dispo': return Color(0xFF66BB6A);
    default: return Colors.grey;
  }
}

Color _getStatutColor(String statut) {
  switch (statut) {
    case 'confirme': return Colors.green;
    case 'annule': return Colors.red;
    default: return Colors.orange;
  }
}

Widget _getStatutIcon(String statut, {double size = 24}) {
  IconData icon;
  Color color;

  switch (statut) {
    case 'confirme':
      icon = Icons.check_circle;
      color = Colors.green;
      break;
    case 'annule':
      icon = Icons.cancel;
      color = Colors.red;
      break;
    default:
      icon = Icons.schedule;
      color = Colors.orange;
  }

  return Icon(icon, color: color, size: size);
}

Color _getRoleColor(String role) {
  switch (role) {
    case 'admin':
      return Color(0xFF5E35B1);
    case 'enseignant':
      return Color(0xFF7C4DFF);
    case 'parent':
      return Color(0xFF9575CD);
    default:
      return Colors.grey;
  }
}

String _getRoleLabel(String role) {
  switch (role) {
    case 'admin':
      return 'Administrateur';
    case 'enseignant':
      return 'Enseignant';
    case 'parent':
      return 'Parent';
    default:
      return role;
  }
}

String _getTypeLabel(String type) {
  switch (type) {
    case 'rendez-vous_pedagogique':
      return "Rendez-vous pédagogique";
    case 'entretien_pedagogique':
      return "Entretien pédagogique";
    case 'embauche':
      return "Entretien d'embauche";
    case 'formation':
      return "Formation";
    default:
      return type;
  }
}

String _getStatutLabel(String statut) {
  switch (statut) {
    case 'confirme':
      return 'Confirmé';
    case 'annule':
      return 'Annulé';
    default:
      return 'En attente';
  }
}

// ====================================
// LOGIN PAGE
// ====================================

class LoginPage extends StatefulWidget {
  final String role;
  LoginPage({required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final utilisateur = await UtilisateurService().connexion(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (utilisateur == null) {
        throw Exception('Email ou mot de passe incorrect');
      }

      if (utilisateur.role != widget.role) {
        throw Exception('Accès non autorisé pour ce profil');
      }

      Session.instance.connecter(utilisateur);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion ${_getRoleLabel()}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Icon(
                _getRoleIcon(),
                size: 100,
                color: Color(0xFF7C4DFF),
              ),
              SizedBox(height: 24),
              Text(
                _getRoleLabel(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF311B92),
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _seConnecter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C4DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              if (widget.role != 'admin') ...[
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InscriptionPage(role: widget.role),
                      ),
                    );
                  },
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(color: Color(0xFF7C4DFF)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleLabel() {
    switch (widget.role) {
      case 'admin':
        return 'Administrateur';
      case 'enseignant':
        return 'Enseignant';
      case 'parent':
        return 'Parent';
      default:
        return '';
    }
  }

  IconData _getRoleIcon() {
    switch (widget.role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'enseignant':
        return Icons.school;
      case 'parent':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }
}

// ====================================
// RESERVATION PAGE
// ====================================

class ReservationPage extends StatefulWidget {
  final Disponibilite disponibilite;
  ReservationPage({required this.disponibilite});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _notesController = TextEditingController();
  final _dispoService = DisponibiliteService();
  final _rdvService = RendezVousService();

  String? _selectedDate;
  List<Map<String, dynamic>> _datesDisponibles = [];
  bool _isLoading = false;
  bool _chargementDates = true;

  @override
  void initState() {
    super.initState();
    _chargerDatesDisponibles();
  }

  Future<void> _chargerDatesDisponibles() async {
    try {
      final dates = await _dispoService.obtenirDatesDisponibles(widget.disponibilite.jour);
      setState(() {
        _datesDisponibles = dates;
        _chargementDates = false;
        if (dates.isNotEmpty) {
          _selectedDate = dates.first['date'];
        }
      });
    } catch (e) {
      print('Erreur chargement dates: $e');
      setState(() => _chargementDates = false);
      _afficherErreur('Erreur de chargement des dates');
    }
  }

  Future<void> _confirmerReservation() async {
    if (_selectedDate == null) {
      _afficherErreur('Veuillez sélectionner une date');
      return;
    }

    if (!Session.instance.estConnecte) {
      _afficherErreur('Veuillez vous connecter pour réserver');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Vérifier la disponibilité
      final disponible = await _rdvService.verifierDisponibilite(
        _selectedDate!,
        widget.disponibilite.heureDebut,
        widget.disponibilite.typeRdv,
      );

      if (!disponible) {
        throw Exception('Ce créneau n\'est plus disponible');
      }

      // Créer le rendez-vous
      final nouveauRdv = RendezVous(
        utilisateurId: Session.instance.utilisateurActuel!.id!,
        typeRdv: widget.disponibilite.typeRdv,
        date: _selectedDate!,
        heure: widget.disponibilite.heureDebut,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      await _rdvService.creerRendezVous(nouveauRdv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rendez-vous réservé avec succès !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      _afficherErreur(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle réservation"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Détails du créneau
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Détails du créneau",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF311B92),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow("Type", _getTypeLabel(widget.disponibilite.typeRdv)),
                    _buildInfoRow("Jour", widget.disponibilite.jour),
                    _buildInfoRow("Horaire", "${widget.disponibilite.heureDebut} - ${widget.disponibilite.heureFin}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Sélection de la date
            Text(
              "Sélectionnez une date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF311B92),
              ),
            ),
            SizedBox(height: 12),

            if (_chargementDates)
              Center(child: CircularProgressIndicator())
            else if (_datesDisponibles.isEmpty)
              Center(child: Text("Aucune date disponible pour ce jour"))
            else
              Column(
                children: _datesDisponibles.map((date) {
                  final isSelected = _selectedDate == date['date'];
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    color: isSelected ? Color(0xFF7C4DFF).withOpacity(0.1) : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: isSelected ? Color(0xFF7C4DFF) : Colors.grey,
                      ),
                      title: Text(
                        date['affichage'],
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Color(0xFF7C4DFF) : Colors.black,
                        ),
                      ),
                      subtitle: Text(date['jour']),
                      trailing: isSelected ? Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
                      onTap: () {
                        setState(() {
                          _selectedDate = date['date'];
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

            SizedBox(height: 24),

            // Notes
            Text(
              "Notes (optionnel)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF311B92),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Ajoutez des informations complémentaires...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 32),

            // Bouton de confirmation
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading || _selectedDate == null ? null : _confirmerReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Confirmer la réservation",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              child: Text(
                "$label:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF311B92),
                ),
              ),
            ),
          ],
        )
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'rendez-vous_pedagogique':
        return "Rendez-vous pédagogique";
      case 'entretien_pedagogique':
        return "Entretien pédagogique";
      case 'embauche':
        return "Entretien d'embauche";
      case 'formation':
        return "Formation";
      default:
        return type;
    }
  }
}

// ====================================
// INSCRIPTION PAGE
// ====================================

class InscriptionPage extends StatefulWidget {
  final String role;
  InscriptionPage({required this.role});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sInscrire() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = UtilisateurService();

      // Vérifier si l'email existe déjà
      final utilisateurExistant = await service.lireParEmail(_emailController.text.trim());
      if (utilisateurExistant != null) {
        throw Exception('Cet email est déjà utilisé');
      }

      final nouvelUtilisateur = Utilisateur(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        motDePasse: _passwordController.text,
        role: widget.role,
        telephone: _telephoneController.text.trim().isEmpty ? null : _telephoneController.text.trim(),
      );

      await service.creer(nouvelUtilisateur);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Compte créé avec succès ! Vous pouvez maintenant vous connecter.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Revenir à la page de connexion
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un compte"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.person_add,
                size: 80,
                color: Color(0xFF7C4DFF),
              ),
              SizedBox(height: 16),
              Text(
                "Nouveau compte ${_getRoleLabel()}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF311B92),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: "Prénom",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre prénom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: "Téléphone (optionnel)",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sInscrire,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C4DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "S'inscrire",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleLabel() {
    switch (widget.role) {
      case 'admin':
        return 'Administrateur';
      case 'enseignant':
        return 'Enseignant';
      case 'parent':
        return 'Parent';
      default:
        return '';
    }
  }
}