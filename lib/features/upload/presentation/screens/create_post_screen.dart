import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/upload_post_bloc/upload_post_bloc.dart';
import '../widgets/post_button_widget.dart';
import '../../../../core/constants/imagepickercompress.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _questionController;

  // List of option controllers and focus nodes
  final List<TextEditingController> _optionControllers = [];
  final List<FocusNode> _optionFocusNodes = [];

  bool isTitleFilled = false;
  bool isQuestionFilled = false;
  bool allowMultipleVotes = false;
  bool _isButtonActive = true;

  late String _condition;

  late FocusNode _titleFocusNode;
  late FocusNode _contentFocusNode;
  bool _isKeyboardVisible = false; // Track keyboard visibility

  File? _selectedImage; // Store the selected image

  @override
  void initState() {
    super.initState();
    if (isLocationOn()) {
      fetchLocationAndUpdate();
    }
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _questionController = TextEditingController();
    _condition = 'post';
    _addOption();
    _addOption();

    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();

    _titleFocusNode.addListener(_onTiteFocusChange);
    _contentFocusNode.addListener(_onContentFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _titleController.dispose();
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var focusNode in _optionFocusNodes) {
      focusNode.dispose();
    }
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
  }

  bool isLocationOn() {
    bool isLocationOn = ShardPrefHelper.getIsLocationOn();
    if (isLocationOn) {
      return true;
    }
    return false;
  }

  Future<bool> _handleLocationPermission() async {
    // bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
            ),
          );
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
      }
      return false;
    }
    return true;
  }

  /// fetch the user location and upldate it.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
      }

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
      print(
          'Lat Long in create post Screen: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      if (mounted) {
        showLocationAccessDialog(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      debugPrint('Error getting location in create post: $e');
    }
  }

  AlertDialog buildLocationAccessDialog(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Text("No Location Access"),
      content: Text(
          "Device location is turned off, and if you don't turn on your location then last location will be used."),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  void showLocationAccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildLocationAccessDialog(context);
      },
    );
  }

  bool checkIsHome() {
    bool isLocationOn = ShardPrefHelper.getIsLocationOn();
    if (isLocationOn) {
      return true;
    }
    return false;
  }

  /// Function to fetch the current city name
  Future<String?> getCityName() async {
    try {
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Request permissions if not granted
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return 'Location permissions are denied';
        }
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use the coordinates to get the address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the city name from the first placemark
      if (placemarks.isNotEmpty) {
        return placemarks
            .first.locality; // City name is stored in the 'locality' field
      } else {
        return 'No city found at this location';
      }
    } catch (e) {
      print('Error getting city name in getCityName: $e');
      return 'Failed to get city name';
    }
  }

  // Check if all options and question are filled
  bool checkIsPollActive() {
    if (isQuestionFilled &&
        _optionControllers
            .every((controller) => controller.text.trim().isNotEmpty)) {
      return true;
    }
    return false;
  }

  bool checkIsActive() {
    if (isTitleFilled) {
      return true;
    }
    return false;
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _optionFocusNodes.add(FocusNode());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  void _onTiteFocusChange() {
    setState(() {
      _isKeyboardVisible = _titleFocusNode.hasFocus;
    });
  }

  void _onContentFocusChange() {
    setState(() {
      _isKeyboardVisible = _contentFocusNode.hasFocus;
    });
  }

  // void _onOptionFocusChange(int index) {
  //   setState(() {
  //     _isKeyboardVisible = _optionFocusNodes[index].hasFocus;
  //   });
  // }
  bool isImagePicking = false;
  bool isImageUploading = false;
  List<File>? _selectedImages = [];

  /// pic one image or multiple images from gallary
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    // Check if the user already has 5 images selected
    if (_selectedImages!.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can select up to 5 images.')),
      );
      setState(() {
        _selectedImages = [];
      });
      return;
    }

    try {
      setState(() {
        isImagePicking = true;
      });

      // Pick multiple images
      List<XFile>? images = await picker.pickMultiImage(
        imageQuality: 95,
        limit: 5,
      );

      if (images.isNotEmpty) {
        for (XFile imageFile in images) {
          // Check if adding this image exceeds the limit
          if (_selectedImages!.length < 5) {
            XFile compressedImage = await compressImage(imageFileX: imageFile);
            setState(() {
              _selectedImages!.add(
                File(
                  compressedImage.path,
                ),
              ); // Update selected images list
            });
            print(_selectedImages);
          } else {
            // Show a message if the user tries to select more than 5 images
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You can select up to 5 images only.')),
            );
            setState(() {
              _selectedImages = [];
            });
            break; // Exit the loop if the limit is reached
          }
        }
        setState(() {
          isImagePicking = false;
        });
        return;
      }
    } catch (e) {
      print("Error picking multiple images: $e");
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  /// pic image  images from camera
  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    try {
      setState(() {
        isImagePicking = true;
      });

      // Pick image and then compress
      image = await picker.pickImage(source: ImageSource.camera).then((file) {
        return compressImage(imageFileX: file);
      });

      if (image != null) {
        setState(() {
          _selectedImages!.add(File(image!.path));
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  ///remove image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  ///remove images from multiple images
  void _removeImages(int index) {
    setState(() {
      _selectedImages!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () {
              // Close the keyboard when tapping outside of the input field
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isImagePicking ? LinearProgressIndicator() : SizedBox(),
                  isImageUploading ? LinearProgressIndicator() : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14.0,
                      left: 14.0,
                      right: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Icon(Icons.close, size: 30),
                          onTap: () {
                            print(
                                '_selectedImage path in on tap fn: $_selectedImage');
                            if (_condition == 'post') {
                              _titleController.clear();
                              _contentController.clear();
                              _selectedImages = [];
                              _selectedImage = null;
                              context.go('/home/false');
                            } else {
                              setState(() {
                                _condition = 'post';
                              });
                            }
                          },
                        ),
                        _condition == 'post'
                            ? BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    setState(() {
                                      isImageUploading = true;
                                    });
                                  }
                                  if (state is UploadPostFailureState) {
                                    ///chnage error msg error

                                    if (state.error
                                        .contains("Sorry, you are banned")) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text("Sorry, you are banned"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(state.error)),
                                      );
                                    }
                                  } else if (state is UploadPostSuccessState) {
                                    setState(() {
                                      isImageUploading = false;
                                    });
                                    _contentController.clear();
                                    _titleController.clear();
                                    _removeImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post Created'),
                                      ),
                                    );

                                    context.go('/home/false');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return const Center(
                                        child: Text('Uploading...'));
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      if (!_isButtonActive) {
                                        return; // Prevent multiple taps
                                      }
                                      setState(() {
                                        _isButtonActive =
                                            false; // Disable the button
                                      });

                                      await fetchLocationAndUpdate();
                                      bool iaLocationOn =
                                          ShardPrefHelper.getIsLocationOn();

                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<double> homeLocation =
                                          ShardPrefHelper.getHomeLocation();

                                      String city = '';
                                      List<double> locationCord = [];
                                      if (iaLocationOn) {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          location[0],
                                          location[1],
                                        );
                                        var lat = location[0];
                                        var long = location[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      } else {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          homeLocation[0],
                                          homeLocation[1],
                                        );
                                        var lat = homeLocation[0];
                                        var long = homeLocation[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      }

                                      print("...post city:$city");
                                      print("...post city cord:$locationCord");
                                      print('selectedImage: $_selectedImage');
                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: city,
                                          content:
                                              _contentController.text.trim(),
                                          title: _titleController.text.trim(),
                                          type: 'post',
                                          multimedia: _selectedImages,
                                          allowMultipleVotes: false,
                                          location: locationCord,
                                        ),
                                      );
                                    },
                                    isActive: isTitleFilled,
                                  );
                                },
                              )
                            : BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  if (state is UploadPostFailureState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)),
                                    );
                                  } else if (state is UploadPostSuccessState) {
                                    _questionController.clear();

                                    _removeImage();
                                    for (var controller in _optionControllers) {
                                      controller.clear();
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Poll Created'),
                                      ),
                                    );
                                    context.go('/home/false');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      if (!_isButtonActive) {
                                        return; // Prevent multiple taps
                                      }
                                      setState(() {
                                        _isButtonActive =
                                            false; // Disable the button
                                      });
                                      bool iaLocationOn =
                                          ShardPrefHelper.getIsLocationOn();

                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<double> homeLocation =
                                          ShardPrefHelper.getHomeLocation();

                                      String city = '';
                                      List<double> locationCord = [];
                                      if (iaLocationOn) {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          location[0],
                                          location[1],
                                        );
                                        var lat = location[0];
                                        var long = location[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      } else {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          homeLocation[0],
                                          homeLocation[1],
                                        );
                                        var lat = homeLocation[0];
                                        var long = homeLocation[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      }

                                      print("city during post:$city");
                                      print("cord during post :$locationCord");
                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: city,
                                          multimedia: _selectedImages,
                                          title:
                                              _questionController.text.trim(),
                                          options: List.generate(
                                            _optionControllers.length,
                                            (index) => {
                                              "option":
                                                  _optionControllers[index]
                                                      .text
                                                      .trim(),
                                            },
                                          ),
                                          type: 'poll',
                                          allowMultipleVotes:
                                              allowMultipleVotes,
                                          location: locationCord,
                                        ),
                                      );
                                    },
                                    isActive: checkIsPollActive(),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                  if (_selectedImages!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 260,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _selectedImages![index],
                                    width: double.infinity,
                                    height: 260,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _removeImages(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  if (_condition == 'post')
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, left: 14.0, right: 14.0),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                isTitleFilled =
                                    _titleController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _titleController,
                            focusNode: _titleFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Title (Required)',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                // Handle content input changes if necessary
                              });
                            },
                            controller: _contentController,
                            focusNode: _contentFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'What\'s on your mind?',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                        ],
                      ),
                    ),
                  if (_condition == 'poll')
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, left: 14.0, right: 14.0),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                isQuestionFilled =
                                    _questionController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _questionController,
                            focusNode: _contentFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Write your question here...',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          const SizedBox(height: 12),
                          ..._buildOptionFields(),
                          InkWell(
                            onTap: _addOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff635BFF),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Add Option',
                                  style: blueNormalTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Allow multiple votes',
                                style: greyonboardingBody1Style,
                              ),
                              Switch(
                                value: allowMultipleVotes,
                                onChanged: (value) {
                                  setState(() {
                                    allowMultipleVotes = value;
                                  });
                                },
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                activeTrackColor: const Color(0xff635BFF),
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
          bottomSheet: !_isKeyboardVisible
              ? Container(
                  color: Colors.white,
                  height: 220,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: _pickImages,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                            Text(
                              'Add a Photo or GIF',
                              style: mediumTextStyleBlack,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 224, 238, 206),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('Take a Picture', style: mediumTextStyleBlack)
                          ],
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     context.push('/groups/create');
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset('assets/communities.svg'),
                      //       const SizedBox(width: 10),
                      //       Text('Create Community',
                      //           style: mediumTextStyleBlack),
                      //     ],
                      //   ),
                      // ),

                      // TODO: create a action to this and remove the comment

                      // Row(
                      //   children: [
                      //     SvgPicture.asset('assets/add_location.svg'),
                      //     const SizedBox(width: 10),
                      //     Text('Add Location', style: mediumTextStyleBlack),
                      //   ],
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     context.push('/events/create');
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset('assets/create_an_event.svg'),
                      //       const SizedBox(width: 10),
                      //       Text('Create an Event',
                      //           style: mediumTextStyleBlack),
                      //     ],
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _condition = 'poll';
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/create_a_poll.svg'),
                            const SizedBox(width: 10),
                            Text('Create a Poll', style: mediumTextStyleBlack),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _pickImages();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 224, 238, 206),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: const Color.fromARGB(255, 195, 0, 255),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _condition = 'poll';
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/create_a_poll.svg'),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  // Build dynamic option fields with the X button for removal
  List<Widget> _buildOptionFields() {
    return List.generate(_optionControllers.length, (index) {
      // _optionFocusNodes[index] ??= FocusNode();
      _optionFocusNodes[index];

      // Listen to focus changes on each FocusNode
      _optionFocusNodes[index].addListener(() {
        setState(() {
          _isKeyboardVisible = _optionFocusNodes[index].hasFocus;
        });
      });

      return Column(
        children: [
          Stack(
            children: [
              TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  setState(() {
                    // Option filled check is performed on all options
                  });
                },
                controller: _optionControllers[index],
                focusNode: _optionFocusNodes[index],
                decoration: InputDecoration(
                  labelText: 'Option ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
              if (index >= 2)
                Positioned(
                  right: 0,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _removeOption(index);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    });
  }
}
