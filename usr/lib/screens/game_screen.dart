import 'dart:async';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/pet.dart';
import 'package:couldai_user_app/widgets/character_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late Pet _pet;
  Timer? _gameLoop;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _pet = Pet();
    _startGameLoop();
    
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gameLoop?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  void _startGameLoop() {
    _gameLoop = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _pet.decay();
      });
    });
  }

  void _feed() {
    setState(() {
      _pet.feed();
      _animateAction();
    });
    _showFeedback("Ñam ñam!", Colors.green);
  }

  void _play() {
    if (_pet.energy > 10) {
      setState(() {
        _pet.play();
        _animateAction();
      });
      _showFeedback("¡Juguemos!", Colors.orange);
    } else {
      _showFeedback("Estoy muy cansado...", Colors.red);
    }
  }

  void _clean() {
    setState(() {
      _pet.clean();
      _animateAction();
    });
    _showFeedback("¡Limpio!", Colors.blue);
  }

  void _sleep() {
    setState(() {
      if (_pet.isSleeping) {
        _pet.wakeUp();
        _showFeedback("¡Despierto!", Colors.yellow[800]!);
      } else {
        _pet.sleep();
        _showFeedback("Zzz...", Colors.purple);
      }
    });
  }

  void _animateAction() {
    // Simple jump effect
    _bounceController.forward(from: 0.0).then((_) => _bounceController.repeat(reverse: true));
  }

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 20, right: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4C3), // Light yellowish background
      appBar: AppBar(
        title: const Text("Mi Prepu-Pet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stats Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatIcon(Icons.fastfood, _pet.hunger, Colors.orange),
                _buildStatIcon(Icons.favorite, _pet.happiness, Colors.red),
                _buildStatIcon(Icons.bolt, _pet.energy, Colors.yellow[800]!),
                _buildStatIcon(Icons.wash, _pet.hygiene, Colors.blue),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Character Area
          Center(
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pet.isSleeping ? 0 : _bounceController.value),
                  child: Transform.translate(
                    offset: Offset(0, _pet.isSleeping ? 0 : -20 * _bounceController.value),
                    child: child,
                  ),
                );
              },
              child: CustomPaint(
                size: const Size(200, 250),
                painter: CharacterPainter(
                  happiness: _pet.happiness,
                  energy: _pet.energy,
                  isSleeping: _pet.isSleeping,
                  isDirty: _pet.isDirty,
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.restaurant, "Comer", _feed, Colors.orange),
                _buildActionButton(Icons.sports_soccer, "Jugar", _play, Colors.green),
                _buildActionButton(Icons.shower, "Limpiar", _clean, Colors.blue),
                _buildActionButton(
                  _pet.isSleeping ? Icons.wb_sunny : Icons.bedtime, 
                  _pet.isSleeping ? "Despertar" : "Dormir", 
                  _sleep, 
                  Colors.purple
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, double value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: color,
          heroTag: label,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
