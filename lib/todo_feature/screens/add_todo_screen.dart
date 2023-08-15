import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:practice_bloc/todo_feature/logic/bloc/bloc/todo_bloc.dart';
import 'package:practice_bloc/todo_feature/model/todo_model.dart';
import 'package:practice_bloc/tools/media_query.dart';
import 'package:practice_bloc/tools/popup/awesome_alert.dart';
import 'package:practice_bloc/tools/popup/snack_bar_widget.dart';
import 'package:practice_bloc/tools/responsive.dart';
import 'package:practice_bloc/tools/text_form_fileds/text_form_field_multi_line.dart';
import 'package:practice_bloc/tools/text_form_fileds/text_form_field_name.dart';
import 'package:practice_bloc/tools/theme/colors.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  static const String screenId = '/add_todo_screen';

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formValidation = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Jalali? picked;
  final helper = TodoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'افزودن وظیفه',
          style: TextStyle(
            fontFamily: 'adobe_arabic',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.todoEvent is CompletedTodoEvent) {
            Navigator.pop(context);
            getSnackBarWidget(
                context, "وظیفه با موفقیت اضافه شد", Colors.green);
          }
        },
        child: SingleChildScrollView(
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
                            'انتخاب تاریخ',
                            style: TextStyle(
                              fontFamily: 'nasim',
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            picked!.formatCompactDate(),
                            style: TextStyle(
                              fontFamily: 'nasim',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                  ),
                  SizedBox(height: getWidth(context, 0.1)),

                  /// submit button
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
                      } else if (picked == null) {
                        alertDialogError(context, 'انتخاب تاریخ',
                            'لطفا یک تاریخ برای هدف خود انتخاب کنید');
                      } else {
                        context.read<TodoBloc>().add(
                              AddTaskTodoEvent(
                                title: _titleController.text,
                                desc: _descController.text,
                                submitDate: Jalali.now().formatCompactDate(),
                                goalDate: picked!.formatCompactDate(),
                              ),
                            );
                      }
                    },
                    child: const Text(
                      "ثبت وظیفه",
                      style: TextStyle(
                        fontFamily: 'adobe_arabic',
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Lottie.asset(
                      'assets/lottie/todo_list.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
