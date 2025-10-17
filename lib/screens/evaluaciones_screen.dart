// lib/screens/evaluaciones_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/evaluation.dart';
import '../models/subject.dart';
import './subjects_screen.dart';

const uuid = Uuid();

enum FilterType { all, pending, completed }

class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({super.key});

  @override
  State<EvaluacionesScreen> createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen> {
  // --- DATOS DE LA APLICACIÓN ---
  final List<Subject> _availableSubjects = [
    Subject(id: 's1', name: 'Cálculo I'),
    Subject(id: 's2', name: 'Programación de Apps Móviles'),
    Subject(id: 's3', name: 'Redes de Datos'),
  ];

  final List<Evaluation> _allEvaluations = [
    Evaluation(
      id: uuid.v4(),
      title: 'Control N°1',
      dueDate: DateTime(2025, 10, 8),
      isDone: true,
      subjectId: 's1',
      subjectName: 'Cálculo I',
    ),
    Evaluation(
      id: uuid.v4(),
      title: 'Avance Portafolio App',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isDone: false,
      subjectId: 's2',
      subjectName: 'Programación de Apps Móviles',
    ),
    Evaluation(
      id: uuid.v4(),
      title: 'Proyecto de Redes',
      dueDate: DateTime(2025, 9, 30),
      isDone: false,
      subjectId: 's3',
      subjectName: 'Redes de Datos',
    ),
  ];

  // --- ESTADO DE LA UI Y FILTROS ---
  List<Evaluation> _filteredEvaluations = [];
  String _searchQuery = '';
  FilterType _selectedStatusFilter = FilterType.all;
  String? _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    _runFilter();
  }

  // --- LÓGICA DE MANEJO DE DATOS (CRUD) ---

  void _addEvaluation(String title, DateTime dueDate, Subject subject) {
    final newEvaluation = Evaluation(
      id: uuid.v4(),
      title: title,
      dueDate: dueDate,
      subjectId: subject.id,
      subjectName: subject.name,
    );
    setState(() {
      _allEvaluations.add(newEvaluation);
    });
    _runFilter();
  }

  void _toggleEvaluationStatus(Evaluation evaluation, bool? isDone) {
    setState(() {
      final index = _allEvaluations.indexWhere((e) => e.id == evaluation.id);
      if (index != -1) {
        _allEvaluations[index].isDone = isDone ?? false;
      }
    });
    _runFilter();
  }

  void _removeEvaluation(String id) {
    final removedIndex = _allEvaluations.indexWhere((e) => e.id == id);
    if (removedIndex == -1) return;
    final removedEvaluation = _allEvaluations[removedIndex];

    setState(() {
      _allEvaluations.removeAt(removedIndex);
    });
    _runFilter();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Evaluación eliminada.'),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            setState(() {
              _allEvaluations.insert(removedIndex, removedEvaluation);
            });
            _runFilter();
          },
        ),
      ),
    );
  }

  void _addSubject(Subject subject) {
    setState(() {
      _availableSubjects.add(subject);
    });
  }

  bool _removeSubject(String subjectId) {
    final hasEvaluations =
        _allEvaluations.any((eval) => eval.subjectId == subjectId);

    if (hasEvaluations) {
      return false; // No se pudo eliminar
    }

    setState(() {
      _availableSubjects.removeWhere((sub) => sub.id == subjectId);
    });
    return true; // Se eliminó con éxito
  }

  // --- LÓGICA DE FILTRADO Y BÚSQUEDA ---

  void _runFilter() {
    List<Evaluation> results = List.from(_allEvaluations);

    if (_selectedStatusFilter == FilterType.pending) {
      results = results.where((e) => !e.isDone).toList();
    } else if (_selectedStatusFilter == FilterType.completed) {
      results = results.where((e) => e.isDone).toList();
    }

    if (_selectedSubjectId != null) {
      results =
          results.where((e) => e.subjectId == _selectedSubjectId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      results = results
          .where(
              (e) => e.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    results.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return a.dueDate.compareTo(b.dueDate);
    });

    setState(() {
      _filteredEvaluations = results;
    });
  }

  // --- NAVEGACIÓN Y MODALES ---

  void _navigateToSubjects() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => SubjectsScreen(
        subjects: _availableSubjects,
        onAddSubject: _addSubject,
        onRemoveSubject: _removeSubject,
      ),
    ));
    // Actualiza la UI cuando se regresa de la pantalla de asignaturas
    setState(() {});
    _runFilter();
  }

  void _showNewEvaluationModal() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    DateTime? selectedDate;
    Subject? selectedSubject;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Nueva Evaluación',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                      autofocus: true,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'El título es obligatorio.'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Subject>(
                      value: selectedSubject,
                      hint: const Text('Seleccionar Asignatura'),
                      items: _availableSubjects
                          .map((subject) => DropdownMenuItem(
                              value: subject, child: Text(subject.name)))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedSubject = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione una asignatura.' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Text(selectedDate == null
                                ? 'Sin fecha seleccionada'
                                : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}')),
                        TextButton.icon(
                          onPressed: () async {
                            final now = DateTime.now();
                            final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: DateTime(now.year + 5));
                            if (pickedDate != null) {
                              setModalState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Elegir'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Por favor, seleccione una fecha.')));
                            return;
                          }
                          _addEvaluation(titleController.text, selectedDate!,
                              selectedSubject!);
                          Navigator.of(ctx).pop();
                        }
                      },
                      child: const Text('Crear'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Evaluaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.topic_outlined),
            tooltip: 'Gestionar Asignaturas',
            onPressed: _navigateToSubjects,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _runFilter();
              },
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text('Filtros: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                FilterChip(
                  label: const Text('Todas'),
                  selected: _selectedStatusFilter == FilterType.all,
                  onSelected: (sel) {
                    _selectedStatusFilter = FilterType.all;
                    _runFilter();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pendientes'),
                  selected: _selectedStatusFilter == FilterType.pending,
                  onSelected: (sel) {
                    _selectedStatusFilter = FilterType.pending;
                    _runFilter();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Completadas'),
                  selected: _selectedStatusFilter == FilterType.completed,
                  onSelected: (sel) {
                    _selectedStatusFilter = FilterType.completed;
                    _runFilter();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredEvaluations.isEmpty
                ? const Center(child: Text('No se encontraron evaluaciones.'))
                : ListView.builder(
                    itemCount: _filteredEvaluations.length,
                    itemBuilder: (context, index) {
                      final evaluation = _filteredEvaluations[index];
                      final isOverdue = !evaluation.isDone &&
                          evaluation.dueDate.isBefore(
                              DateTime.now().subtract(const Duration(days: 1)));

                      return Dismissible(
                        key: ValueKey(evaluation.id),
                        onDismissed: (_) => _removeEvaluation(evaluation.id),
                        background: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.75),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          color: isOverdue ? Colors.orange.shade50 : null,
                          child: ListTile(
                            leading: Icon(
                              evaluation.isDone
                                  ? Icons.check_circle
                                  : (isOverdue
                                      ? Icons.warning_amber_rounded
                                      : Icons.schedule),
                              color: evaluation.isDone
                                  ? Colors.green[700]
                                  : (isOverdue
                                      ? Colors.orange[800]
                                      : Colors.blue),
                            ),
                            title: Text(evaluation.title,
                                style: TextStyle(
                                    decoration: evaluation.isDone
                                        ? TextDecoration.lineThrough
                                        : null)),
                            subtitle: Text(
                                '${evaluation.subjectName} - Entrega: ${DateFormat('dd/MM/yyyy').format(evaluation.dueDate)}'),
                            trailing: Checkbox(
                              value: evaluation.isDone,
                              onChanged: (value) =>
                                  _toggleEvaluationStatus(evaluation, value),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewEvaluationModal,
        label: const Text('Nueva'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
