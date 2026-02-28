import 'package:flutter/material.dart';
import '../services/paciente_service.dart';
import '../models/paciente.dart';
import 'registro_paciente_screen.dart';
import 'detalle_paciente_screen.dart';

class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({super.key});

  @override
  State<ListaPacientesScreen> createState() =>
      _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  String busqueda = "";

  @override
  Widget build(BuildContext context) {
    List<Paciente> pacientes =
        PacienteService.obtenerPacientes()
            .where((p) =>
                p.nombres.toLowerCase().contains(busqueda.toLowerCase()) ||
                p.apellidos.toLowerCase().contains(busqueda.toLowerCase()) ||
                p.numeroDocumento.contains(busqueda))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Pacientes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegistroPacienteScreen(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔎 BUSCADOR
            TextField(
              decoration: const InputDecoration(
                labelText: "Buscar por nombre, apellido o documento",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  busqueda = value;
                });
              },
            ),

            const SizedBox(height: 20),

            /// 📋 LISTA
            Expanded(
              child: pacientes.isEmpty
                  ? const Center(
                      child: Text("No hay pacientes registrados"),
                    )
                  : ListView.builder(
                      itemCount: pacientes.length,
                      itemBuilder: (context, index) {
                        final paciente = pacientes[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              "${paciente.nombres} ${paciente.apellidos}",
                            ),
                            subtitle: Text(
                              "Doc: ${paciente.numeroDocumento}",
                            ),

                            /// 🌩 Estado sincronización
                            leading: Icon(
                              paciente.sincronizado
                                  ? Icons.cloud_done
                                  : Icons.cloud_off,
                              color: paciente.sincronizado
                                  ? Colors.green
                                  : Colors.red,
                            ),

                            /// ✏️ Botón editar separado
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RegistroPacienteScreen(
                                      paciente: paciente,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),

                            /// 👁 Tap principal = Detalle clínico
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetallePacienteScreen(
                                    paciente: paciente,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}