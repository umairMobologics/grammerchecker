
import 'package:share_plus/share_plus.dart';

//share Text
Future<void> shareText(String text)
{
   return  Share.share(text);
}