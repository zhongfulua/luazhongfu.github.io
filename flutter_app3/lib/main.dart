import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用于限制只能输入数字
import 'package:intl/intl.dart';        // 用于格式化日期和显示月份

void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insurance Staff App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // 使用现代 UI 风格
      ),
      home: const LoginPage(),
    );
  }
}

// --- 1. 登录页面 (精装版) ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 50),
              _buildModernTextField("Username"),
              const SizedBox(height: 30),
              _buildModernTextField("Password", isObscure: true),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: const Color(0xFF6C63FF),
                    onChanged: (value) => setState(() => _rememberMe = value!),
                  ),
                  const Text("Remember Me", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(String hint, {bool isObscure = false}) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6C63FF), width: 2)),
      ),
    );
  }
}

// --- 2. 底部导航栏结构 ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CaseSubmissionPage(),
    const Center(child: Text('Search Page')),
    const Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, color: Colors.deepPurple), label: 'Case'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.red), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- 3. 首页：排行榜 (带 Logout) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Logout", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(currentMonth, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumItem("Agent B", "2", 100, Colors.grey[400]!),
              _buildPodiumItem("Agent A", "1", 140, Colors.orangeAccent),
              _buildPodiumItem("Agent C", "3", 80, Colors.brown[300]!),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                int rank = index + 4;
                return ListTile(
                  leading: CircleAvatar(child: Text("$rank")),
                  title: Text("Agent $rank"),
                  trailing: const Icon(Icons.trending_up, color: Colors.green),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(String name, String rank, double height, Color color) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.person, size: 30, color: Colors.grey),
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
          child: Center(child: Text(rank, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }
}

// --- 4. Case 提交主页 (移除浅色背景) ---
class CaseSubmissionPage extends StatelessWidget {
  const CaseSubmissionPage({super.key});

  void _showCreateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const CreateCaseForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 确保背景是纯白
      appBar: AppBar(title: const Text("Case Submission")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _showCreateDialog(context),
          icon: const Icon(Icons.add_circle, color: Colors.white),
          label: const Text("Create new case"), 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ),
    );
  }
}

// --- 5. 创建弹窗表单 ---
class CreateCaseForm extends StatefulWidget {
  const CreateCaseForm({super.key});
  @override
  State<CreateCaseForm> createState() => _CreateCaseFormState();
}

class _CreateCaseFormState extends State<CreateCaseForm> {
  DateTime? _dateSubmission;
  DateTime? _dateInForce;

  Future<void> _pickDate(bool isSubmission) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => isSubmission ? _dateSubmission = picked : _dateInForce = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // 避开键盘
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text("Case Submission", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const Divider(),
          _buildFieldLabel("Policy Number"),
          _buildTextField("Enter Policy Number"),
          _buildFieldLabel("Annual Premium (ANP)"),
          _buildTextField("RM0.00", isNumeric: true),
          _buildFieldLabel("Date of Submission"),
          _buildDateTile(_dateSubmission, () => _pickDate(true)),
          _buildFieldLabel("In Force Date"),
          _buildDateTile(_dateInForce, () => _pickDate(false)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Submit Case", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(padding: const EdgeInsets.only(top: 15, bottom: 5), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _buildTextField(String hint, {bool isNumeric = false}) {
    return TextField(
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDateTile(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(date)),
            const Icon(Icons.calendar_today, color: Colors.grey, size: 22), // 换回简洁图标
          ],
        ),
      ),
    );
  }
}