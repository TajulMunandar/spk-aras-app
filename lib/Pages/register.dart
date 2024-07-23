import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F1FA),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    child: Lottie.asset(
                      'assets/logo.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Register',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Register dan cari makanan dengan kebutuhan anda!',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color(0xff636973),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons
                            .verified_user, // Ganti dengan icon yang diinginkan
                        color: Color(
                            0xff9AA2AF), // Sesuaikan dengan warna ikon yang diinginkan
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors
                                .yellow.shade600), // Warna border saat terfokus
                      ),
                      hintText: 'Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: usernameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons
                            .supervised_user_circle, // Ganti dengan icon yang diinginkan
                        color: Color(
                            0xff9AA2AF), // Sesuaikan dengan warna ikon yang diinginkan
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors
                                .yellow.shade600), // Warna border saat terfokus
                      ),
                      hintText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock, // Ganti dengan ikon yang diinginkan
                        color: Color(
                            0xff9AA2AF), // Sesuaikan dengan warna ikon yang diinginkan
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors
                                .yellow.shade600), // Warna border saat terfokus
                      ),
                      hintText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: _selectedValue,
                    items:
                        <String>['Laki-laki', 'Perempuan'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.male,
                        color: Color(0xff9AA2AF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.yellow.shade600,
                        ),
                      ),
                      hintText: 'Jenis Kelamin',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        // Menambahkan padding untuk menyelaraskan hint text
                      ),
                    ),
                    isExpanded:
                        true, // Membuat dropdown field mengisi lebar yang tersedia
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    // try {
                    //   String? accessToken = await ApiService.authenticate(
                    //       usernameController.text, passwordController.text);
                    //   if (accessToken != null) {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => HomePage(),
                    //       ),
                    //     );
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text(
                    //             'Register gagal, periksa kembali username atau password Anda'),
                    //       ),
                    //     );
                    //   }
                    // } catch (e) {
                    //   print('Error: $e');

                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Register gagal, terjadi kesalahan'),
                    //     ),
                    //   );
                    // }
                    // ;
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xffffffff),
                    backgroundColor: Colors.yellow.shade600,
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ), // Tambahkan teks pada tombol
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Sudah Punya Akun? Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}