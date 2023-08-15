import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:practice_bloc/todo_feature/logic/bloc/bloc/todo_bloc.dart';
import 'package:practice_bloc/tools/media_query.dart';
import 'package:practice_bloc/tools/popup/awesome_alert.dart';
import 'package:practice_bloc/tools/popup/snack_bar_widget.dart';
import 'package:practice_bloc/tools/responsive.dart';
import 'package:practice_bloc/tools/text_form_fileds/text_form_field_multi_line.dart';
import 'package:practice_bloc/tools/text_form_fileds/text_form_field_name.dart';
import 'package:practice_bloc/tools/theme/colors.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.submitDate,
    required this.goalDate,
    required this.isDone,
    required this.index,
  });

  final String id;
  final String title;
  final String desc;
  final String submitDate;
  final String goalDate;
  final bool isDone;
  final int index;
  static const String screenId = "/edit_todo_screen";

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formValidation = GlobalKey<FormState>();
  Jalali? picked;

  @override
  void initState() {
    _titleController.text = widget.title;
    _descController.text = widget.desc;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ویرایش وظیفه',
          style: TextStyle(
            fontFamily: 'adobe_arabic',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.todoEvent is CompletedTodoEvent) {
            Navigator.pop(context);
            getSnackBarWidget(context, 'با موفقیت ویرایش شد', Colors.green);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formValidation,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getWidth(context, 0.04)),
                child: Column(
                  children: [
                    SizedBox(height: getWidth(context, 0.05)),

                    /// title text field
                    TextFormFieldNameWidget(
                      maxLength: 100,
                      labelText: 'عنوان',
                      icon: const Icon(Icons.edit_outlined),
                      textInputAction: TextInputAction.next,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      controller: _titleController,
                    ),
                    SizedBox(height: getWidth(context, 0.03)),

                    /// description text field

                    TextFormFieldMultiLine(
                      minLine: 5,
                      maxLine: 8,
                      labelText: "توضیحات",
                      textInputAction: TextInputAction.newline,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      controller: _descController,
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Icon(Icons.description_outlined),
                      ),
                    ),

                    /// date picker
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(getAllWidth(context),
                            Responsive.isMobile(context) ? 45 : 75),
                        backgroundColor: textFieldColor,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        picked = await showPersianDatePicker(
                          context: context,
                          initialDate: Jalali.now(),
                          firstDate: Jalali(1385, 8),
                          lastDate: Jalali(1450, 9),
                        );
                        setState(() {});
                      },

                      /// if date is not picked,show text,otherwise show date
                      child: picked == null
                          ? Text(
                              widget.goalDate,
                              style: TextStyle(
                                fontFamily: 'nasim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            )
                          : Text(
                              picked!.formatCompactDate(),
                              style: TextStyle(
                                fontFamily: 'nasim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: getWidth(context, 0.1)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(getAllWidth(context),
                            Responsive.isMobile(context) ? 45 : 75),
                        backgroundColor: Color.fromARGB(253, 253, 141, 20),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_formValidation.currentState!.validate()) {
                          alertDialogError(
                              context, 'مشکل', 'برخی از فیلد ها خالی میباشند');
                        } else {
                          context.read<TodoBloc>().add(
                                EditTaskTodoEvent(
                                  id: widget.id,
                                  title: _titleController.text,
                                  desc: _descController.text,
                                  submitDate: Jalali.now().formatCompactDate(),
                                  goalDate: picked == null
                                      ? widget.goalDate
                                      : picked!.formatCompactDate(),
                                  isDone: widget.isDone,
                                  index: widget.index,
                                ),
                              );
                        }
                      },
                      child: const Text(
                        "ثبت ویرایش",
                        style: TextStyle(
                          fontFamily: 'adobe_arabic',
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Lottie.asset(
                      'assets/lottie/edit_pencil.json',
                      width: getWidth(context, 0.3),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
