import 'package:dio/dio.dart';

class ApiSerrvice {
  Future<dynamic> getData(int pageNumber) async {
    try {
      Response response = await Dio().get(
        'https://softawork2.xyz/fandlApi/doctor/get_doctor_all?page_no=$pageNumber&user_id=46&distance_range=100000',
      );
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      // print(e.response?.data);
      return e.response?.data;
    }
  }
}
