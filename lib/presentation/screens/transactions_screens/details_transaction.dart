import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moordak/data/models/transaction_model.dart';
import 'package:moordak/presentation/components/lable.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DetailsTransactionScreen extends StatefulWidget {
  final TransactionModel transactionModel;

  const DetailsTransactionScreen({this.transactionModel});
  @override
  _DetailsTransactionScreenState createState() =>
      _DetailsTransactionScreenState(transactionModel);
}

class _DetailsTransactionScreenState extends State<DetailsTransactionScreen> {
  final TransactionModel _transactionModel;

  _DetailsTransactionScreenState(this._transactionModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: [
            new Lable(
              title: 'نام :',
              description:
                  '${_transactionModel.firstName} ${_transactionModel.lastName == null ? "" : _transactionModel.lastName}',
            ),
            new Divider(
              height: 4,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'مبلغ :',
              description:
                  '${_transactionModel.payVal.toString().seRagham()} ریال',
            ),
            new Divider(
              height: 4,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'کد ملی :',
              description: '${_transactionModel.nationalCode}',
            ),
            new Divider(
              height: 4,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'تاریخ تراکنش :',
              description: '${_transactionModel.payDate.toPersianDate()}',
            ),
            new Divider(
              height: 4,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'خیریه :',
              description: _transactionModel.isCharity == true ? "است" : "نیست",
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  final List<dynamic> imgList;

  const ImageSlider({this.imgList});
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CarouselSlider(
        height: 300,
        items: imgList
            .map((item) => Container(
                  child: Center(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '${mainApi}${item}',
                      placeholder: (context, url) => new Container(
                        width: 50,
                        height: 50,
                        child: new Icon(Icons.more_horiz),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ))
            .toList(),
      );
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
        'جزئیات تراکنش',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}
