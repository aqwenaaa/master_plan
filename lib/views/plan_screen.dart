// lib/screens/plan_screen.dart
import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Langkah 10: ScrollController (boleh tanpa listener unfocus)
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final planNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan Aqueena Regita')),
      // Langkah 8: ValueListenableBuilder membangun UI dari plan terkini
      body: ValueListenableBuilder<Plan>(
        valueListenable: planNotifier,
        builder: (context, plan, child) {
          return Column(
            children: [
              Expanded(child: _buildList(plan)), // Langkah 7
              SafeArea( // Langkah 9
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(plan.completenessMessage),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context), // Langkah 5
    );
  }

  // Langkah 5: pakai provider untuk menambah Task
  Widget _buildAddTaskButton(BuildContext context) {
    final planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        final current = planNotifier.value;
        planNotifier.value = Plan(
          name: current.name,
          tasks: List<Task>.from(current.tasks)..add(const Task()),
        );
      },
    );
  }

  // Langkah 7: _buildList menerima Plan
  Widget _buildList(Plan plan) {
    if (plan.tasks.isEmpty) {
      return const Center(
        child: Text('Belum ada rencana. Ketuk tombol + untuk menambah.'),
      );
    }

    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior:
          Theme.of(context).platform == TargetPlatform.iOS
              ? ScrollViewKeyboardDismissBehavior.onDrag
              : ScrollViewKeyboardDismissBehavior.manual,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) {
        final task = plan.tasks[index];
        return _buildTaskTile(task, index, context); // Langkah 6
      },
    );
  }

  // Langkah 6: setiap baris task dimutasi via provider
  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    final planNotifier = PlanProvider.of(context);
    final fieldKey = ValueKey('task-field-$index'); // key stabil

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (checked) {
          final current = planNotifier.value;
          final newTasks = List<Task>.from(current.tasks);
          newTasks[index] = Task(
            description: task.description,
            complete: checked ?? false,
          );
          planNotifier.value = Plan(name: current.name, tasks: newTasks);
        },
      ),
      title: TextFormField(
        key: fieldKey,
        initialValue: task.description,
        decoration: const InputDecoration(
          hintText: 'Tulis nama rencana…',
          border: InputBorder.none,
        ),
        style: TextStyle(
          decoration: task.complete ? TextDecoration.lineThrough : null,
          color: task.complete ? Colors.grey : null,
        ),
        onChanged: (text) {
          final current = planNotifier.value;
          final newTasks = List<Task>.from(current.tasks);
          newTasks[index] = Task(
            description: text,
            complete: task.complete,
          );
          planNotifier.value = Plan(name: current.name, tasks: newTasks);
        },
      ),
      trailing: IconButton(
        tooltip: 'Hapus',
        icon: const Icon(Icons.close),
        onPressed: () {
          final current = planNotifier.value;
          final newTasks = List<Task>.from(current.tasks)..removeAt(index);
          planNotifier.value = Plan(name: current.name, tasks: newTasks);
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
