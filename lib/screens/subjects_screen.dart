// lib/screens/subjects_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/subject.dart';

const uuid = Uuid();

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({
    super.key,
    required this.subjects,
    required this.onAddSubject,
    required this.onRemoveSubject,
  });

  final List<Subject> subjects;
  final void Function(Subject) onAddSubject;
  final bool Function(String) onRemoveSubject;

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  void _addSubject(String name) {
    final newSubject = Subject(id: uuid.v4(), name: name);
    widget.onAddSubject(newSubject);
  }

  void _confirmRemoveSubject(Subject subject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar la asignatura "${subject.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final wasRemoved = widget.onRemoveSubject(subject.id);
              Navigator.of(ctx).pop(); // Cierra el diálogo
              if (!wasRemoved && mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'No se puede eliminar: la asignatura tiene evaluaciones.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showNewSubjectModal() {
    final textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nueva Asignatura',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              autofocus: true,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la Asignatura'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  _addSubject(textController.text.trim());
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Asignaturas'),
      ),
      body: widget.subjects.isEmpty
          ? const Center(child: Text('No tienes asignaturas. ¡Añade una!'))
          : ListView.builder(
              itemCount: widget.subjects.length,
              itemBuilder: (context, index) {
                final subject = widget.subjects[index];
                return ListTile(
                  title: Text(subject.name),
                  onLongPress: () => _confirmRemoveSubject(subject),
                  trailing: const Icon(Icons.delete_forever_outlined,
                      color: Colors.grey),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewSubjectModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
