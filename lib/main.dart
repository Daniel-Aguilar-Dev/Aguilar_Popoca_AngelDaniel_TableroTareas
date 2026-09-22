import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista viva DMI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ListaVivaPage(title: 'Equipo 10B — Tareas'),
    );
  }
}
class ListaVivaPage extends StatefulWidget {
  const ListaVivaPage({super.key, required this.title});

  final String title;

  @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage> {
  final List<String> _tareas = ['Tarea 1', 'Tarea 2', 'Tarea 3', 'Tarea 4', 'Tarea 5'];
  final List<bool> _estado = [false, false, false, false, false];
  bool _switchPendientes = false;

  void _cambiarEstado(int index) {
    setState(() {
      _estado[index] = !_estado[index];
    });
  }

  void _eliminarTarea(int index){
    setState(() {
      _tareas.removeAt(index);
      _estado.removeAt(index);
    });
  }

  void _agregar() {
    setState(() {
      _tareas.add('Tarea ${_tareas.length + 1}');
      _estado.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int completadas = _estado.where((item) => item == true).length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: ${completadas} / ${_tareas.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  'Solo pendientes:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                    value: _switchPendientes,
                    onChanged: (bool value) {
                      setState(() {
                        _switchPendientes = value;
                      });
                    })
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                if(_switchPendientes && _estado[index]){
                  return const SizedBox.shrink();
                }
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: _estado[index],
                      onChanged: (bool? value){
                        _cambiarEstado(index);
                      },
                    ),
                    title: Text(_tareas[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Eliminar',
                          onPressed: () => _eliminarTarea(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_task),
        label: const Text('Agregar'),
      ),
    );
  }
}