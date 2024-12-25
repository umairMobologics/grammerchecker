import 'package:hive/hive.dart';

import '../../model/TutorModels/MessageModel.dart';

class HiveBox {
  static String message = 'messages';

  static Future<void> initHive() async {
    await Hive.openBox<SaveMessagesModel>(message);
    await Hive.openBox<Conversation>("conversations");
  }
}
