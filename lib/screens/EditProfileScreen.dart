import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Models/UserModel.dart';
import 'package:twitter_clone/Services/DatabaseServices.dart';
import 'package:twitter_clone/Services/StorageService.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const EditProfileScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _bio = '';
  File? _profileImage;
  File? _coverImage;
  String _imagePickedType = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.userModel.coverImage.isNotEmpty) {
        return NetworkImage(widget.userModel.coverImage);
      }
    } else {
      return FileImage(_coverImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.userModel.profilePicture.isEmpty) {
        return AssetImage('assets/placeholder.png');
      } else {
        return NetworkImage(widget.userModel.profilePicture);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  handleImageFromGallery() async {
    try {
      PickedFile? imageFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (imageFile != null) {
        if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = File(imageFile.path);
          });
        } else if (_imagePickedType == 'cover') {
          setState(() {
            _coverImage = File(imageFile.path);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      String coverPictureUrl = '';

      if (_profileImage == null) {
        profilePictureUrl = widget.userModel.profilePicture;
      } else {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.userModel.profilePicture, _profileImage);
      }

      if (_coverImage == null) {
        coverPictureUrl = widget.userModel.coverImage;
      } else {
        coverPictureUrl = await StorageService.uploadCoverPicture(
            widget.userModel.coverImage, _coverImage);
      }
      UserModel user = UserModel(
        id: widget.userModel.id,
        email: widget.userModel.email,
        name: _name,
        profilePicture: profilePictureUrl,
        bio: _bio,
        coverImage: coverPictureUrl,
      );
      DatabaseServices.updateUserData(user);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.userModel.name;
    _bio = widget.userModel.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          GestureDetector(
            onTap: () {
              _imagePickedType = 'cover';
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: KTweeterColor,
                    image: _coverImage == null &&
                            widget.userModel.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover, image: displayCoverImage()),
                  ),
                ),
                Container(
                  height: 150.0,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        'Change Cover Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: displayProfileImage(),
                          ),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Change Profile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        width: 100,
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: KTweeterColor,
                          border: Border.all(color: KTweeterColor),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: KTweeterColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'Please enter valid name'
                            : null,
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: KTweeterColor),
                        ),
                        onSaved: (value) {
                          _bio = value!;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(KTweeterColor),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
