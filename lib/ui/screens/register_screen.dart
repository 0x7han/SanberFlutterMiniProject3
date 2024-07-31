import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanber_flutter_mini_project_3/logic/auth_bloc/auth_bloc.dart';
import 'package:sanber_flutter_mini_project_3/ui/widgets/custom_text_field_widget.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _selectedPhoto;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedPhoto = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        color: colorScheme.primaryContainer.withOpacity(0.4),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: colorScheme.primary.withOpacity(0.5),
                    size: 32,
                  ),
                  Text(
                    'Rpedia',
                    style: textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldWidget(
                            prefixIcon: const Icon(Icons.person),
                            textEditingController: fullNameController,
                            hintText: 'Full Name',
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.upload_outlined),
                            label: Text(
                              _selectedPhoto != null
                                  ? _selectedPhoto!.path
                                  : 'Upload',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTextFieldWidget(
                      prefixIcon: const Icon(Icons.email),
                      textEditingController: emailController,
                      hintText: 'Email',
                    ),
                    CustomTextFieldWidget(
                      isPassword: true,
                      prefixIcon: const Icon(Icons.key),
                      textEditingController: passwordController,
                      hintText: 'Password',
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(SignUpRequest(
                        email: emailController.text,
                        password: passwordController.text,
                        fullname: fullNameController.text,
                        photo: _selectedPhoto,
                      ));
                  Navigator.pop(context);
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
                    'Register',
                    style: textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
