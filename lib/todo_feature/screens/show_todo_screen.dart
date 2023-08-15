import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_bloc/todo_feature/logic/bloc/bloc/todo_bloc.dart';
import 'package:practice_bloc/todo_feature/model/todo_model.dart';
import 'package:practice_bloc/todo_feature/screens/add_todo_screen.dart';
import 'package:practice_bloc/todo_feature/widget/empty_widget.dart';
import 'package:practice_bloc/todo_feature/widget/filter_widget.dart';
import 'package:practice_bloc/todo_feature/widget/show_todos_item.dart';
import 'package:practice_bloc/tools/loading_widget.dart';
import 'package:practice_bloc/tools/style/shapes.dart';
import 'package:practice_bloc/tools/theme/colors.dart';

class ShowTodoScreen extends StatefulWidget {
  const ShowTodoScreen({super.key});
  static const String screenId = '/show_todo_screen';

  @override
  State<ShowTodoScreen> createState() => _ShowTodoScreenState();
}

class _ShowTodoScreenState extends State<ShowTodoScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(FetchTaskTodoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'اضافه کردن وظیفه',
        backgroundColor: Colors.amber[700],
        onPressed: () {
          Navigator.pushNamed(context, AddTodoScreen.screenId);
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'وظایف من',
          style: TextStyle(
            fontFamily: 'adobe_arabic',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: getTopShapeWidget(20),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                backgroundColor: Colors.white,
                useSafeArea: true,
                builder: (context) {
                  return const FilterModalWidget();
                },
              );
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 35,
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todoEvent is LoadingTodoEvent) {
            return const LoadingWidget();
          }

          if (state.todoEvent is CompletedTodoEvent) {
            final CompletedTodoEvent event =
                state.todoEvent as CompletedTodoEvent;
            List<TodoModel> todoModel = event.todoModel;
            return todoModel.isEmpty
                ? const EmptyWidget()
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.pink),
                    itemCount: todoModel.length,
                    itemBuilder: (context, index) {
                      final helper = todoModel[index];
                      return ShowTodosItems(helper: helper, index: index);
                    },
                  );
          }

          return Container();
        },
      ),
    );
  }
}
