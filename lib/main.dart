import 'package:flutter/material.dart';

void main() {
  runApp(const CantineApp());
}

class CantineApp extends StatelessWidget {
  const CantineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantine CPA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Salarié';

  void _login() {
    String email = _emailController.text.trim();
    if (email.isEmpty) email = "utilisateur@cpa.mg";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainHomeScreen(
          role: _selectedRole,
          userEmail: email,
        ),
      ),
    );
  }

  void _quickLogin(String role, String email) {
    setState(() {
      _selectedRole = role;
      _emailController.text = email;
      _passwordController.text = "123456";
    });
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 70, color: Colors.indigo),
              const SizedBox(height: 12),
              const Text(
                'Cantine CPA x TSARA TSIRO',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(labelText: 'Rôle'),
                        items: ['Salarié', 'Traiteur', 'Administration'].map((role) {
                          return DropdownMenuItem(value: role, child: Text(role));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedRole = val!),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Identifiant / E-mail', prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock)),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Connexion rapide de démo :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.person, size: 16),
                    label: const Text('Salarié'),
                    onPressed: () => _quickLogin('Salarié', 'salarie@cpa.mg'),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.flatware, size: 16),
                    label: const Text('Traiteur'),
                    onPressed: () => _quickLogin('Traiteur', 'traiteur@tsaratsiro.mg'),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.admin_panel_settings, size: 16),
                    label: const Text('Admin'),
                    onPressed: () => _quickLogin('Administration', 'admin@cpa.mg'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  final String role;
  final String userEmail;

  const MainHomeScreen({super.key, required this.role, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace $role'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Card(
              color: Colors.indigo.shade50,
              child: ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.indigo, size: 40),
                title: Text('Connecté en tant que : $userEmail'),
                subtitle: Text('Rôle actif : $role'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildRoleContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleContent() {
    if (role == 'Salarié') {
      return ListView(
        children: const [
          Text(' Choix du Menu de la Semaine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              title: Text('Lundi : Poulet Rôti / Frites'),
              subtitle: Text('Statut : Validé'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Mardi : Tagliatelles Carbonara'),
              subtitle: Text('Choix en attente'),
              trailing: Icon(Icons.edit_calendar, color: Colors.orange),
            ),
          ),
        ],
      );
    } else if (role == 'Traiteur') {
      return ListView(
        children: const [
          Text(' Récapitulatif des Commandes (TSARA TSIRO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              title: Text('Lundi 10'),
              subtitle: Text('42 Repas Poulet Rôti - 15 Repas Poisson'),
              trailing: Chip(label: Text('En cours')),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        children: const [
          Text(' Administration CPA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text('Gestion des Salariés'),
              subtitle: Text('48 salariés actifs'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Rapports & Facturation'),
              subtitle: Text('Exporter la synthèse mensuelle'),
            ),
          ),
        ],
      );
    }
  }
}
