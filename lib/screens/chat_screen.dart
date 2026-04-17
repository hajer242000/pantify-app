import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/text_form_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> chats = [];
  Future<void> sendToN8nWebhook() async {
    final url = Uri.parse(
      dotenv.env['N8N_WEBHOOK_URL'] ?? '',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': controller.text}),
    );

    if (response.statusCode == 200) {
      print('✅ Sent successfully: ${response.body}');
      setState(() {
        chats.addAll([
          {"message": response.body, "isAI": true},
        ]);
      });
    } else {
      print('❌ Error: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('chat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              SizedBox(
                width: width(context),
                height: height(context),
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      chatText: chats[index]["message"],
                      isAI: chats[index]["isAI"],
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: width(context) - 20,

                  child: AppTextField(
                    controller: controller,
                    suffixHeroIcon: HeroIcons.paperAirplane,
                    hint: "Type a message here...",
                    onFieldSubmitted: (p0) async {
                      print(p0);
                      setState(() {
                        chats.addAll([
                          {"message": p0, "isAI": false},
                        ]);
                       
                      });

                      await sendToN8nWebhook();
                       controller.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isAI;
  final String chatText;
  const ChatBubble({super.key, this.isAI = true, required this.chatText});

  @override
  Widget build(BuildContext context) {
    var bubble = Container(
      width: isAI ? width(context) : width(context) - 70,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isAI ? primaryColor : const Color.fromARGB(255, 243, 243, 243),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: isAI ? Radius.circular(15) : Radius.circular(0),
          bottomLeft: isAI ? Radius.circular(0) : Radius.circular(10),
        ),
      ),
      child: Text(
        chatText,
        style: TextStyle(color: isAI ? quaternaryColor : primaryColor),
      ),
    );
    return isAI
        ? Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: Center(
                  child: LottieBuilder.network(
                    fit: BoxFit.cover,
                    'https://lottie.host/c7947b1c-9e6a-460f-b801-9b798558c868/FIsq2URkWg.json',
                  ),
                ),
              ),
              Expanded(child: bubble),
            ],
          )
        : Align(alignment: Alignment.centerRight, child: bubble);
  }
}
