import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Customize your experience',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSectionTitle('App Settings'),
                  _buildSettingTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Always on',
                    trailing: Switch(
                      value: true,
                      onChanged: null,
                      activeColor: const Color(0xFF6C5CE7),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.high_quality_outlined,
                    title: 'Image Quality',
                    subtitle: '4K (recommended)',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'New wallpapers & tips',
                    trailing: Switch(
                      value: false,
                      onChanged: (v) {},
                      activeColor: const Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('About'),
                  _buildSettingTile(
                    icon: Icons.info_outline,
                    title: 'Version',
                    subtitle: '1.0.0',
                  ),
                  _buildSettingTile(
                    icon: Icons.star_outline,
                    title: 'Rate App',
                    subtitle: 'Help us improve',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    subtitle: 'Tell your friends',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Usage terms',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Support'),
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    subtitle: 'Common questions',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.email_outlined,
                    title: 'Contact Us',
                    subtitle: 'feedback@app.com',
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF6C5CE7),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF888888)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 12,
          ),
        ),
        trailing: trailing ?? const Icon(
          Icons.chevron_right,
          color: Color(0xFF444444),
        ),
        onTap: onTap,
      ),
    );
  }
}
