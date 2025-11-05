import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true; // Track password visibility

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: deviceWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'WelCome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: deviceWidth * 0.5,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.blueGrey],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/App_Launcher.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: deviceWidth * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          const Text('Authorized persons only', style: TextStyle(color: Colors.white),),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w300
                              ),
                              fillColor: Colors.grey[800],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText:
                                _isPasswordObscured, // Toggle visibility
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w300
                              ),
                              fillColor: Colors.grey[800],
                              filled: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured =
                                        !_isPasswordObscured; // Toggle state
                                  });
                                },
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OR',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          'assets/icons/googlebtn.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
