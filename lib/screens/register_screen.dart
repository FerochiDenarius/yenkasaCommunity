import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isEmail = true;
  bool agreeToTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  final List<String> communities = [
    "Ayimensah","Danfa","Kweiman","Oyarifa","Abokobi","Frafraha",
    "New Legon","Adenta","Adenta NewSite","Amrahia","Oyibi",
    "Legon Campus","East Legon","Menpeasem","Ogbojo","Adjinganor",
    "Botwe","Madina Zongo Juntion","Atomic Juntion","UPSA","Bawaleshie",
    "American House","School Junction","Mataheko","Nana Krom",
    "Hatso","Taifa","Odokor","Aboso Okai"
  ];

  String? selectedCommunity;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1A1A1A); // mild black
    const accentYellow = Color(0xFFFFD54F); // warm yellow

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: accentYellow),
        title: const Text("Register",
            style: TextStyle(color: accentYellow, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔘 Email/Phone toggle
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Email",
                        style: TextStyle(color: accentYellow)),
                    value: true,
                    groupValue: isEmail,
                    onChanged: (val) => setState(() => isEmail = true),
                    activeColor: accentYellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Phone",
                        style: TextStyle(color: accentYellow)),
                    value: false,
                    groupValue: isEmail,
                    onChanged: (val) => setState(() => isEmail = false),
                    activeColor: accentYellow,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 📨 Email or 📞 Phone
            if (isEmail)
              _buildInputField(
                label: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              )
            else
              _buildInputField(
                label: "Phone Number",
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

            _buildInputField(
              label: "Username",
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),

            _buildInputField(
              label: "Location",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),
            const Text("Select Community",
                style: TextStyle(
                    color: accentYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              dropdownColor: backgroundColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: selectedCommunity,
              hint: const Text("Choose community",
                  style: TextStyle(color: Colors.white70)),
              items: communities
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c, style: const TextStyle(color: accentYellow)),
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedCommunity = val),
            ),

            const SizedBox(height: 16),
            // 🔒 Password
            _buildPasswordField(
              label: "Password",
              show: showPassword,
              onToggle: () => setState(() => showPassword = !showPassword),
            ),

            _buildPasswordField(
              label: "Confirm Password",
              show: showConfirmPassword,
              onToggle: () =>
                  setState(() => showConfirmPassword = !showConfirmPassword),
            ),

            const SizedBox(height: 16),
            // ☑️ Terms
            Row(
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (val) => setState(() => agreeToTerms = val ?? false),
                  activeColor: accentYellow,
                ),
                const Text("I agree to the",
                    style: TextStyle(color: Colors.white)),
                GestureDetector(
                  onTap: () {
                    // TODO: open terms page
                  },
                  child: const Text(
                    " User Agreement",
                    style: TextStyle(
                        color: accentYellow, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // 🟡 Register button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: agreeToTerms
                    ? () {
                  // TODO: handle registration logic
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  agreeToTerms ? accentYellow : Colors.grey.shade600,
                  foregroundColor: backgroundColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Register",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 16),
            // 🔗 Login link
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: navigate to login
                },
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(
                    color: accentYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFD54F)),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool show,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextField(
        obscureText: !show,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(show ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70),
            onPressed: onToggle,
          ),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFD54F)),
          ),
        ),
      ),
    );
  }
}
