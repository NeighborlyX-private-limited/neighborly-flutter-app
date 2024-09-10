// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/dropdown_search_field.dart';
import '../../../../core/widgets/text_field_calendar_widget.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../data/model/event_model.dart';
import '../bloc/event_create_cubit.dart';
import '../widgets/manage_dates_dialog.dart';
import 'event_detail_screen.dart';

class EventCreateScreen extends StatefulWidget {
  final EventModel? eventToUpdate;
  const EventCreateScreen({
    Key? key,
    this.eventToUpdate,
  }) : super(key: key);

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  late EventCreateCubit eventCreateCubit;
  int currentStep = 1;
  File? fileToUpload;
  String avatarUrl = '';
  String dateStart = '';
  String dateEnd = '';
  bool isValidForm = false;
  // step 1
  final titleEC = TextEditingController();
  final descriptionEC = TextEditingController();
  // step 2
  final categoryEC = TextEditingController(text: kEventCategories[0]);
  final dateStartEC = TextEditingController();
  final hourStartEC = TextEditingController(text: kHoursOfDay[8]);
  final dateEndEC = TextEditingController();
  final hourEndEC = TextEditingController(text: kHoursOfDay[9]);
  // step 3
  final locationEC = TextEditingController();
  final addressEC = TextEditingController();

  @override
  void initState() {
    print('...INITSTATE - create/edit page');
    super.initState();

    eventCreateCubit = BlocProvider.of<EventCreateCubit>(context);
    eventCreateCubit.init(widget.eventToUpdate);
    currentStep = 1;

    if (widget.eventToUpdate != null) {
      print('category? ${widget.eventToUpdate?.category}');
      updateOnEdit();
    }
  }

  void updateOnEdit() {
    print('category? ${widget.eventToUpdate?.category}');
    titleEC.text = widget.eventToUpdate?.title ?? '';
    descriptionEC.text = widget.eventToUpdate?.description ?? '';
    categoryEC.text = widget.eventToUpdate?.category ?? '';
    locationEC.text = widget.eventToUpdate?.locationStr ?? '';
    addressEC.text = widget.eventToUpdate?.address ?? '';

    dateStartEC.text = DateUtilsHelper.simplifyISOtimeString(
        widget.eventToUpdate?.dateStart ?? '');
    dateEndEC.text = DateUtilsHelper.simplifyISOtimeString(
        widget.eventToUpdate?.dateEnd ?? '');
    hourEndEC.text = DateUtilsHelper.simplifyISOtimeStringOnlyHour(
        widget.eventToUpdate?.dateEnd ?? '');
    hourStartEC.text = DateUtilsHelper.simplifyISOtimeStringOnlyHour(
        widget.eventToUpdate?.dateStart ?? '');

    eventCreateCubit.updateDates(
      widget.eventToUpdate?.dateStart ?? '',
      DateUtilsHelper.simplifyISOtimeStringOnlyHour(
          widget.eventToUpdate?.dateEnd ?? ''),
      widget.eventToUpdate?.dateEnd ?? '',
      DateUtilsHelper.simplifyISOtimeStringOnlyHour(
          widget.eventToUpdate?.hourEnd ?? ''),
      widget.eventToUpdate?.category ?? '',
    );

    setState(() {
      avatarUrl = widget.eventToUpdate?.avatarUrl ?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleEC.dispose();
    descriptionEC.dispose();
    locationEC.dispose();
    categoryEC.dispose();
    addressEC.dispose();
    dateStartEC.dispose();
    hourStartEC.dispose();
    dateEndEC.dispose();
    hourEndEC.dispose();
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
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18, height: 0.3),
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
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, height: 0.3),
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

  void jumpNext() {
    setState(() {
      if (currentStep == 3) {
        if (preValidation(showMessage: true)) currentStep++;
      } else {
        currentStep++;
      }
    });
  }

  String titleSelector(int step) {
    switch (step) {
      case 1:
        return 'Event Info';
      case 2:
        return 'Event Date';
      case 3:
        return 'Event Location';
      case 4:
        return 'Preview';
      default:
        return 'create';
    }
  }

  bool preValidation({bool showMessage = false}) {
    var errors = [];
    if (fileToUpload == null) errors.add('Cover Picture');
    if (titleEC.text.trim() == '') errors.add('Title');
    if (descriptionEC.text.trim() == '') errors.add('Description');
    if (dateStartEC.text.trim() == '') errors.add('Date Start');
    if (dateEndEC.text.trim() == '') errors.add('Date End');
    if (locationEC.text.trim() == '') errors.add('Location');
    if (addressEC.text.trim() == '') errors.add('Address');

    if (errors.length == 0) {
      setState(() => isValidForm = true);
      return true;
    } else {
      if (showMessage) {
        setState(() => isValidForm = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ops, you forgot to fill: \n' +
                errors
                    .map((e) => '\n${e}')
                    .toList()
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')),
          ),
        );
      }
      return false;
    }
  }

  void processSave() {
    // #save
    eventCreateCubit.saveEvent(
        EventModel(
          id: '',
          title: titleEC.text,
          description: descriptionEC.text,
          locationStr: locationEC.text,
          category: categoryEC.text,
          avatarUrl: '',
          isJoined: true,
          isMine: true,
          dateStart: '', //dateStartEC.text,
          dateEnd: '', // dateEndEC.text,
          hourStart: dateStartEC.text,
          hourEnd: dateEndEC.text,
          address: addressEC.text,
          host: UserSimpleModel(id: '', name: '', avatarUrl: ''),
        ),
        fileToUpload);
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
            // print('currentStep=${currentStep}');

            if (currentStep == 1) {
              bottomSheetConfirmNotSaved(context);
              return;
            }

            setState(() {
              currentStep--;
            });
          },
        ),
        title: Text(titleSelector(currentStep)),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (currentStep == 4) {
                processSave();
              } else {
                jumpNext();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: currentStep == 3
                  ? isValidForm == true
                      ? AppColors.primaryColor
                      : Colors.red
                  : AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    50), // Ajuste o raio conforme necessário
              ),
              // padding: EdgeInsets.all(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                currentStep == 4 ? 'Save' : 'Next >',
                style:
                    TextStyle(color: Colors.white, fontSize: 18, height: 0.3),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocConsumer<EventCreateCubit, EventCreateState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              var message = state.successMessage ?? 'success';

              print('...success? ${message}');

              //  XXX   go to success page
              if (state.isUpdate == false) {
                Navigator.of(context).pop();
                context.push('/events/success/create', extra: state.newEvent);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );

                Navigator.of(context).pop();
              }

              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //
          //
          return BlocBuilder<EventCreateCubit, EventCreateState>(
            bloc: eventCreateCubit,
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

              print(widget.eventToUpdate?.avatarUrl);

              return Container(
                padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //
                      //

                      if (currentStep == 1) ...[
                        Step1area(
                          nameController: titleEC,
                          descriptionController: descriptionEC,
                          currentUrl: widget.eventToUpdate?.avatarUrl ?? '',
                          currentFile: fileToUpload,
                          onSelectImage: (newFile) {
                            print('newFile=${newFile.path}');

                            if (newFile != null) {
                              setState(() {
                                fileToUpload = newFile;
                              });

                              eventCreateCubit.onUpdateFile(newFile);
                            }
                          },
                        ),
                      ],
                      // //
                      //
                      if (currentStep == 2) ...[
                        Step2area(
                          dateStart: dateStartEC,
                          dateEnd: dateEndEC,
                          hourStart: hourStartEC,
                          hourEnd: hourEndEC,
                          category: categoryEC,
                          onChange: (dateStart, hourStart, dateEnd, hourEnd,
                              category) {
                            print(
                                'dateStart=${dateStart} hourStart=${hourStart}');
                            print('dateStart=${dateEnd} hourStart=${hourEnd}');

                            // updateDates(String dateStart, String hourStart, String dateEnd, String hourEnd)
                            eventCreateCubit.updateDates(dateStart, hourStart,
                                dateEnd, hourEnd, category);
                            preValidation(showMessage: false);
                          },
                        ),
                      ],
                      //
                      //
                      if (currentStep == 3) ...[
                        Step3area(
                          locationController: locationEC,
                          addressController: addressEC,
                        ),
                      ],
                      // //
                      // //
                      if (currentStep == 4) ...[
                        Step4area(
                          isLoading: state.status == Status.loading,
                          currentImageFile: fileToUpload,
                          event: EventModel(
                              id: '',
                              title: titleEC.text,
                              description: descriptionEC.text,
                              avatarUrl: '',
                              locationStr: locationEC.text,
                              dateStart: dateStartEC.text,
                              dateEnd: dateEndEC.text,
                              hourStart: hourStartEC.text,
                              hourEnd: hourEndEC.text,
                              category: categoryEC.text,
                              address: addressEC.text,
                              host: UserSimpleModel(
                                id: 'id',
                                name: 'currentUser',
                                avatarUrl: '',
                              ),
                              isJoined: true,
                              isMine: true),
                        ),
                      ],
                      //
                      //
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class Step1area extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final File? currentFile;
  final Function(File) onSelectImage;
  final String currentUrl;

  const Step1area({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    this.currentFile,
    required this.onSelectImage,
    required this.currentUrl,
  }) : super(key: key);

  @override
  State<Step1area> createState() => _Step1areaState();
}

class _Step1areaState extends State<Step1area> {
  late File? selectedImage;

  @override
  void initState() {
    super.initState();

    selectedImage = widget.currentFile;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        widget.onSelectImage(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.45,
            // height: 190,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(10),
              border: DashedBorder.fromBorderSide(
                dashLength: 10,
                side: BorderSide(color: AppColors.primaryColor, width: 1),
              ),
            ),
            child: selectedImage != null && selectedImage?.path != null ||
                    widget.currentUrl != ''
                ? Stack(
                    children: [
                      (widget.currentUrl != null && widget.currentUrl != '')
                          ? Image.network(
                              widget.currentUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.file(
                              selectedImage!,
                              width: double.infinity,
                              // height: 260,
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh_outlined,
                                  size: 30, color: Colors.white),
                              onPressed: () {
                                _pickImage();
                              },
                            ),
                          ))
                    ],
                  )
                : Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        // height: 20,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/picture_add_icon.svg'),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add Cover Photo',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBackgroundColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 15),
          //
          //
          Text(
            'Event Title',
            style: greyonboardingBody1Style,
          ),
          const SizedBox(height: 5),
          TextFieldWidget(
            border: true,
            onChanged: (value) {},
            controller: widget.nameController,
            lableText: '',
          ),
          const SizedBox(height: 30),
          //
          //
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          //
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) {},
              controller: widget.descriptionController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Describe your community',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  )),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class Step2area extends StatefulWidget {
  final TextEditingController dateStart;
  final TextEditingController hourStart;
  final TextEditingController dateEnd;
  final TextEditingController hourEnd;
  final TextEditingController category;
  final Function(String, String, String, String, String) onChange;
  const Step2area({
    Key? key,
    required this.dateStart,
    required this.hourStart,
    required this.dateEnd,
    required this.hourEnd,
    required this.category,
    required this.onChange,
  }) : super(key: key);

  @override
  State<Step2area> createState() => _Step2areaState();
}

class _Step2areaState extends State<Step2area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          Text(
            'Start date & Time',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          //
          Row(
            children: [
              Expanded(
                flex: 60,
                child: TextFieldCalendarWidget(
                  border: true,
                  onChanged: (value) {},
                  controller: widget.dateStart,
                  lableText: '',
                  onTap: () async {
                    // XXX
                    var response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageDatesDialog(
                                endDateStr: widget.dateStart.text == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : widget.dateStart.text,
                                startDateStr: widget.dateStart.text == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : widget.dateEnd.text,
                              )),
                    ); //

                    if (response == null) return;

                    widget.dateStart.text =
                        DateUtilsHelper.simplifyISOtimeString(
                            response['startDateRaw'].toIso8601String());

                    print('...onPressOpenDatesSelection response=${response}');
                    widget.onChange(response['startDateRaw'].toIso8601String(),
                        '', '', '', '');
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 40,
                child: DropdownSearchField(
                  // label: 'Choose your location',
                  items: [...kHoursOfDay],
                  onChanged: (value) {
                    print('start hour: ${value}');
                    widget.hourStart.text = value ?? '';
                    widget.onChange('', value ?? '', '', '', '');
                  },
                  initialValue: widget.hourStart.text == ''
                      ? "07:00 AM"
                      : widget.hourStart.text,
                  placeholder: 'Start Hour',
                  // validator: Validatorless.required('Preenchimento é obrigatório'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          //
          //
          Text(
            'End date & Time',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          //
          Row(
            children: [
              Expanded(
                flex: 60,
                child: TextFieldCalendarWidget(
                  border: true,
                  onChanged: (value) {},
                  controller: widget.dateEnd,
                  lableText: '',
                  onTap: () async {
                    // XXX
                    var response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageDatesDialog(
                                endDateStr: widget.dateEnd.text == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : widget.dateEnd.text.split('T')[0],
                                startDateStr: widget.dateEnd.text == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : widget.dateEnd.text.split('T')[0],
                              )),
                    ); //

                    if (response == null) return;

                    widget.dateEnd
                        .text = DateUtilsHelper.simplifyISOtimeString(response[
                            'startDateRaw']
                        .toIso8601String()); // really start on this point, since dialog return a range

                    print('...onPressOpenDatesSelection response=${response}');
                    widget.onChange('', '',
                        response['startDateRaw'].toIso8601String(), '', '');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 40,
                child: DropdownSearchField(
                  // label: 'Choose your location',
                  items: [...kHoursOfDay],
                  onChanged: (value) {
                    print('end hour: ${value}');
                    widget.hourEnd.text = value ?? '';
                    widget.onChange('', '', '', value ?? '', '');
                  },
                  initialValue: widget.hourEnd.text == ''
                      ? "07:00 AM"
                      : widget.hourEnd.text,
                  placeholder: 'End Hour',
                  // validator: Validatorless.required('Preenchimento é obrigatório'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          //
          //
          DropdownSearchField(
            label: 'Category',
            items: [...kEventCategories],
            onChanged: (value) {
              print('category: ${value}');
              widget.category.text = value ?? '';
              widget.onChange('', '', '', '', value ?? '');
            },
            initialValue: widget.category.text == ''
                ? kEventCategories[0]
                : widget.category.text,
            placeholder: 'Category',
            // validator: Validatorless.required('Preenchimento é obrigatório'),
          ),
          //
          //
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class Step3area extends StatelessWidget {
  final TextEditingController locationController;
  final TextEditingController addressController;
  const Step3area({
    Key? key,
    required this.locationController,
    required this.addressController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          DropdownSearchField(
            label: 'Location',
            items: kLocationList,
            onChanged: (value) {
              locationController.text = value ?? '';
            },
            initialValue: locationController.text,
            placeholder: 'Choose event location',
            // validator: Validatorless.required('Preenchimento é obrigatório'),
          ),
          const SizedBox(height: 30),
          //
          //
          Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) {},
              controller: addressController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Address in details',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  )),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class Step4area extends StatelessWidget {
  final bool? isLoading;
  final File? currentImageFile;
  final EventModel event;
  const Step4area({
    Key? key,
    this.currentImageFile,
    required this.event,
    this.isLoading = false,
  }) : super(key: key);

  Widget topElementLocal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        image: event.avatarUrl == ''
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(event.avatarUrl),
              ),
      ),
      child: currentImageFile == null ? null : Image.file(currentImageFile!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          //
          topElementLocal(context),
          //
          TitleArea(
            title: event.title,
            locationStr: event.locationStr,
          ),
          //
          //
          DateArea(
            dateStart: event.dateStart,
            dateEnd: event.dateEnd,
            hourStart: event.hourStart ?? '',
            hourEnd: event.hourStart ?? '',
          ),
          //
          //
          ChatArea(event: event, allowTap: false),

          //
          //
          AboutArea(description: event.description),
          //
          //
          Divider(thickness: 10, color: AppColors.lightBackgroundColor),
          LocationDetailArea(
            locationStr: event.locationStr,
            address: event.address,
          ),
          //
        ],
      ),
    );
  }
}
