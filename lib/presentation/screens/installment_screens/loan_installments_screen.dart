import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/installment_dtos/paid_installment.dart';
import 'package:moordak/data/models/loan_Installments_model.dart';
import 'package:moordak/logic/blocs/installment_bloc/installment_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:moordak/presentation/list_items/installment_view_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoanInstallmentsScreen extends StatefulWidget {
  final List<LoanInstallmentsModel> loanInstallments;
  final String name;

  const LoanInstallmentsScreen({this.loanInstallments, this.name});
  @override
  _LoanInstallmentsScreenState createState() => _LoanInstallmentsScreenState();
}

class _LoanInstallmentsScreenState extends State<LoanInstallmentsScreen> {
  InstallmentBloc _installmentBloc;
  bool _isLoading = false;
  List<File> _images = List<File>();
  List<Asset> _imagesAssets = List<Asset>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  SharedPreferences _preferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _installmentBloc = BlocProvider.of<InstallmentBloc>(context);

    dateTextController.text = 'تاریخ پرداخت';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _installmentBloc,
      listener: (context, state) {
        if (state is PaidInstallmentState) {
          _paidInstallment(state.isSuccessed);
        } else if (state is InstallmentExceptionState) {
          _exceptionState(state.message);
        }
      },
      builder: (context, state) {
        if (state is InstallmentLoadingState) {
          _isLoading = true;
        }
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: widget.loanInstallments.length > 0
              ? Scrollbar(
                  child: ListView.builder(
                    itemCount: widget.loanInstallments.length,
                    itemBuilder: (context, index) {
                      return new InstallmentViewModel(
                        loanInstallmentsModel: widget.loanInstallments[index],
                        onItemClicked: () {
                          _modalBottomSheetMenu(
                              widget.loanInstallments[index].id);
                        },
                      );
                    },
                  ),
                )
              : _buildEmpty(),
        );
      },
    );
  }

  _paidInstallment(bool isSuccessed) {
    _isLoading = false;
    if (isSuccessed == true) {
      Toast.show('با موفقیت ثبت شد', context, duration: 2);
    } else {
      Toast.show('عملیات ناموفق', context, duration: 2);
    }
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

  Widget _buildEmpty() {
    return new Center(
      child: new Text(
        'موردی برای نمایش وجود ندارد',
        style: new TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: maincolor,
      title: new Text(
        'اقساط وام ${widget.name}',
        style: new TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(int id) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return new Container(
              height: 500.0,
              color: Colors.transparent,
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: new Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new _LoanInstallmentDatePicker(),
                          new InkWell(
                            onTap: () async {
                              List<Asset> resultList = <Asset>[];
                              String error = 'No Error Detected';

                              try {
                                resultList = await MultiImagePicker.pickImages(
                                  maxImages: 2,
                                  enableCamera: true,
                                  selectedAssets: _imagesAssets,
                                  cupertinoOptions:
                                      CupertinoOptions(takePhotoIcon: "chat"),
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
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                          ),
                          _imagesAssets.length > 0
                              ? new SizedBox(
                                  child: _buildGridView(),
                                )
                              : Container(
                                  child: new Text(
                                    'تصویری انتخاب نشده',
                                    style: new TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                          _isLoading == true
                              ? new CircularProgressIndicator(
                                  color: maincolor,
                                )
                              : new FloatingActionButton(
                                  backgroundColor: maincolor,
                                  onPressed: () async {
                                    _preferences =
                                        await SharedPreferences.getInstance();
                                    _images.clear();
                                    for (var imageAsset in _imagesAssets) {
                                      _images.add(await getImageFileFromAssets(
                                          imageAsset));
                                    }
                                    PersianDateTime persianDate1 =
                                        PersianDateTime(
                                            jalaaliDateTime:
                                                dateTextController.text);
                                    persianDate1.toGregorian();
                                    _installmentBloc.add(
                                      new PaidInstallmentEvent(
                                          new PaidInstallmentDto(
                                        apiToken:
                                            _preferences.getString('apiToken'),
                                        payDate: persianDate1.datetime
                                            .toString()
                                            .replaceFirst(" ", "T"),
                                        installmentId: id,
                                        imageArray: _images,
                                      )),
                                    );
                                  },
                                  child:
                                      new Icon(Icons.add, color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  )),
            );
          });
        });
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
          width: 30,
          height: 30,
        );
      }),
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

class _LoanInstallmentDatePicker extends StatefulWidget {
  @override
  LoanInstallmentDatePickerState createState() {
    return new LoanInstallmentDatePickerState();
  }
}

final TextEditingController dateTextController = TextEditingController();
PersianDatePickerWidget persianDatePicker;

class LoanInstallmentDatePickerState extends State<_LoanInstallmentDatePicker> {
  // our text controller

  @override
  void initState() {
    /*Simple DatePicker*/
    persianDatePicker = PersianDatePicker(
      controller: dateTextController,
      // datetime: 'تاریخ دریافت',
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
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
