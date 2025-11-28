import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import '../widgets/app_header.dart';
import '../widgets/notifications_sheet.dart';

const String kFeedbackEndpoint =
    'https://script.google.com/macros/s/AKfycbxXZabG_5EZxjg5A9Cdp6iUScexnA1qWbEmtRCv0e04QDzrgLV1bwfZBwXnxVkFVsri/exec';
const String kFeedbackToken = 'SOARIS_FEEDBACK_TOKEN_1';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notification = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared) with notifications
            AppHeader(
              title: 'Settings',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Page content
            Expanded(
              child: Theme(
                data: theme.copyWith(
                  listTileTheme: ListTileThemeData(
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    subtitleTextStyle: const TextStyle(fontSize: 24),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  iconTheme: const IconThemeData(size: 22),
                ),
                child: ListView(
                  children: [
                    SwitchListTile(
                      title: const Text('Notification'),
                      secondary: const Icon(Icons.notifications),
                      value: notification,
                      onChanged: (bool value) {
                        setState(() {
                          notification = value;
                        });
                      },
                    ),

                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share App'),
                      onTap: () {
                        Share.share(
                          'Check out SOARIS (coming soon)!',
                          subject: 'SOARIS',
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        // Add privacy policy logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Terms and Conditions'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TermsPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mail),
                      title: const Text('Contact'),
                      onTap: () {
                        // Add contact logic
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.feedback),
                      title: const Text('Feedback'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const FeedbackPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Changelog (v1.0.1)'),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Changelog – Version 1.0.1'),
                            content: const SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This release includes the following updates:',
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '• Auto / Manual flight mode separation for mapping and manual controls.',
                                  ),
                                  Text(
                                    '• Expanded mapping view with full-screen map, X close button, and in-map Cancel Mapping.',
                                  ),
                                  Text(
                                    '• Mapping completion dialog that appears when mapping and analysis finish.',
                                  ),
                                  Text(
                                    '• Summary button now requires mapping to be finished and shows a helpful reminder dialog otherwise.',
                                  ),
                                  Text(
                                    '• Soil Monitoring summary view now includes a Next Action recommendation card (irrigate / wait).',
                                  ),
                                  Text(
                                    '• Improved bottom sheets and map interaction (tap to expand, non-scrollable when expanded).',
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '• Removed the Soil pH Level stat card from the Home dashboard.',
                                  ),
                                  Text(
                                    '• Removed the pH column from Soil Monitoring and Manual Controls tables.',
                                  ),
                                  Text(
                                    '• Updated Soil Monitoring and Manual Controls tables to stretch full-width with aligned columns (no side whitespace).',
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
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

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your feedback before submitting.'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final endpoint = kFeedbackEndpoint.trim();
      if (endpoint.isNotEmpty) {
        final uri = Uri.parse(endpoint);
        final resp = await http
            .post(
              uri,
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode({
                'message': text,
                'app': 'SOARIS',
                'sentAt': DateTime.now().toIso8601String(),
                'token': kFeedbackToken,
              }),
            )
            .timeout(const Duration(seconds: 20));

        // Debug logs (visible in debug console)
        // ignore: avoid_print
        print('Feedback POST status: ${resp.statusCode}');
        // ignore: avoid_print
        print('Feedback POST body: ${resp.body}');

        // Treat 2xx and 3xx as success (Apps Script may redirect)
        if (resp.statusCode >= 200 && resp.statusCode < 400) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks! Your feedback was sent.')),
          );
          Navigator.of(context).maybePop();
          return;
        }
        // If server responded but not success, fall through to email fallback
      }

      // Fallback to email composer
      final mailUri = Uri(
        scheme: 'mailto',
        path: 'kylesabatin9999@gmail.com,kenjielagaras1@gmail.com',
        queryParameters: <String, String>{
          'subject': 'SOARIS Feedback',
          'body': text,
        },
      );
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unable to send'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('No mail app found. Please email your feedback to:'),
                SizedBox(height: 8),
                SelectableText(
                  'kylesabatin9999@gmail.com\nkenjielagaras1@gmail.com',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(
                      text:
                          'kylesabatin9999@gmail.com, kenjielagaras1@gmail.com',
                    ),
                  );
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email addresses copied')),
                  );
                },
                child: const Text('COPY EMAIL'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIVE US FEEDBACK'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Tell us what you think...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Text(
            'Last updated: [Date]\n\n'
            '1. Acceptance of Terms\n'
            'By downloading, installing, or using SOARIS by [Company/Team Name] ("we", "us"), you agree to these Terms. If you do not agree, do not use the App.\n\n'
            '2. Eligibility and Legal Use\n'
            'You represent that you are legally permitted to use the App and will comply with applicable laws, regulations, and policies, including aviation and privacy laws in your jurisdiction.\n\n'
            '3. Account and Security\n'
            'You are responsible for safeguarding your account credentials and all activities under your account. Notify us immediately of any unauthorized use.\n\n'
            '4. License\n'
            'We grant you a limited, non-exclusive, non-transferable license to use the App for its intended purpose. You may not copy, modify, reverse engineer, or distribute the App except as permitted by law.\n\n'
            '5. Prohibited Uses\n'
            '- Use the App for unlawful, unsafe, or harmful activities.\n'
            '- Interfere with or disrupt networks, services, or equipment.\n'
            '- Bypass or disable security features.\n'
            '- Use the App to control or operate aircraft beyond your competence, certification, or legal allowances.\n\n'
            '6. Flight Safety and Regulatory Compliance\n'
            'You are solely responsible for safe operation and compliance with all applicable aviation rules (e.g., airspace restrictions, VLOS/BVLOS rules, registration, operational limits, and local no-fly zones). The App may provide information, but you must verify and exercise independent judgment. Do not rely on the App as your sole source of navigation or safety information.\n\n'
            '7. No Professional Advice\n'
            'Information in the App is for general informational purposes only and does not constitute legal, regulatory, or operational advice.\n\n'
            '8. Third-Party Services and Data\n'
            'The App may display or rely on third-party content, APIs, or services. We do not control and are not responsible for third-party materials. Your use may be subject to third-party terms.\n\n'
            '9. Subscriptions, Payments, and Refunds\n'
            'If you purchase a subscription or in-app product, fees, renewals, trials, and cancellation terms are described at purchase. Except where required by law, payments are non-refundable.\n\n'
            '10. User Content\n'
            'You retain ownership of content you submit (e.g., logs, images) and grant us a non-exclusive license to use it to operate and improve the App, per our Privacy Policy.\n\n'
            '11. Intellectual Property\n'
            'All rights in the App and related materials are owned by us or our licensors. No rights are granted except as expressly stated.\n\n'
            '12. Disclaimers\n'
            'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED.\n\n'
            '13. Limitation of Liability\n'
            'TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE WILL NOT BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES. OUR TOTAL LIABILITY WILL NOT EXCEED THE AMOUNT YOU PAID IN THE 12 MONTHS BEFORE THE CLAIM (OR USD \$0 IF NONE).\n\n'
            '14. Indemnification\n'
            'You agree to defend, indemnify, and hold us harmless from claims arising from your use of the App, violation of these Terms, or infringement of any rights.\n\n'
            '15. Termination\n'
            'We may suspend or terminate access to the App at any time. Upon termination, your license ends.\n\n'
            '16. Changes to Terms\n'
            'We may update these Terms from time to time. Continued use after changes become effective constitutes acceptance.\n\n'
            '17. Governing Law\n'
            'These Terms are governed by the laws of [Jurisdiction]. Venue for disputes will be the courts located in [City/Region].\n\n'
            '18. Contact\n'
            '[Company/Team Name]\n'
            '[Address or City/Region]\n'
            'Email: kenjielagaras1@gmail.com',
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
