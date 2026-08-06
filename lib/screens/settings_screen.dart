import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Settings screen - server aur user ID configure karte hain
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController serverController;
  late TextEditingController userIdController;
  late TextEditingController syncIntervalController;

  @override
  void initState() {
    super.initState();
    serverController = TextEditingController(text: 'http://localhost:8000');
    userIdController = TextEditingController(text: ApiService.userId);
    syncIntervalController = TextEditingController(text: 'real-time');
  }

  @override
  void dispose() {
    serverController.dispose();
    userIdController.dispose();
    syncIntervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & API config'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[900]!,
              Colors.teal[700]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Server section
              _buildSection(
                title: 'API Server',
                children: [
                  _buildTextField(
                    label: 'Server URL',
                    controller: serverController,
                    hint: 'http://localhost:8000',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💡 Backend API ka URL yahan daal. Abhi dummy hai.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[200],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // User section
              _buildSection(
                title: 'User ID',
                children: [
                  _buildTextField(
                    label: 'User ID',
                    controller: userIdController,
                    hint: 'user123',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💡 Apka unique user ID. API ko notifications bhejte wakt use hota hai.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[200],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Sync section
              _buildSection(
                title: 'Sync Interval',
                children: [
                  _buildTextField(
                    label: 'Sync Type',
                    controller: syncIntervalController,
                    hint: 'real-time',
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💡 Notifications real-time sync hote hain jab capture honge.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[200],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Advanced section
              _buildSection(
                title: 'Battery & Network',
                children: [
                  _buildSettingRow('Retry on failure', Icons.refresh, true),
                  const SizedBox(height: 12),
                  _buildSettingRow('Sync on WiFi only', Icons.wifi, false),
                ],
              ),
              const SizedBox(height: 25),

              // REST API section
              _buildSection(
                title: 'REST API Endpoints',
                children: [
                  _buildApiEndpoint(
                    method: 'POST',
                    endpoint: '/api/notifications',
                    description: 'Send notification to API',
                  ),
                  const SizedBox(height: 12),
                  _buildApiEndpoint(
                    method: 'GET',
                    endpoint: '/api/notifications?user_id=user123',
                    description: 'Fetch all user notifications',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton(
                onPressed: () {
                  // Update API service
                  ApiService.userId = userIdController.text;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '✅ Settings saved! User ID: ${userIdController.text}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Save settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build a section
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue[400]!.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  // Helper to build text field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[300]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blue[200]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[400]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[600]!, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  // Helper to build setting row (toggle kaise hote hain)
  Widget _buildSettingRow(String label, IconData icon, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue[300], size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            setState(() {});
          },
          activeColor: Colors.blue[400],
        ),
      ],
    );
  }

  // Helper to show API endpoint
  Widget _buildApiEndpoint({
    required String method,
    required String endpoint,
    required String description,
  }) {
    Color methodColor = method == 'POST' ? Colors.orange[400]! : Colors.green[400]!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue[400]!.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: methodColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  method,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: methodColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  endpoint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[200],
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }
}
