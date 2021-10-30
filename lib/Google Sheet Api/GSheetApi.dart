import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/model/OrderSheetModel.dart';
import 'package:gsheets/gsheets.dart';

class GSheetApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "xenon-timer-329913",
  "private_key_id": "6c302b36b061c970af3fa5b81ecdb49ecb1fabf7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCaEiSVdY6RljaD\ntfgx6g4qsMG4ZvbUNnWOOqTUmLFHd/s4LNCfnZat3fU0Trb04b1EDmu/RUXKkJzi\nuAN1lAysuwkz1CjVQ4t54biw3QvXoiMTXaFtJvIC0LffDtNDqmBTsVc+SN+tQfMv\nzBcu7q1dbKP9ZFPazXohuQdwZLX8+EvCvopA8I/it+QABng+tC4eiEF4zRiuJvMW\ni8iE5pqdyU5OlkZ1hiooOuxq+emvX/rcMbIpbpHzPj7VTtRhS6VxEVNxFgoq2yEu\nCMOdv51C1Ppab55uKlT+UBHklug7FdBtunrCvLs2XlvYdVG7f6/p5D9TOPbQzFB7\nVY51qFpDAgMBAAECggEAMR28jOsDjrT43wc5PsxTRNfBggRNBrzvv+5BEsc0qMh+\njVt4DJJj8TyTiV/Yont+Zz5Dqh+uzpNIeFxaOfb/DWe42M13UPlt8uZ7BuMI/e6h\nyPAt4IqsVyprm4/x2J3thHDCE8iOigC+wouJDnynRuO16bc8pkGgADUownNQsvqE\nKE9AZxIEfgxlr7E12JAoW7nfXIMdXkjtC2rvORLilK6H7IcvLvL88rxNoU38BjkQ\n992YT8dMjfsnm7T7o9iRsMBSzq9YJhXFbb3X4kYAAftclewGNX1hMBzEAwcdjJAx\ndRNX+UcNuH26FIE3lnP8BG0BS9vsy0FZHYv5//UoYQKBgQDGxlF26vg+4TXBhi72\nd9Cg89JWljwGd9bd1EiulbwwWXQCN4L85TLkU860I2hCE7RJUsYz4LESGajNvze5\nO0JgN+Tf6Y5N5OXVqopG7zQvpJXOv2TDrT0h/FrYApsOEk0IK163TvP0c6qLbjA0\nNMiIdMeXoYKHr38lfjB6kfCuIwKBgQDGbSgZg3xIWrT1REQWlSJ8HjDutZ25WmnM\naMrlS10S9kj5r8ePWzrlcxFmmGh2KGKkycXe6IbYlx6tLw4W7fBBStFte3vEH1AE\ne0/Okxx0IYXlHZlSJHuUSsLIxqbG+xn1n5bg4gtcPjDYTBYyWsZLF0OvVfIZZGkV\nEbRfRzSVYQKBgB6/qvZ0XraLbB9lvHoQCsv7K7yNPPfbLffe0OeA7j2keNem8rJg\nWkEL3dvr5kLifW8iSNrZlUqxgXVicSJMUnZD7zncDVFraUpmOUHD2xTLpwj2foXu\nlJhfS0ZDEO1aU2RCIULGCeL0yZsMDpTk3WiOeBmyuFh5A3gvTxyG2u51AoGAQbBh\nVhDxVAKzZX70C4XTpMNZ76ywSmxkGgeXI9GPPnfKMN7AcfUBynQNjqll67fy8Brc\nJq9T9OASh8LMJ0sd/n+GVXhLwOGc2972zKxm/wsaCH+EAm2Re8ZENbOOAtGeBnKO\nwGQU3rS39uM5dfIXM0TAY4tQWpejMhZqYCByiAECgYBJAltZaNWs2BfPRZ6fcJK8\nHeNKInCb3HssUoQjVNR9f6mt3p2w1amRAqSMfWPQMUmo0t9tk95t+ncRUNx7iRg6\n8m3S3ZQI1tpvZnzsIArDFd1lVfRIb9sXYazn7nHgoIyvXNF8NzIUTt91p/JbTVmG\nvMl2VRO9mP9IGtLPshFfeg==\n-----END PRIVATE KEY-----\n",
  "client_email": "crust-food@xenon-timer-329913.iam.gserviceaccount.com",
  "client_id": "107532995960067787658",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/crust-food%40xenon-timer-329913.iam.gserviceaccount.com"
}
''';
  static final _spreadSheetId = "1fAJ7P_JaoCo24EeUsYT1koR5cmHTRsS77oaWVkYGClo";
  static final _gsheet = GSheets(_credentials);

  static Worksheet trissurtownSheet,
      guruvayoorSheet,
      kannurSheet,
      thaliparambuSheet,
      manjeriSheet,
      kondottySheet,
      medicalcollageSheet,
      vadakaraSheet,
      vengaraSheet,
      tirurSheet,
      pattambiSheet,
      calicuttownSheet,
      calicutbeachSheet,
      perinthalmannaSheet,
      localrootsSheet;

  static Future init() async {
    try {
      final spreadSheet = await _gsheet.spreadsheet(_spreadSheetId);
      trissurtownSheet =
          await _getWorksheet(spreadSheet, title: "Trissur town");
      guruvayoorSheet =
          await _getWorksheet(spreadSheet, title: "Guruvayoor - trpryar");
      kannurSheet =
          await _getWorksheet(spreadSheet, title: "Kannur - thalasseri");
      thaliparambuSheet =
          await _getWorksheet(spreadSheet, title: "Thaliparambu - kaserkod");
      manjeriSheet =
          await _getWorksheet(spreadSheet, title: "Manjeri - wandoor ");
      kondottySheet =
          await _getWorksheet(spreadSheet, title: "Kondotty - nilambur");
      medicalcollageSheet =
          await _getWorksheet(spreadSheet, title: "M.collage - Thamarasseri");
      vadakaraSheet =
          await _getWorksheet(spreadSheet, title: "Vadakara - nadapuram");
      vengaraSheet =
          await _getWorksheet(spreadSheet, title: "Vengara - malappuram");
      tirurSheet = await _getWorksheet(spreadSheet, title: "Tirur - ponnani");
      pattambiSheet =
          await _getWorksheet(spreadSheet, title: "Pattambi - tirurangadi");
      calicuttownSheet =
          await _getWorksheet(spreadSheet, title: "Calicut town-karaparambu");
      calicutbeachSheet =
          await _getWorksheet(spreadSheet, title: "Calicut Beach - nadakkav");
      perinthalmannaSheet =
          await _getWorksheet(spreadSheet, title: "Perinthalmanna - mannarkad");
      localrootsSheet = await _getWorksheet(spreadSheet, title: "Local roots");

      final firstRow = await OrderSheetModel.getFields() as List;
      trissurtownSheet.values.insertRow(1, firstRow);
      guruvayoorSheet.values.insertRow(1, firstRow);
      kannurSheet.values.insertRow(1, firstRow);
      thaliparambuSheet.values.insertRow(1, firstRow);
      manjeriSheet.values.insertRow(1, firstRow);
      kondottySheet.values.insertRow(1, firstRow);
      medicalcollageSheet.values.insertRow(1, firstRow);
      vadakaraSheet.values.insertRow(1, firstRow);
      vengaraSheet.values.insertRow(1, firstRow);
      tirurSheet.values.insertRow(1, firstRow);
      pattambiSheet.values.insertRow(1, firstRow);
      calicuttownSheet.values.insertRow(1, firstRow);
      calicutbeachSheet.values.insertRow(1, firstRow);
      perinthalmannaSheet.values.insertRow(1, firstRow);
      localrootsSheet.values.insertRow(1, firstRow);
    } catch (e) {
      print("init Error : $e");
    }
  }

  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet,
      {String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future<int> getRowCount() async {
    if (trissurtownSheet == null || guruvayoorSheet == null) {
      return 0;
    }

    final lastRow = await trissurtownSheet.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (trissurtownSheet == null ||
        guruvayoorSheet == null ||
        kannurSheet == null ||
        thaliparambuSheet == null ||
        manjeriSheet == null ||
        kondottySheet == null ||
        medicalcollageSheet == null ||
        calicutbeachSheet == null ||
        vadakaraSheet == null ||
        calicuttownSheet == null ||
        perinthalmannaSheet == null ||
        vengaraSheet == null ||
        tirurSheet == null ||
        pattambiSheet == null ||
        localrootsSheet == null) {
      return;
    }

    if (snapshot?.data()["Routes"] == "Trissur town")
      trissurtownSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Guruvayoor - trpryar")
      guruvayoorSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Kannur - thalasseri")
      kannurSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Thaliparambu - kaserkod")
      thaliparambuSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Manjeri - wandoor")
      manjeriSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Kondotty - nilambur")
      kondottySheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "M.collage - Thamarasseri")
      medicalcollageSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Calicut Beach - nadakkav")
      calicutbeachSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Vengara - malappuram")
      vengaraSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Tirur - ponnani")
      tirurSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Pattambi - tirurangadi")
      pattambiSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Calicut town-karaparambu")
      calicuttownSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Vadakara - nadapuram")
      vadakaraSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Perinthalmanna - mannarkad")
      perinthalmannaSheet.values.map.appendRows(rowList);
    else if (snapshot?.data()["Routes"] == "Local roots")
      localrootsSheet.values.map.appendRows(rowList);
  }
}
