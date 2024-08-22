import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/dropdown_search_field.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../data/model/event_model.dart';
import '../bloc/event_join_cubit.dart';

class EventJoinScreen extends StatefulWidget {
  final EventModel? eventToJoin;
  const EventJoinScreen({
    Key? key,
    this.eventToJoin,
  }) : super(key: key);

  @override
  State<EventJoinScreen> createState() => _EventJoinScreenState();
}

class _EventJoinScreenState extends State<EventJoinScreen> {
  late EventJoinCubit eventJoinCubit;

  bool isValidForm = false;
  bool _isChecked = false;

  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final genderEC = TextEditingController(text: kGender[0]);
  final phoneEC = TextEditingController();

  @override
  void initState() {
    print('...INITSTATE - create/edit page');
    super.initState();

    eventJoinCubit = BlocProvider.of<EventJoinCubit>(context);
    eventJoinCubit.init(widget.eventToJoin!);
  }

  @override
  void dispose() {
    super.dispose();
    nameEC.dispose();
    emailEC.dispose();
    genderEC.dispose();
    phoneEC.dispose();
  }

  Future<dynamic> bottomSheetConfirmNotSaved(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: Colors.white,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you whant to Unlock this person?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff635BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool preValidation({bool showMessage = false}) {
    var errors = [];

    if (nameEC.text.trim() == '') errors.add('Name');
    if (emailEC.text.trim() == '') errors.add('Email');
    if (phoneEC.text.trim() == '') errors.add('Phone');

    if (errors.length == 0) {
      setState(() => isValidForm = true);
      return true;
    } else {
      if (showMessage) {
        setState(() => isValidForm = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ops, you forgot to fill: \n' + errors.map((e) => '\n${e}').toList().toString().replaceAll('[', '').replaceAll(']', '')),
          ),
        );
      }
      return false;
    }
  }

  void processSave() {
    if (preValidation(showMessage: true)) {
      // #save
      eventJoinCubit.onPressRegister(
        name: nameEC.text,
        email: emailEC.text,
        phone: phoneEC.text,
        gender: genderEC.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    preValidation(showMessage: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.eventToJoin?.title ?? ''),
      ),
      body: BlocConsumer<EventJoinCubit, EventJoinState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              var message = state.successMessage ?? 'success';

              print('...success? ${message}');

              Navigator.of(context).pop();
              context.push('/events/success/join', extra: state.eventJoin);

              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //
          //
          return BlocBuilder<EventJoinCubit, EventJoinState>(
            bloc: eventJoinCubit,
            builder: (context, state) {
              if (state.status == Status.loading) {
                // return const EventMainSheemer();
                return Center(
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              print(widget.eventToJoin?.avatarUrl);

              return Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //
                            //
                            Text(
                              'Contact Information',
                              style: onboardingHeading2Style,
                            ),
                            const SizedBox(height: 10),
                            //
                            //
                            Text(
                              'Name',
                              style: greyonboardingBody1Style,
                            ),
                            const SizedBox(height: 5),
                            TextFieldWidget(
                              border: true,
                              onChanged: (value) {},
                              controller: nameEC,
                              lableText: '',
                            ),
                            const SizedBox(height: 20),
                            //
                            //
                            Text(
                              'Email',
                              style: greyonboardingBody1Style,
                            ),
                            const SizedBox(height: 5),
                            TextFieldWidget(
                              border: true,
                              onChanged: (value) {},
                              controller: emailEC,
                              lableText: '',
                            ),
                            const SizedBox(height: 20),
                            //
                            //
                            Text(
                              'Phone',
                              style: greyonboardingBody1Style,
                            ),
                            const SizedBox(height: 5),
                            TextFieldWidget(
                              border: true,
                              onChanged: (value) {},
                              controller: phoneEC,
                              lableText: '',
                            ),
                            const SizedBox(height: 20),
                            //
                            //
                            DropdownSearchField(
                              label: 'Gender',
                              items: [...kGender],
                              onChanged: (value) {
                                print('gender: ${value}');
                                genderEC.text = value ?? '';
                              },
                              initialValue: kGender[0],
                              placeholder: 'Gender',
                              // validator: Validatorless.required('Preenchimento é obrigatório'),
                            ),
                            // //

                            //
                            //
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  }),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Text(
                                    'Neighborly is not responsible for any events and it is up to user’s discretion to look for their safety.',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //
                          //

                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // #message
                                if (state.status == Status.loading) return;

                                // widget.onJoin();
                                processSave();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isChecked ? AppColors.primaryColor : Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
                                ),
                                // padding: EdgeInsets.all(15)
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1, vertical: state.status == Status.loading ? 17 : 25),
                                child: state.status == Status.loading
                                    ? SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: TextStyle(color: _isChecked ? Colors.white : Colors.grey, fontSize: 18, height: 0.3),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                    //
                    //
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
