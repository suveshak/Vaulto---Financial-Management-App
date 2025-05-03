import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:vaulto/screens/profile_settings_screen.dart';
import 'ai_connection_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Account',
            children: [
              _buildListTile(
                leading: Icons.person,
                title: 'Profile',
                subtitle: 'Update your profile information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                leading: Icons.contact_mail,
                title: 'Contact',
                subtitle: 'Update contact information',
                onTap: () {
                  // TODO: Navigate to contact screen(Saturday)
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Preferences',
            children: [
              _buildListTile(
                leading: Icons.palette,
                title: 'Theme',
                subtitle: 'Change app theme',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              _buildListTile(
                leading: Icons.language,
                title: 'Language',
                subtitle: 'Change app language',
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: ['English', 'Spanish', 'French', 'German']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Legal',
            children: [
              _buildListTile(
                leading: Icons.description,
                title: 'Terms of Service',
                onTap: () {
                  // TODO: Show terms of service( Ask Suvesha For this)
                },
              ),
              _buildListTile(
                leading: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {
                  // TODO: Show privacy policy(Ask Suvesha for this)
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'AI Settings',
            children: [
              ListTile(
                title: const Text('AI Connection'),
                subtitle: const Text('Configure AI server connection'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIConnectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(leading),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
