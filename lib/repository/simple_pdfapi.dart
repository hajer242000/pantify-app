import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart' show Barcode;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart'
    as http; 
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/repository/save_opendocuments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SimplePdfApi {
  static final Map<String, pw.MemoryImage> imageCache = {};
  static String _formatDate(DateTime? dt) {
    if (dt == null) return '-';

    final date = DateFormat('MMM dd, yyyy').format(dt);
    final time = DateFormat('hh:mm a').format(dt);
    return '$date | $time';
  }

  static Future<pw.MemoryImage> _loadDefaultImage() async {
    final imageByteData = await rootBundle.load('images/leaf.png');
    final Uint8List imageBytes = imageByteData.buffer.asUint8List();
    return pw.MemoryImage(imageBytes);
  }

  static Future<pw.MemoryImage?> _fetchImage(String? url) async {
    if (url == null || url.isEmpty) return null;

    if (url.startsWith('http')) {
      if (imageCache.containsKey(url)) return imageCache[url];
      try {
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode == 200) {
          final mem = pw.MemoryImage(resp.bodyBytes);
          imageCache[url] = mem;
          return mem;
        } else {
          print('Image fetch failed (${resp.statusCode}) for $url');
          return null;
        }
      } catch (e) {
        print('Image fetch error for $url: $e');
        return null;
      }
    }
    return null;
  }

  static Future<File> generateOrderPdf({
    required OrderModel order,
    required SupabaseClient supabase,
    String? fileName,
  }) async {
    final ttfData = await rootBundle.load('assets/fonts/InterBold.ttf');
    final ttf = pw.Font.ttf(ttfData);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttf,
        italic: ttf,
        boldItalic: ttf,
      ),
    );

    final orderData = await supabase
        .from('orders')
        .select('''
        *,
        address (*),
        order_items (
          *,
          plant:plants!inner (
            id, name, description, price, image,
            category:categories!inner (
                id, slug, name
            )
          )
        )
    ''')
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (orderData == null) {
      throw Exception("No recent order found to generate PDF.");
    }

    final Map<String, dynamic> userInfo = await supabase
        .from('users')
        .select('id ,full_name , phone ,email')
        .eq('id', supabase.auth.currentUser!.id)
        .single();

    final String userName = userInfo['full_name'] as String;
    final String? userphone = userInfo['phone'] as String?;
    final String useremail = userInfo['email'] as String;
    final List<dynamic> orderItemsDynamic =
        orderData['order_items'] as List<dynamic>;
    final Map<String, dynamic>? addressInfo = orderData['address'];

    final List<Map<String, dynamic>> orderItemsList = orderItemsDynamic
        .cast<Map<String, dynamic>>();

    final List<Future<void>> imageFetchTasks = [];

    for (var itemInfo in orderItemsList) {
      final plantInfo = itemInfo['plant'];
      final imageUrl = plantInfo != null ? plantInfo['image'] as String? : null;

      if (imageUrl != null && imageUrl.startsWith('http')) {
        imageFetchTasks.add(_fetchImage(imageUrl));
      }
    }

    await Future.wait(imageFetchTasks);

    final pw.MemoryImage defaultPlantImage = await _loadDefaultImage();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final String? createdAtString = orderData['created_at'] as String?;
          pw.Image image1 = pw.Image(pw.MemoryImage(defaultPlantImage.bytes));
          DateTime? orderDate;
          if (createdAtString != null) {
            try {
              orderDate = DateTime.parse(createdAtString).toLocal();
            } catch (e) {
              print('Error parsing date: $e');
            }
          }
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    'Pantify',
                    style: pw.TextStyle(
                      fontSize: 33,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor(0.55686, 0.75686, 0.32941),
                    ),
                  ),
                  pw.Container(
                    width: 50,
                    height: 50,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(6),
                      color: PdfColors.white,
                    ),
                    child: image1,
            
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'Customer Name: $userName',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Customer Phone: ${userphone ?? 000000000}',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Customer UD: $useremail',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                width: 500,
                child: order.id != null
                    ? pw.BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: order.id!,
                        width: 500,
                        height: 60,
                        textPadding: 10,
                      )
                    : pw.SizedBox(),
              ),
              pw.SizedBox(height: 16),
              pw.Expanded(
                child: pw.ListView.builder(
                  itemBuilder: (pw.Context context, int index) {
                    final Map<String, dynamic> itemInfo = orderItemsList[index];

                    final Map<String, dynamic>? plantInfo = itemInfo['plant'];
                    final Map<String, dynamic>? categoryInfo =
                        plantInfo?['category'];

                    final String plantName =
                        plantInfo?['name'] as String? ?? 'N/A';
                    final double plantPrice =
                        (plantInfo?['price'] as num?)?.toDouble() ?? 0.0;
                    final String plantImage =
                        plantInfo?['image'] as String? ?? '';
                    final String categoryName =
                        categoryInfo?['name'] as String? ?? 'No Category';
                    final int quantity = itemInfo['quantity'] as int? ?? 1;

                    final pw.MemoryImage? memImage = imageCache[plantImage];

                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 12),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 70,
                            height: 70,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(6),
                              color: PdfColors.grey200,
                            ),
                            child: memImage != null
                                ? pw.ClipRRect(
                                    horizontalRadius: 6,
                                    verticalRadius: 6,
                                    child: pw.Image(
                                      memImage,
                                      fit: pw.BoxFit.cover,
                                    ),
                                  )
                                : pw.Center(
                                    child: pw.Text(
                                      'No\nImage',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  plantName,
                                  style: const pw.TextStyle(fontSize: 15),
                                ),
                                pw.Text(
                                  categoryName,
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: PdfColors.grey500,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      '\$ ${plantPrice.toStringAsFixed(2)}',
                                      style: pw.TextStyle(
                                        fontSize: 17,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.Text(
                                      "x$quantity",
                                      style: const pw.TextStyle(
                                        color: PdfColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: orderItemsList.length,
                ),
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Order Date',
                    style: pw.TextStyle(
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(   textAlign: pw.TextAlign.start ,
                    _formatDate(orderDate),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(   textAlign: pw.TextAlign.start ,
                    "\$ ${orderData['total']}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Payment Method',
                    style: pw.TextStyle(
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(   textAlign: pw.TextAlign.start ,
                    orderData['payment_method'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Delivery Type',
                    style: pw.TextStyle(
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    textAlign: pw.TextAlign.start ,
                    orderData['shipping_methods'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Delivery Address',
                    style: pw.TextStyle(
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(   textAlign: pw.TextAlign.start ,
                    addressInfo!['full_address'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    const defaultFileName = 'order_receipt.pdf';
    final name = fileName ?? defaultFileName;

    final file = await SaveAndOpenDocuments.savePdf(name: name, pdf: pdf);
    return file;
  }
}
