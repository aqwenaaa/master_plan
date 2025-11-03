import 'package:flutter/material.dart';
import '../models/data_layer.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Langkah 6: state utama
  Plan plan = const Plan();

  // Langkah 10: ScrollController (tanpa listener unfocus otomatis)
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ganti dengan nama panggilan Anda
      appBar: AppBar(title: const Text('Master Plan Aqueena Regita')),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  // Langkah 7: tombol tambah task
  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          plan = Plan(
            name: plan.name,
            tasks: List<Task>.from(plan.tasks)..add(const Task()),
          );
        });
      },
    );
  }

  // Langkah 8 + 12: ListView dengan controller & keyboardDismissBehavior
  Widget _buildList() {
    if (plan.tasks.isEmpty) {
      return const Center(
        child: Text('Belum ada rencana. Ketuk tombol + untuk menambah.'),
      );
    }

    // Jika ingin paksa tutup keyboard saat user benar-benar drag,
    // bisa dibalut NotificationListener<UserScrollNotification>.
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
        return _buildTaskTile(task, index);
      },
    );
  }

  // Langkah 9: setiap baris task dapat diedit & dicentang
  Widget _buildTaskTile(Task task, int index) {
    // KEY HARUS STABIL — jangan masukkan description/complete
    final fieldKey = ValueKey('task-field-$index');

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (checked) {
          _updateTaskAt(
            index,
            Task(
              description: task.description,
              complete: checked ?? false,
            ),
          );
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
          _updateTaskAt(
            index,
            Task(
              description: text,
              complete: task.complete,
            ),
          );
        },
      ),
      trailing: IconButton(
        tooltip: 'Hapus',
        icon: const Icon(Icons.close),
        onPressed: () => _removeTaskAt(index),
      ),
    );
  }

  // Helper immutable update
  void _updateTaskAt(int index, Task newTask) {
    setState(() {
      final newTasks = List<Task>.from(plan.tasks);
      newTasks[index] = newTask;
      plan = Plan(name: plan.name, tasks: newTasks);
    });
  }

  void _removeTaskAt(int index) {
    setState(() {
      final newTasks = List<Task>.from(plan.tasks)..removeAt(index);
      plan = Plan(name: plan.name, tasks: newTasks);
    });
  }

  // Langkah 13: bebaskan controller
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
