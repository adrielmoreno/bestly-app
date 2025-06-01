import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/di/app_modules.dart';
import '../../auth/view_model/auth_view_model.dart';

class MenuNavigation extends StatelessWidget {
  const MenuNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Usuario';
    final photoURL = user?.photoURL;

    final shortcuts = [
      {'icon': Icons.fitness_center, 'label': 'Fitness'},
      {'icon': Icons.money, 'label': 'Finanzas'},
      {'icon': Icons.ondemand_video, 'label': 'Superacion'},
      {'icon': Icons.leaderboard, 'label': 'Liderazgo'},
      {'icon': Icons.inventory, 'label': 'Ventas'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          // Perfil
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/alexander.jpg'),
              radius: 24,
            ),
            title: Text(displayName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ver tu perfil'),
            onTap: () {},
          ),
          const Divider(),
          // Accesos directos
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 16,
              children: shortcuts.map((item) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child:
                          Icon(item['icon'] as IconData, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(item['label'] as String,
                        style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ),

          const Divider(),

          // Configuración y opciones
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración y privacidad'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Centro de ayuda'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Modo oscuro'),
            trailing: const Icon(Icons.toggle_off),
            onTap: () {
              // Aquí podemos conectar lógica real para cambiar el tema
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              inject<AuthViewModel>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
