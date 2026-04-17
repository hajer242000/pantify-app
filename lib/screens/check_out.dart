import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/core/enums/transaction_type.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/data/shipping_type_data.dart';
import 'package:plant_app/models/address_model.dart';
import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/models/orderitems_model.dart';
import 'package:plant_app/models/shipping_model.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/statics_var.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/cart_item.dart';
import 'package:plant_app/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Checkout extends ConsumerStatefulWidget {
  const Checkout({super.key});

  @override
  ConsumerState<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<Checkout> {
  ShippingModel shippingModel = shippingType[0];
  AddressModel? addressModel;
  late Environment sdkEnv;
  final bool _isLoading = false;

  void saveData() async {
    final orderList = ref.read(stateProvider);
    final total = ref.read(stateTotalProvider(25));

    final myOrder = OrderModel(
      userID: supabase.auth.currentUser!.id,
      addressID: '749c6ee9-2067-42eb-944c-ee57321a5e25',
      shippedType: 'delivery',
      total: total,
      paymentMethod: 'card',
      shippingMethod: shippingModel.name,
    );

    final ordersItems = orderList.map<OrderItemsModel>((cartItem) {
      return OrderItemsModel(
        orderID: '',
        plantID: cartItem.id,
        quantity: cartItem.quantity,
        price: cartItem.price,
      );
    }).toList();

    await ref.read(
      addOrderProvider({'order': myOrder, 'items': ordersItems}).future,
    );
  }

  Future<String?> getSDKSessionToken({
    required String merchantId,
    required String secureHashValue,
    String? customerId,
  }) async {
    var webhookUrl = '';

    if (sdkEnv == Environment.SIT) {
      webhookUrl = 'https://test.amwalpg.com:24443/';
    } else if (sdkEnv == Environment.UAT) {
      webhookUrl = 'https://test.amwalpg.com:14443/';
    } else if (sdkEnv == Environment.PROD) {
      webhookUrl = 'https://webhook.amwalpg.com/';
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: webhookUrl,
          headers: {
            'authority': 'localhost',
            'accept': 'text/plain',
            'accept-language': 'en-US,en;q=0.9',
            'content-type': 'application/json',
          },
        ),
      );

      // dio.interceptors.add(ChuckerDioInterceptor());
      // DioClient.dio?.interceptors.add(ChuckerDioInterceptor());

      var sec = SecureHashInterceptor.clearSecureHash(secureHashValue, {
        'merchantId': merchantId,
        'customerId': customerId,
      });
      debugPrint(
        'Request [POST] => URL: ${webhookUrl + SDKNetworkConstants.getSDKSessionToken}',
      );
      debugPrint('Request Headers: ${dio.options.headers}');
      debugPrint(
        'Request Data: {merchantId: $merchantId, secureHashValue: $sec, customerId: $customerId}',
      );
      final response = await dio.post(
        SDKNetworkConstants.getSDKSessionToken,
        data: {
          'merchantId': merchantId,
          'secureHashValue': sec,
          'customerId': customerId,
        },
      );

      debugPrint(
        'Response [${response.statusCode}] => URL: ${SDKNetworkConstants.getSDKSessionToken}',
      );
      debugPrint('Response Data: ${response.data}');

      if (response.data['success']) {
        return response.data['data']['sessionToken'];
      }
    } on DioException catch (e) {
      debugPrint('Full API Error: ${e.response}');

      final errorList = e.response?.data['errorList'];
      final errorMessage = (errorList != null)
          ? errorList.join(',')
          : 'Unknown error';
      await _showErrorDialog(errorMessage);
      return null;
    } catch (e) {
      await _showErrorDialog('Something Went Wrong');
      return null;
    }
    return null;
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('failed'.translate(context)),
          content: Text(message),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    sdkEnv = Environment.UAT;
  }

  @override
  Widget build(BuildContext context) {
    final orderList = ref.watch(stateProvider);
    final getDefaultUserAddress = ref.watch(
      getDefaultAddress(supabase.auth.currentUser!.id),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title("Shipping Address"),
                ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: getDefaultUserAddress.when(
                    data: (data) {
                      return checkoutCard(
                        addressModel != null
                            ? addressModel!.buildingType
                            : data != null
                            ? data.buildingType
                            : "xxxxx",
                        addressModel != null
                            ? addressModel!.fullAddress
                            : data != null
                            ? data.fullAddress
                            : "xxx xxx xxx",
                        Icons.location_pin,
                        () async {
                          final selectedShippingAddress =
                              await Navigator.pushNamed(
                                context,
                                '/shippingAddress',
                              );

                          if (selectedShippingAddress != null &&
                              selectedShippingAddress is AddressModel) {
                            setState(() {
                              addressModel = selectedShippingAddress;
                            });
                          }
                        },
                      );
                    },
                    error: (error, stackTrace) => Center(child: Text("Error")),
                    loading: () => CircularProgressIndicator(),
                  ),
                ),
                Divider(
                  height: 20,
                  color: const Color.fromARGB(255, 220, 219, 219),
                ),
                title("Choose Shipping Type"),
                checkoutCard(
                  shippingModel.name,
                  shippingModel.arrival,
                  Icons.local_shipping,
                  () async {
                    final selectedShipping = await Navigator.pushNamed(
                      context,
                      '/shippingType',
                    );

                    if (selectedShipping != null &&
                        selectedShipping is ShippingModel) {
                      setState(() {
                        shippingModel = selectedShipping;
                      });
                    }
                  },
                ),
                title("Order List"),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      final orderItem = orderList[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CartItem(isInCart: false, cartModel: orderItem),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Footer(
            title:
                "Continue to Payment \t\t\t ${ref.watch(stateTotalProvider(shippingModel.price))}OMR",
            onPressed: () async {
              try {
                final sessionToken = await getSDKSessionToken(
                  merchantId: dotenv.env['AMWAL_MERCHANT_ID'] ?? '',
                  secureHashValue:
                      dotenv.env['AMWAL_SECURE_HASH'] ?? '',
                  //    customerId:
                  // 'OPTIONAL_CUSTOMER_ID', //This is optional, only to be used when saved card functionality is being used.
                );

                // Initialize the SDK with Apple Pay
                await AmwalPaySdk.instance.initSdk(
                  settings: AmwalSdkSettings(
                    environment: Environment.UAT, // or SIT, PROD
                    sessionToken: sessionToken!,
                    currency: 'OMR',
                    amount: '${ref.read(stateTotalProvider(25))}',
                    transactionId: const Uuid().v1(),
                    merchantId: dotenv.env['AMWAL_MERCHANT_ID'] ?? '',
                    terminalId: dotenv.env['AMWAL_TERMINAL_ID'] ?? '',
                    locale: const Locale('en'), // or 'ar' for Arabic
                    isMocked: false,
                    transactionType:
                        TransactionType.cardWallet, // Use this for Apple Pay
                    customerCallback: (String? customerId) {
                      // Handle customer ID callback
                    },
                    //customerId: 'OPTIONAL_CUSTOMER_ID',
                    onResponse: (String? response) {
                      if (response != null) {
                        // Handle successful response
                        print('Payment successful: $response');
                        saveData();
                        Navigator.pushNamed(context, '/paymentSuccess');
                      } else {
                        // Handle error
                        print('Payment failed');
                      }
                    },
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }

  ListTile checkoutCard(
    String title,
    String subtitle,
    IconData icon,
    void Function()? onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor),
        ),
        padding: EdgeInsets.all(5),
        child: Text("CHANGE", style: TextStyle(color: primaryColor)),
      ),
    );
  }
}
