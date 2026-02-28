import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/paciente_service.dart';

class RegistroPacienteScreen extends StatefulWidget {
  final Paciente? paciente;

  const RegistroPacienteScreen({super.key, this.paciente});

  @override
  State<RegistroPacienteScreen> createState() =>
      _RegistroPacienteScreenState();
}

class _RegistroPacienteScreenState extends State<RegistroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final numeroDocumentoController = TextEditingController();
  final tallaController = TextEditingController();
  final pesoController = TextEditingController();
  final nombreAcudienteController = TextEditingController();
  final telefonoAcudienteController = TextEditingController();

  // Variables
  String tipoDocumento = "CC";
  String sexoBiologico = "Masculino";
  String etnia = "Latino";
  DateTime? fechaNacimiento;

  bool fumador = false;
  bool alcohol = false;
  bool sustancias = false;

    @override
    void initState() {
        super.initState();

        if (widget.paciente != null) {
        final p = widget.paciente!;

        nombresController.text = p.nombres;
        apellidosController.text = p.apellidos;
        numeroDocumentoController.text = p.numeroDocumento;
        tallaController.text = p.talla.toString();
        pesoController.text = p.peso?.toString() ?? "";

        tipoDocumento = p.tipoDocumento;
        sexoBiologico = p.sexoBiologico;
        etnia = p.etnia ?? "Latino";
        fechaNacimiento = p.fechaNacimiento;

        fumador = p.fumador;
        alcohol = p.alcohol;
        sustancias = p.sustancias;

        nombreAcudienteController.text = p.nombreAcudiente ?? "";
        telefonoAcudienteController.text = p.telefonoAcudiente ?? "";
        }
    }

  void mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Row(
            children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(mensaje)),
            ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
        ),
        ),
    );
    }
  void guardarPaciente() {
    if (!_formKey.currentState!.validate()) return;

    if (fechaNacimiento == null) {
        mostrarMensaje("Seleccione fecha de nacimiento", Colors.red);
        return;
    }

    final esEdicion = widget.paciente != null;

    Paciente paciente = Paciente(
        // 🔐 Mantener ID si es edición
        id: esEdicion
            ? widget.paciente!.id
            : PacienteService.generarId(),

        fechaCreacion: esEdicion
            ? widget.paciente!.fechaCreacion
            : DateTime.now(),

        sincronizado: false,
        versionApp: "1.0.0",

        // 👤 Datos clínicos
        tipoDocumento: tipoDocumento,
        numeroDocumento: numeroDocumentoController.text.trim(),
        nombres: nombresController.text.trim(),
        apellidos: apellidosController.text.trim(),
        fechaNacimiento: fechaNacimiento!,
        sexoBiologico: sexoBiologico,
        talla: double.parse(tallaController.text),
        peso: pesoController.text.isEmpty
            ? null
            : double.parse(pesoController.text),
        etnia: etnia,

        // 🧪 Factores
        fumador: fumador,
        alcohol: alcohol,
        sustancias: sustancias,

        // 👨‍👩‍👦 Acudiente
        nombreAcudiente: nombreAcudienteController.text.isEmpty
            ? null
            : nombreAcudienteController.text.trim(),
        telefonoAcudiente: telefonoAcudienteController.text.isEmpty
            ? null
            : telefonoAcudienteController.text.trim(),
    );

    if (esEdicion) {
        PacienteService.actualizarPaciente(paciente);
        mostrarMensaje("Paciente actualizado correctamente", Colors.blue);
    } else {
        PacienteService.agregarPaciente(paciente);
        mostrarMensaje("Paciente registrado correctamente", Colors.green);
    }

    Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pop(context);
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Paciente")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              /// Tipo Documento
              DropdownButtonFormField(
                value: tipoDocumento,
                items: const [
                  DropdownMenuItem(value: "CC", child: Text("Cédula")),
                  DropdownMenuItem(value: "TI", child: Text("Tarjeta Identidad")),
                  DropdownMenuItem(value: "CE", child: Text("Cédula Extranjería")),
                  DropdownMenuItem(value: "Pasaporte", child: Text("Pasaporte")),
                ],
                onChanged: (value) =>
                    setState(() => tipoDocumento = value!),
                decoration:
                    const InputDecoration(labelText: "Tipo Documento"),
              ),

              /// Número Documento
              TextFormField(
                controller: numeroDocumentoController,
                decoration:
                    const InputDecoration(labelText: "Número Documento"),
                validator: (v) =>
                    v!.isEmpty ? "Campo obligatorio" : null,
              ),

              /// Nombres
              TextFormField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: "Nombres"),
                validator: (v) =>
                    v!.isEmpty ? "Campo obligatorio" : null,
              ),

              /// Apellidos
              TextFormField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: "Apellidos"),
                validator: (v) =>
                    v!.isEmpty ? "Campo obligatorio" : null,
              ),

              /// Fecha Nacimiento
              ListTile(
                title: Text(
                  fechaNacimiento == null
                      ? "Seleccionar Fecha de Nacimiento"
                      : "Fecha: ${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaNacimiento = picked;
                    });
                  }
                },
              ),

              /// Sexo
              DropdownButtonFormField(
                value: sexoBiologico,
                items: const [
                  DropdownMenuItem(
                      value: "Masculino", child: Text("Masculino")),
                  DropdownMenuItem(
                      value: "Femenino", child: Text("Femenino")),
                ],
                onChanged: (value) =>
                    setState(() => sexoBiologico = value!),
                decoration:
                    const InputDecoration(labelText: "Sexo Biológico"),
              ),

              /// Talla
              TextFormField(
                controller: tallaController,
                decoration:
                    const InputDecoration(labelText: "Talla (cm)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Campo obligatorio" : null,
              ),

              /// Peso
              TextFormField(
                controller: pesoController,
                decoration:
                    const InputDecoration(labelText: "Peso (kg)"),
                keyboardType: TextInputType.number,
              ),

              /// Etnia
              DropdownButtonFormField(
                value: etnia,
                items: const [
                  DropdownMenuItem(
                      value: "Latino", child: Text("Latino")),
                  DropdownMenuItem(
                      value: "Afrodescendiente",
                      child: Text("Afrodescendiente")),
                  DropdownMenuItem(
                      value: "Caucásico", child: Text("Caucásico")),
                  DropdownMenuItem(
                      value: "Asiático", child: Text("Asiático")),
                ],
                onChanged: (value) =>
                    setState(() => etnia = value!),
                decoration:
                    const InputDecoration(labelText: "Etnia"),
              ),

              const SizedBox(height: 20),

              /// Factores de riesgo
              SwitchListTile(
                title: const Text("Fumador activo"),
                value: fumador,
                onChanged: (v) => setState(() => fumador = v),
              ),

              SwitchListTile(
                title: const Text("Consume alcohol"),
                value: alcohol,
                onChanged: (v) => setState(() => alcohol = v),
              ),

              SwitchListTile(
                title: const Text("Consume sustancias"),
                value: sustancias,
                onChanged: (v) => setState(() => sustancias = v),
              ),

              const SizedBox(height: 20),

              /// Acudiente
              TextFormField(
                controller: nombreAcudienteController,
                decoration:
                    const InputDecoration(labelText: "Nombre Acudiente"),
              ),

              TextFormField(
                controller: telefonoAcudienteController,
                decoration:
                    const InputDecoration(labelText: "Teléfono Acudiente"),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: guardarPaciente,
                child: Text(
                    widget.paciente == null
                    ? "Guardar Paciente"
                    : "Actualizar Paciente",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}