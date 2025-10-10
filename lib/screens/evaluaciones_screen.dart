// lib/screens/evaluaciones_screen.dart

import 'package:flutter/material.dart';
import '../models/evaluation.dart';

// NUEVO: Un enum para manejar los estados del filtro de forma clara.
enum FilterType { all, pending, completed }

class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({super.key});

  @override
  State<EvaluacionesScreen> createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  // MODIFICADO: La lista original ahora es final, nunca la modificaremos directamente.
  final List<Evaluation> _allEvaluations = [
    Evaluation(
      title: 'Control N°1 - Cálculo',
      dueDate: DateTime(2025, 10, 8),
      isDone: true,
    ),
    Evaluation(
      title: 'Evaluación Sumativa N°2',
      dueDate: DateTime.now(),
      isDone: false,
    ),
    Evaluation(
      title: 'Avance Portafolio',
      dueDate: DateTime(2025, 10, 17),
      isDone: false,
    ),
    Evaluation(
      title: 'Proyecto de Redes',
      dueDate: DateTime(2025, 9, 30),
      isDone: false,
    ),
    Evaluation(
      title: 'Certamen de Programación',
      dueDate: DateTime(2025, 10, 24),
      isDone: false,
    ),
    Evaluation(
      title: 'Taller de IoT',
      dueDate: DateTime(2025, 10, 5),
      isDone: true,
    ),
  ];

  // NUEVO: Variables de estado para manejar los filtros y la lista que se muestra.
  late List<Evaluation> _filteredEvaluations;
  FilterType _selectedFilter = FilterType.all;

  // NUEVO: Este método se ejecuta una sola vez al iniciar la pantalla.
  @override
  void initState() {
    super.initState();
    // Al principio, la lista filtrada es igual a la lista completa.
    _filteredEvaluations = _allEvaluations;
  }

  // NUEVO: Lógica para filtrar la lista de evaluaciones.
  void _applyFilter(FilterType filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == FilterType.all) {
        _filteredEvaluations = _allEvaluations;
      } else if (filter == FilterType.pending) {
        _filteredEvaluations = _allEvaluations.where((e) => !e.isDone).toList();
      } else if (filter == FilterType.completed) {
        _filteredEvaluations = _allEvaluations.where((e) => e.isDone).toList();
      }
    });
  }

  // NUEVO: Función para mostrar el modal de "Nueva Evaluación".
  void _showNewEvaluationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que el modal ocupe más espacio y no sea tapado por el teclado
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // Esto evita que el teclado tape el formulario
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nueva Evaluación',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              // Formulario para cumplir con la validación del título
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Cierra el modal
                },
                child: const Text('Crear'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Evaluaciones'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar evaluación...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // chips funcionales.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text('Todas'),
                  selected: _selectedFilter == FilterType.all,
                  onSelected: (selected) => _applyFilter(FilterType.all),
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.3),
                ),
                FilterChip(
                  label: const Text('Pendientes'),
                  selected: _selectedFilter == FilterType.pending,
                  onSelected: (selected) => _applyFilter(FilterType.pending),
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.3),
                ),
                FilterChip(
                  label: const Text('Completadas'),
                  selected: _selectedFilter == FilterType.completed,
                  onSelected: (selected) => _applyFilter(FilterType.completed),
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Expanded(
            // ListView usa la lista filtrada.
            child: ListView.builder(
              itemCount: _filteredEvaluations.length,
              itemBuilder: (context, index) {
                final evaluation = _filteredEvaluations[index];
                final isOverdue =
                    !evaluation.isDone &&
                    evaluation.dueDate.isBefore(
                      DateTime.now().subtract(const Duration(days: 1)),
                    );

                Icon leadingIcon;
                Color tileColor = Colors.white;
                TextStyle titleStyle = const TextStyle();

                if (evaluation.isDone) {
                  leadingIcon = Icon(
                    Icons.check_circle,
                    color: Colors.green[700],
                  );
                  titleStyle = const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  );
                } else if (isOverdue) {
                  leadingIcon = Icon(Icons.warning, color: Colors.orange[800]);
                  tileColor = Colors.orange.shade50;
                } else {
                  leadingIcon = const Icon(Icons.schedule, color: Colors.blue);
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  elevation: 2,
                  color: tileColor,
                  child: ListTile(
                    leading: leadingIcon,
                    title: Text(evaluation.title, style: titleStyle),
                    subtitle: Text(
                      'Entrega: ${evaluation.dueDate.day}/${evaluation.dueDate.month}/${evaluation.dueDate.year}',
                    ),
                    trailing: Checkbox(
                      value: evaluation.isDone,
                      onChanged: (bool? value) {
                        // Lógica funcional para la próxima entrega
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // El botón llama a la función para mostrar el modal.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewEvaluationModal(context),
        label: const Text('Nueva'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
