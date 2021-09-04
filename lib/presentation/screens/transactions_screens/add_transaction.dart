import 'dart:io';
import 'package:currency_input_formatters/currency_input_formatters.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_add_dto.dart';
import 'package:moordak/data/dtos/user_dtos/get_user_info_dto.dart';
import 'package:moordak/data/models/user_model.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';
import 'package:moordak/logic/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/components/check_box.dart';
import 'package:moordak/presentation/components/text_input.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _payValController = new TextEditingController();
  final TextEditingController _typeAheadController =
      TextEditingController(text: null);
  String _selectedUser;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<Asset> _imagesAssets = List<Asset>();
  int _transactionVal;
  final _currencyFormatter = CurrencyFormatter();
  TransactionBloc _transactionBloc;
  List<File> _images = List<File>();
  DateTime now = DateTime.now();
  MourdakRepository _mourdakRepository = new MourdakRepository();
  String _selectedUserName;

  bool _isLoading, _isCharity = false;
  SharedPreferences _preferences;
  @override
  void initState() {
    super.initState();
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);

    dateTextController.text = 'تاریخ تراکنش';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _transactionBloc,
      listener: (context, state) {
        if (state is TransactionExceptionState) {
          _exceptionState(state.text);
        } else if (state is AddTransactionState) {
          _addTransaction(state.isSuccessed, context);
        }
      },
      builder: (context, state) {
        if (state is TransactionLoadingState) {
          _isLoading = true;
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: _MyAppBar(),
          backgroundColor: bodycolor,
          body: new Stack(
            alignment: Alignment.topCenter,
            children: [
              _background(),
              _form(),
            ],
          ),
        );
      },
    );
  }

  _exceptionState(String exception) async {
    _isLoading = false;
    if (exception == '401') {
      _preferences = await SharedPreferences.getInstance();
      _preferences.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(exception),
        ),
      );
    }
  }

  _addTransaction(bool isSuccessed, context) {
    _isLoading = false;
    if (isSuccessed == true) {
      Toast.show('تراکنش با موفقیت ثبت شد', context, duration: 2);
      _payValController.clear();
      _typeAheadController.clear();
      _imagesAssets.clear();
    } else {
      Toast.show('عملیات ناموفق', context, duration: 2);
    }
  }

  Widget _background() {
    return Container(
      height: MediaQuery.of(context).size.height * .30,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: maincolor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(700, 200),
              bottomRight: Radius.elliptical(700, 200))),
    );
  }

  Widget _submit(context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _images.clear();
          for (var imageAsset in _imagesAssets) {
            _images.add(await getImageFileFromAssets(imageAsset));
          }
          PersianDateTime persianDate1 =
              PersianDateTime(jalaaliDateTime: dateTextController.text);
          persianDate1.toGregorian();

          _preferences = await SharedPreferences.getInstance();
          String _apiToken = _preferences.getString('apiToken');

          TransactionAddDto transactionAddDto = new TransactionAddDto(
            isCharity: _isCharity,
            payDate: persianDate1.datetime.toString().replaceFirst(' ', 'T'),
            imageArray: _images,
            apiToken: _apiToken,
            userId: _selectedUser,
            payVal: _transactionVal.toDouble(),
          );
          _transactionBloc.add(
            new AddTransactionEvent(transactionAddDto),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: 230.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: maincolor,
        ),
        child: Center(
          child: _isLoading == true
              ? new CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  'ثبت',
                  style: TextStyle(
                    fontFamily: 'IRANSans',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(
          right: 25, left: 25, top: MediaQuery.of(context).size.height * .10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  labelText: 'کاربر',
                  contentPadding: EdgeInsets.all(5),
                ),
              ),
              suggestionsCallback: (pattern) async {
                _preferences = await SharedPreferences.getInstance();
                GetUserInfoDto getUserInfoDto = new GetUserInfoDto(
                  apiToken: _preferences.getString('apiToken'),
                  searchText: pattern,
                );
                // _userBloc.add(
                //   GetAllUsersEvent(getUserInfoDto),
                // );

                return await _mourdakRepository.getUserInfo(getUserInfoDto);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                    title: Text(
                  "${suggestion['firstName']} ${suggestion['lastName'] == null ? "" : suggestion['lastName']}",
                ));
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text =
                    "${suggestion['firstName']} ${suggestion['lastName']}";
                _selectedUser = suggestion['id'];
                _selectedUserName =
                    "${suggestion['firstName']} ${suggestion['lastName']}";
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
              },
            ),
            // user bottom sheet ===================>
            // _buildUserButton(),
            // _selectedUserName != null
            //     ? _buildSelectedUser()
            //     : new Container(
            //         padding: EdgeInsets.all(15),
            //         child: new Text(
            //           'کاربری انتخاب نشده',
            //           style: new TextStyle(
            //             fontSize: 16,
            //           ),
            //         ),
            //       ),
            new InputFieldArea(
              inputFormatter: [_currencyFormatter],
              onChanged: (_) {
                _transactionVal = _currencyFormatter.currentNumber;
              },
              icon: Icons.monetization_on_sharp,
              controller: _payValController,
              lable: 'مبلغ (ریال)',
              maxLength: 12,
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),

            new LabeledCheckbox(
              label: 'امر خیریه',
              value: _isCharity,
              onChanged: (value) {
                setState(() {
                  _isCharity = value;
                });
              },
            ),

            _imageButton(),
            _imagesAssets.length > 0
                ? new SizedBox(
                    child: _buildGridView(),
                  )
                : Container(
                    padding: EdgeInsets.all(15),
                    child: new Text(
                      'تصویری انتخاب نشده',
                      style: new TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
            _TransactionDatePicker(),
            _submit(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildSelectedUser() {
    return new Container(
      padding: EdgeInsets.all(10),
      child: new Text(
        _selectedUserName,
        style: new TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildUserButton() {
    return InkWell(
      onTap: () {
        _modalBottomSheetMenu();
      },
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: 230.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: maincolor,
        ),
        child: Center(
          child: Text(
            "انتخاب کاربر",
            style: TextStyle(
              fontFamily: 'IRANSans',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 500.0,
              padding: EdgeInsets.all(15),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _typeAheadController,
                      decoration: InputDecoration(
                        labelText: 'کاربر',
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      _preferences = await SharedPreferences.getInstance();
                      GetUserInfoDto getUserInfoDto = new GetUserInfoDto(
                        apiToken: _preferences.getString('apiToken'),
                        searchText: pattern,
                      );
                      // _userBloc.add(
                      //   GetAllUsersEvent(getUserInfoDto),
                      // );

                      return await _mourdakRepository
                          .getUserInfo(getUserInfoDto);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                          title: Text(
                        "${suggestion['firstName']} ${suggestion['lastName'] == null ? "" : suggestion['lastName']}",
                      ));
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      this._typeAheadController.text =
                          "${suggestion['firstName']} ${suggestion['lastName']}";
                      _selectedUser = suggestion['id'];
                      _selectedUserName =
                          "${suggestion['firstName']} ${suggestion['lastName']}";
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'لطفا این فرم را پر کنید';
                      }
                    },
                  ),
                  new FloatingActionButton(
                    backgroundColor: maincolor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(Icons.done, color: Colors.white),
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      children: List.generate(_imagesAssets.length, (index) {
        Asset asset = _imagesAssets[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  Widget _imageButton() {
    return InkWell(
      onTap: loadAssets,
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: 230.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: maincolor,
        ),
        child: Center(
          child: Text(
            'انتخاب تصویر',
            style: TextStyle(
              fontFamily: 'IRANSans',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: _imagesAssets,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "صندوق شهدای موردک",
          allViewTitle: "تصاویر",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagesAssets = resultList;
    });
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      elevation: 0,
      title: new Text(
        'افزودن تراکنش',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

class _TransactionDatePicker extends StatefulWidget {
  @override
  TransactionDatePickerState createState() {
    return new TransactionDatePickerState();
  }
}

final TextEditingController dateTextController = TextEditingController();
PersianDatePickerWidget persianDatePicker;

class TransactionDatePickerState extends State<_TransactionDatePicker> {
  // our text controller

  @override
  void initState() {
    /*Simple DatePicker*/
    persianDatePicker = PersianDatePicker(
      controller: dateTextController,
      // datetime: 'تاریخ پرداخت',
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        enableInteractiveSelection:
            false, // *** this is important to prevent user interactive selection ***
        onTap: () {
          FocusScope.of(context).requestFocus(
              new FocusNode()); // to prevent opening default keyboard
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return persianDatePicker;
              });
        },
        controller: dateTextController,
      ),
    );
  }
}
