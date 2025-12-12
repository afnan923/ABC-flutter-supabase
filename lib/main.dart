import 'package:flutter/material.dart';
import 'package:supabase_latihan/pages/home_page.dart';

const supabaseUrl = 'https://piyschaksdqngqyruikm.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpeXNjaGFrc2RxbmdxeXJ1aWttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzNzA3NjMsImV4cCI6MjA4MDk0Njc2M30.fTbO23V1p2BxRzqObQ3vuVZ98m9D28QudcQ1NBcpjd0';
Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase App',
      home: const HomePage(),
    );
  }
}
