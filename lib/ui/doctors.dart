import 'package:flutter/material.dart';

import 'package:lazy_list/webservices/api_service.dart';

class ListOfAllDoctors extends StatefulWidget {
  const ListOfAllDoctors({Key? key}) : super(key: key);

  @override
  _ListOfAllDoctorsState createState() => _ListOfAllDoctorsState();
}

class _ListOfAllDoctorsState extends State<ListOfAllDoctors> {
  ScrollController _sc = ScrollController();
  int page = 1;

  bool isLoading = false;
  List<dynamic> doctorList = [];
  bool end = false;
  final repository = ApiSerrvice();
  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> response = await repository.getData(page);

      if (!response.containsValue('Page no missing or Its incorrect.')) {
        List<dynamic> tList = response["doctorAllList"];

        setState(() {
          isLoading = false;
          doctorList.addAll(tList);

          page++;
        });
      } else {
        setState(() {
          end = true;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
            opacity: isLoading ? 1.0 : 00, child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
        print(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("All Doctors"),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _sc,
                itemCount: doctorList.length + 1,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == doctorList.length) {
                    return end ? SizedBox() : _buildProgressIndicator();
                  } else {
                    return cutomCard(doctorList[index]);
                  }
                }),
          ),
          end
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("No more data"),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget cutomCard(dynamic data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctors_name"] ?? "Not available"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Clinic Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctor_clinic_name"] ?? "Not available"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Email:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctors_email"] ?? "Not available"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Contact Number:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctors_contact_number"] ?? 'Not available'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Address:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctors_address"] ?? 'Not available'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Website:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctors_website"] ?? 'Not available'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Specialised in:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(data["doctor_specialist_name"] ?? 'Not available')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
