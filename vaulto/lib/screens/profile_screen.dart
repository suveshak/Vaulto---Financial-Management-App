import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vaulto/providers/auth_provider.dart';
import 'package:vaulto/providers/theme_provider.dart';
import 'qr_scanner_screen.dart';
import 'add_receipt_screen.dart';
import 'add_expense_dialog.dart';
import 'package:vaulto/providers/budget_provider.dart';
import 'chatbot_screen.dart';
import 'goals_screen.dart';
import 'analytics_screen.dart';
import 'expenses_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: authProvider.userImagePath != null
                          ? ClipOval(
                              child: Image.asset(
                                authProvider.userImagePath!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      authProvider.userName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.userEmail,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              _buildQRCodeSection(context),
              _buildMenuSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQRCodeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Your QR Code',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code,
                      size: 150,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Scan to receive payments',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.home,
          title: 'Home',
          subtitle: 'Back to dashboard',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.receipt_long,
          title: 'Expenses',
          subtitle: 'View all expenses',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExpensesScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.account_balance,
          title: 'Bank Accounts',
          subtitle: 'Manage linked accounts',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/bank-accounts');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.lock,
          title: 'Budget Locking',
          subtitle: 'Set spending limits',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/budget-locking');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.analytics,
          title: 'Analytics',
          subtitle: 'View spending insights',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/analytics');
          },
        ),
        const Divider(),
        _buildMenuItem(
          context,
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          onTap: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }
} 