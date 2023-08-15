import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_bloc/constant/enums.dart';
import 'package:practice_bloc/todo_feature/logic/bloc/bloc/todo_bloc.dart';
import 'package:practice_bloc/todo_feature/model/todo_model.dart';
import 'package:practice_bloc/tools/media_query.dart';
import 'package:practice_bloc/tools/responsive.dart';
import 'package:practice_bloc/tools/theme/colors.dart';

class FilterModalWidget extends StatelessWidget {
  const FilterModalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final helper = context.read<TodoBloc>();
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(context, 0.05),
          vertical: getWidth(context, 0.02)),
      width: getAllWidth(context),
      height: Responsive.isMobile(context) ? 370 : 470,
      child: Column(
        children: [
          Text(
            'بر اساس',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'adobe_arabic',
              fontSize: 30,
            ),
          ),
          ListTileWidget(
            title: 'تاریخ ثبت',
            function: () =>
                helper.add(SortTasksTodoTask(sort: Sort.sortBySubmitDate)),
          ),
          const Divider(thickness: 4, color: Colors.amber),
          ListTileWidget(
            title: 'تاریخ انجام',
            function: () =>
                helper.add(SortTasksTodoTask(sort: Sort.sortByGoalDate)),
          ),
          const Divider(thickness: 4, color: Colors.amber),
          ListTileWidget(
            title: 'انجام شده ها',
            function: () =>
                helper.add(SortTasksTodoTask(sort: Sort.sortByIsDone)),
          ),
          const Divider(thickness: 4, color: Colors.amber),
          ListTileWidget(
            title: 'انجام نشده ها',
            function: () =>
                helper.add(SortTasksTodoTask(sort: Sort.sortByIsNotDone)),
          ),
          const DeleteAllButton(),
        ],
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget(
      {super.key, required this.title, required this.function});

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'nasim',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onTap: () {
        function();
        Navigator.pop(context);
      },
    );
  }
}

class DeleteAllButton extends StatelessWidget {
  const DeleteAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state.todoEvent is CompletedTodoEvent) {
          final theme = Theme.of(context);
          final CompletedTodoEvent event =
              state.todoEvent as CompletedTodoEvent;
          List<TodoModel> todoModel = event.todoModel;

          return todoModel.isEmpty
              ? const SizedBox.shrink()
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: Size(getAllWidth(context),
                        Responsive.isMobile(context) ? 45 : 75),
                  ),
                  onPressed: () {
                    context.read<TodoBloc>().add(DeleteAllTaskEvent());
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: Text(
                    'حذف وظایف',
                    style: theme.textTheme.titleSmall,
                  ),
                );
        }
        return Container();
      },
    );
  }
}
