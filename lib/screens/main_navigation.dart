import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'nurse/nurse_dashboard_screen.dart';
import '../providers/auth_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  List<Widget> get _screens {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      const HomeScreen(),
      const ServicesScreen(),
      const ReportsScreen(),
      authProvider.isAuthenticated
          ? const ProfileScreen()
          : const LoginScreen(),
      if (authProvider.isAuthenticated && authProvider.userRole == 'admin')
        const AdminDashboardScreen(),
      if (authProvider.isAuthenticated && authProvider.userRole == 'nurse')
        const NurseDashboardScreen(),
    ];
  }

  List<NavigationDestination> get _destinations {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.medical_services_outlined),
        selectedIcon: Icon(Icons.medical_services),
        label: 'Services',
      ),
      const NavigationDestination(
        icon: Icon(Icons.description_outlined),
        selectedIcon: Icon(Icons.description),
        label: 'Reports',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
      if (authProvider.isAuthenticated && authProvider.userRole == 'admin')
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      if (authProvider.isAuthenticated && authProvider.userRole == 'nurse')
        const NavigationDestination(
          icon: Icon(Icons.medical_information_outlined),
          selectedIcon: Icon(Icons.medical_information),
          label: 'Nurse',
        ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AashaDostBottomSheet(),
            );
          },
          tooltip: 'Ask AASHA DOST',
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.smart_toy_outlined),
          label: const Text(
            'Ask AASHA DOST',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AashaDostBottomSheet extends StatefulWidget {
  const AashaDostBottomSheet({super.key});

  @override
  State<AashaDostBottomSheet> createState() => _AashaDostBottomSheetState();
}

class _AashaDostBottomSheetState extends State<AashaDostBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hello! I'm AASHA DOST, your AI health assistant. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );

      // Simulate AI response
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessage(
                text: _getAIResponse(_messageController.text),
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
          });
        }
      });
    });

    _messageController.clear();
  }

  String _getAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('hello') || message.contains('hi')) {
      return "Hello! How are you feeling today? I'm here to help with any health-related questions.";
    } else if (message.contains('appointment') || message.contains('book')) {
      return "I can help you book an appointment! Would you like me to guide you through the booking process?";
    } else if (message.contains('test') || message.contains('lab')) {
      return "For lab tests, you can browse our services section. We offer home collection for most tests. What type of test are you looking for?";
    } else if (message.contains('report') || message.contains('result')) {
      return "Your test reports are available in the Reports section. You can view, download, or share them anytime.";
    } else if (message.contains('medicine') ||
        message.contains('prescription')) {
      return "For medicines, you can use our Order Medicine feature. Do you have a prescription ready?";
    } else if (message.contains('emergency') || message.contains('urgent')) {
      return "For medical emergencies, please call emergency services immediately at 108 or visit the nearest hospital.";
    } else {
      return "I'm here to help with health-related questions, appointment booking, test information, and general medical guidance. What specific health concern can I assist you with?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AASHA DOST',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Your AI Health Assistant',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything about health...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: const Color(0xFF2E7D32),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primaryGreen : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
          boxShadow: [
            if (message.isUser)
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
