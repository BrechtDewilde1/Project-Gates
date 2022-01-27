import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class monthly_target_computer {
  int start_value = 2950;
  DateTime startDate = DateTime(2022, 2, 1);

  Future<int> calculate_monthly_target() async {
    return await calculate_monthly_target_fut().then((target) {
      return target;
    });
  }

  Future<int> calculate_monthly_target_fut() async {
    if (Jiffy(DateTime.now()).diff(Jiffy(startDate), Units.DAY) < 0) {
      // Zijn we voor Februari?

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("huidige_target", start_value);
      return start_value;
    } else if (DateTime.now().month == 2) {
      // Zijn we in februari?

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("huidige_target", start_value);
      return start_value;
    } else if (DateTime.now().month == 3) {
      // Zijn we in maart?
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("huidige_target", (start_value * 0.95).toInt());
      await prefs.setInt("target_vorige_maand", (start_value).toInt());

      return (start_value * 0.95).toInt();
    } else {
      // hebben we al een nieuwe maand?
      if (check_for_new_month()) {
        return new_month_happend();
      }
    }
    return 0;
  }

  bool check_for_new_month() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.month != DateTime.now().month;
  }

  Future<int> new_month_happend() async {
    // huidige_waarde wordt waarde van vorige maand
    // waarde van vorige maand wordt waarde van "vorige_vorige" maand
    // niewe waarde = waarde_vorige maand - (waarde_vorige_vorige_maand - waarde vorige_maand) * 0.9
    // Stop als waarde 2000;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int target_vorige_maand = prefs.getInt("target_vorige_maand") ?? 0;
    int huidige_target = prefs.getInt("huidige_target") ?? 0;

    // Waarde van vorige maand wordt waard van vorige_vorige maand
    await prefs.setInt("target_vorige_vorige_maand", target_vorige_maand);
    int target_vorige_vorige_maand = target_vorige_maand;

    // huidige waarde wordt waarde van vorige maand
    await prefs.setInt("target_vorige_maand", huidige_target);
    target_vorige_maand = huidige_target;

    // berekening nieuwe waarde
    double undoubled_huidige_target = target_vorige_maand -
        (target_vorige_vorige_maand - target_vorige_maand) * 0.9;
    huidige_target = undoubled_huidige_target.toInt();
    await prefs.setInt("huidige_target", huidige_target);

    return huidige_target;
  }
}
