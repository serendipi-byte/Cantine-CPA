import 'package:flutter/material.dart';

void main() {
  runApp(const CantineCPAApp());
}

class CantineCPAApp extends StatelessWidget {
  const CantineCPAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantine CPA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SalariePlanningView(),
    const TraiteurView(),
    const AdminView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 4,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Cantine CPA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'En partenariat avec TSARA TSIRO',
              style: TextStyle(
                color: Color(0xFFF59E0B),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Mon Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Traiteur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODÈLE DE DONNÉES DU MENU DE LA SEMAINE (ADMIN -> SALARIÉ)
// ============================================================================
class DailyMenuData {
  final String dateHeader; // ex: "Lundi 17 Août 2026"
  final String p1Name;
  final String p2Name;
  final String p3Name;
  final String fruitOption;
  final String jusOption;
  final List<String>? gouterOptions; // null si pas de goûter ce jour-là

  DailyMenuData({
    required this.dateHeader,
    required this.p1Name,
    required this.p2Name,
    required this.p3Name,
    required this.fruitOption,
    required this.jusOption,
    this.gouterOptions,
  });
}

// ============================================================================
// 1. ESPACE SALARIÉ - CHOIX HEBDOMADAIRE PAR DATE
// ============================================================================
class SalariePlanningView extends StatefulWidget {
  const SalariePlanningView({super.key});

  @override
  State<SalariePlanningView> createState() => _SalariePlanningViewState();
}

class _SalariePlanningViewState extends State<SalariePlanningView> {
  // Données de démonstration saisies au préalable par l'Admin
  final List<DailyMenuData> _weekMenus = [
    DailyMenuData(
      dateHeader: 'Lundi 17 Août 2026',
      p1Name: 'P1 - Poulet Sauté aux Légumes & Riz',
      p2Name: 'P2 - Porc au Bambou (Ravitoto)',
      p3Name: 'P3 - Spaghetti Bolognese',
      fruitOption: 'Banane de Tamatave',
      jusOption: 'Jus Naturel Carotte & Orange',
      gouterOptions: null, // Pas de goûter
    ),
    DailyMenuData(
      dateHeader: 'Mardi 18 Août 2026',
      p1Name: 'P1 - Filet de Poisson Sauce Citron & Riz',
      p2Name: 'P2 - Beefsteak Grillé & Purée',
      p3Name: 'P3 - Nems au Poulet avec Riz Cantonnais',
      fruitOption: 'Tranche d\'Ananas',
      jusOption: 'Jus Naturel Pamplemousse',
      gouterOptions: null, // Pas de goûter
    ),
    DailyMenuData(
      dateHeader: 'Mercredi 19 Août 2026',
      p1Name: 'P1 - Mine Sao au Poulet',
      p2Name: 'P2 - Langue de Bœuf Sauce Tomate',
      p3Name: 'P3 - Plat Composé Omelette & Charcuterie',
      fruitOption: 'Pomme',
      jusOption: 'Jus Naturel Citronnade',
      gouterOptions: ['Mofo Légumes', 'Part de Cake'], // Goûter actif !
    ),
    DailyMenuData(
      dateHeader: 'Jeudi 20 Août 2026',
      p1Name: 'P1 - Saucisse Fumé au Voanjobory & Riz',
      p2Name: 'P2 - Poulet Curry & Riz',
      p3Name: 'P3 - Pâtes Carbonara',
      fruitOption: 'Mangue',
      jusOption: 'Jus Naturel Corossol',
      gouterOptions: null, // Pas de goûter
    ),
    DailyMenuData(
      dateHeader: 'Vendredi 21 Août 2026',
      p1Name: 'P1 - Tsitronel de Poisson & Riz',
      p2Name: 'P2 - Bœuf aux Oignons & Riz',
      p3Name: 'P3 - Composé Salade & Beignets',
      fruitOption: 'Papaye',
      jusOption: 'Jus Naturel Passion',
      gouterOptions: ['Mi-sao', 'Crêpe au Chocolat'], // Goûter actif !
    ),
  ];

  // Enregistrement des choix du salarié pour chaque jour
  final Map<int, String> _selectedPlats = {};
  final Map<int, String> _selectedDesserts = {};
  final Map<int, String> _selectedGouters = {};

  @override
  void initState() {
    super.initState();
    // Valeurs par défaut
    for (int i = 0; i < _weekMenus.length; i++) {
      _selectedPlats[i] = 'P1';
      _selectedDesserts[i] = 'FRUIT';
      if (_weekMenus[i].gouterOptions != null) {
        _selectedGouters[i] = _weekMenus[i].gouterOptions![0];
      }
    }
  }

  void _showCancellationDialog(String dateStr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annulation - $dateStr'),
        content: const Text(
          'Voulez-vous soumettre une annulation exceptionnelle d\'urgence ("Je ne travaille pas") pour cette journée ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retour'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Demande d\'annulation transmise pour le $dateStr'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('JE NE TRAVAILLE PAS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Avertissement Règlement
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Important : Veuillez valider votre choix hebdomadaire. Toute annulation doit se faire la veille avant 17h00.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Génération des cartes pour chaque jour de la semaine
        for (int index = 0; index < _weekMenus.length; index++) ...[
          _buildDayCard(index, _weekMenus[index]),
          const SizedBox(height: 16),
        ],

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Toutes vos commandes de la semaine ont été enregistrées !'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('VALIDER MA SEMAINE COMPLETEMENT', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDayCard(int dayIndex, DailyMenuData menu) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entête du jour avec bouton d'annulation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  menu.dateHeader,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.event_busy, size: 16, color: Colors.red),
                  label: const Text('Annuler', style: TextStyle(color: Colors.red, fontSize: 12)),
                  onPressed: () => _showCancellationDialog(menu.dateHeader),
                ),
              ],
            ),
            const Divider(),

            // 1. CHOIX DES PLATS (P1, P2, P3)
            const Text('Choix du Plat :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ListTile(
              dense: true,
              title: Text(menu.p1Name),
              leading: Radio<String>(
                value: 'P1',
                groupValue: _selectedPlats[dayIndex],
                onChanged: (v) => setState(() => _selectedPlats[dayIndex] = v!),
              ),
              onTap: () => setState(() => _selectedPlats[dayIndex] = 'P1'),
            ),
            ListTile(
              dense: true,
              title: Text(menu.p2Name),
              leading: Radio<String>(
                value: 'P2',
                groupValue: _selectedPlats[dayIndex],
                onChanged: (v) => setState(() => _selectedPlats[dayIndex] = v!),
              ),
              onTap: () => setState(() => _selectedPlats[dayIndex] = 'P2'),
            ),
            ListTile(
              dense: true,
              title: Text(menu.p3Name),
              leading: Radio<String>(
                value: 'P3',
                groupValue: _selectedPlats[dayIndex],
                onChanged: (v) => setState(() => _selectedPlats[dayIndex] = v!),
              ),
              onTap: () => setState(() => _selectedPlats[dayIndex] = 'P3'),
            ),

            const SizedBox(height: 8),

            // 2. CHOIX DESSERT / JUS
            const Text('Choix Dessert / Boisson :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ListTile(
              dense: true,
              title: Text('Fruit : ${menu.fruitOption}'),
              leading: Radio<String>(
                value: 'FRUIT',
                groupValue: _selectedDesserts[dayIndex],
                onChanged: (v) => setState(() => _selectedDesserts[dayIndex] = v!),
              ),
              onTap: () => setState(() => _selectedDesserts[dayIndex] = 'FRUIT'),
            ),
            ListTile(
              dense: true,
              title: Text('Jus : ${menu.jusOption}'),
              leading: Radio<String>(
                value: 'JUS',
                groupValue: _selectedDesserts[dayIndex],
                onChanged: (v) => setState(() => _selectedDesserts[dayIndex] = v!),
              ),
              onTap: () => setState(() => _selectedDesserts[dayIndex] = 'JUS'),
            ),

            // 3. CHOIX GOÛTER (AFFICHÉ SEULEMENT SI PROGRAMMÉ CE JOUR)
            if (menu.gouterOptions != null) ...[
              const Divider(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bakery_dining, color: Colors.amber, size: 18),
                        SizedBox(width: 6),
                        Text('Option Goûter du jour :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    for (String gouter in menu.gouterOptions!)
                      ListTile(
                        dense: true,
                        title: Text(gouter),
                        leading: Radio<String>(
                          value: gouter,
                          groupValue: _selectedGouters[dayIndex],
                          onChanged: (v) => setState(() => _selectedGouters[dayIndex] = v!),
                        ),
                        onTap: () => setState(() => _selectedGouters[dayIndex] = gouter),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. ESPACE TRAITEUR (TSARA TSIRO)
// ============================================================================
class TraiteurView extends StatefulWidget {
  const TraiteurView({super.key});

  @override
  State<TraiteurView> createState() => _TraiteurViewState();
}

class _TraiteurViewState extends State<TraiteurView> {
  bool _isValidated = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Récapitulatif Hebdomadaire - TSARA TSIRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.summarize, color: Color(0xFF2563EB)),
              title: const Text('Semaine du 17/08 au 21/08/2026'),
              subtitle: const Text('Commandes valides + Annulations reçues'),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text('Valider les commandes / annulations'),
            onPressed: () {
              setState(() => _isValidated = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Validé avec succès.'), backgroundColor: Colors.green),
              );
            },
          ),
          if (_isValidated) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.send),
              label: const Text('Envoyer vers administrateur'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Les 2 fichiers Excel ont été transmis à l\'Admin.'), backgroundColor: Colors.blue),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 3. ESPACE ADMINISTRATION
// ============================================================================
class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Panneau de Contrôle Administration CPA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.edit_calendar, color: Color(0xFF2563EB)),
          title: const Text('Programmer le Menu de la Semaine'),
          subtitle: const Text('Définir les plats P1, P2, P3, Jus, Fruits et Goûters par date'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.people, color: Color(0xFF2563EB)),
          title: const Text('Gestion des Salariés'),
          subtitle: const Text('Activer / Bloquer les comptes'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.download, color: Color(0xFF059669)),
          title: const Text('Télécharger les Fichiers Excel Traiteur'),
          subtitle: const Text('Fichiers émargement menus et goûters'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ],
    );
  }
}
