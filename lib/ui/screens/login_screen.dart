import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/auth_bloc/auth_bloc.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/product_screen.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/register_screen.dart';
import 'package:sanber_flutter_mini_project_3/ui/widgets/custom_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sanber Mini Project 3'),
              Text(
                'Raihan Rabbani',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: const Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Text(
                'Requirements : ',
                style: TextStyle(fontWeight: FontWeight.bold, height: 2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Firebase auth (login, register, autologin)'),
                  Text('2. Migrate product data from API to cloud firestore'),
                  Text('3. Migrate cart data from API to cloud firestore'),
                  Text('4. Profile data fetch from storage based on auth'),
                  Text('5. Has push notif (remote) and local notif'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok')),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration.zero, () => _dialogBuilder(context));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Authenticated as ${state.uid}')),
            );
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen()));
          }
        },
        child: Container(
          alignment: Alignment.center,
          color: colorScheme.primaryContainer.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: colorScheme.primary.withOpacity(0.5),
                    size: 64,
                  ),
                  Text(
                    'Rpedia',
                    style: textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    CustomTextFieldWidget(
                        prefixIcon: const Icon(Icons.person),
                        textEditingController: emailController,
                        hintText: 'Email'),
                    CustomTextFieldWidget(
                        isPassword: true,
                        prefixIcon: const Icon(Icons.key),
                        textEditingController: passwordController,
                        hintText: 'Password'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
context.read<AuthBloc>().add(SignInRequest(email: emailController.text, password: passwordController.text));
                  
                },
                child: Container(
                  width: 340,
                  height: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Login',
                    style: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
