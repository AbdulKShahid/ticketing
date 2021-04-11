import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';

class FormService {
  getInfoFields(widget) {
    var infoFieldsList = [
      FormField('string', 0.5, 'technicianName'),
      FormField('string', 0.5, 'ticketNumber'),
      FormField('dateTime', 0.5, 'ticketDate'),
      FormField('dateTime', 0.5, 'callTime'),
      FormField('dateTime', 0.5, 'arrivalTime'),
      FormField('dateTime', 0.5, 'departureTime'),
      FormField('string', 1, 'address'),
      FormField('string', 0.5, 'ville'),
      FormField('string', 0.5, 'codePostal'),
      FormField('dropdown', 0.5, 'status'),
      FormField('string', 0.5, 'building'),
      FormField('string', 0.5, 'floorNo'),
      FormField('string', 0.5, 'escalier'),
      FormField('string', 0.5, 'apartment'),
      FormField('string', 0.5, 'locatorName'),
      FormField('string', 0.5, 'telephone'),
      FormField('checkbox', 0.5, 'commonArea', 'Partie commune'),
      FormField('checkbox', 0.5, 'logement', 'Logement'),
      FormField('checkbox', 0.5, 'blackOut', 'Panne électrique'),
      FormField('checkbox', 0.5, 'waterLeak', "Fuite d'eau"),
      FormField('checkbox', 0.5, 'doorBlock', 'Porte Bloquée'),
    ];

    // add the names in the getInputDecoration on adding new fields

    return infoFieldsList;
  }

  getWorkFields(widget) {
    var workFieldsList = [
      FormField('checkbox', 0.5, 'isOneTechnician', 'Un technician'),
      FormField('checkbox', 0.5, 'isTwoTechnician', 'Deux technician'),
      FormField('checkbox', 0.5, 'waterLeakSearch', 'Recherche de fuite'),
      FormField('string', 1, 'waterLeakSearchCmt'),
      FormField('checkbox', 0.5, 'panneSearch', 'Recherche de panne'),
      FormField('string', 1, 'panneSearchCmt'),

      FormField('checkbox', 0.5, 'equipmentVerification', "Verification d'équipment"),
      FormField('checkbox', 0.5, 'putInSecurity', 'Mise en securité'),
      FormField('checkbox', 0.5, 'reparation', "Reparation"),
      FormField('string', 1, 'reparationCmt'),
      FormField('checkbox', 0.5, 'doorOpened', "Ouverture du porte"),
      FormField('checkbox', 0.5, 'cave', "Cave"),
      FormField('checkbox', 0.5, 'parkingEntry', "Entrée parking"),
      FormField('checkbox', 0.5, 'portail', "Portail"),
      FormField('checkbox', 0.5, 'porteGaineElectric', "Porte gaine électrique"),
      FormField('checkbox', 0.5, 'porteLocalTechnic', "Porte local technique"),
      FormField('checkbox', 0.5, 'reputInService', "Remise en service"),
      FormField('checkbox', 0.5, 'cleaning', "Nettoyage"),
      FormField('checkbox', 0.5, 'reparationPreviewed', "Réparation à prévoir"),
      FormField('string', 1, 'reparationPreviewedCmt'),
      FormField('checkbox', 0.5, 'devisNeeded', "Besoin d'un devis"),
      FormField('checkbox', 0.5, 'callManager', "Appel manager"),
      FormField('string', 0.5, 'conductorName'),
      FormField('string', 0.5, 'numberOfGardien'),
      FormField('string', 0.5, 'nameOfGardien'),



    ];

    return workFieldsList;
  }

  buildForm(fields) {
    return [];
  }

  List<Widget> getFormFieldsWidgets(fieldsList, widget, BuildContext context) {
    List<Widget> formWidgets = [];
    fieldsList.forEach(
        (field) => {formWidgets.add(getFormWidget(field, widget, context))});
    return formWidgets;
  }

  Widget getFormWidget(field, widget, BuildContext context) {
    return FractionallySizedBox(
        widthFactor: field.widthFactor,
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: getWidgetByType(field, field.type, widget, context),
        ));
  }

  Widget getWidgetByType(field, type, widget, BuildContext context) {
    if (type == 'string') {
      return TextFormField(
        controller: TextEditingController(
            text: (widget.docToEdit != null
                ? widget.docToEdit.data()[field.key]
                : '')),
        decoration: getInputDecoration(field),

        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      );
    } else if (type == 'dateTime') {
      var timestamp;
      if (widget.docToEdit != null &&
          widget.docToEdit.data()[field.key].runtimeType == Timestamp) {
        timestamp = widget.docToEdit.data()[field.key].seconds.ceil();
      } else {
        timestamp = ((DateTime.now().millisecondsSinceEpoch) / 1000).ceil();
      }
      DateTime date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var dateFieldController = TextEditingController(
          text: (widget.docToEdit != null ? formatTimestamp(date) : ''));
      return TextFormField(
        readOnly: true,
        controller: dateFieldController,
        decoration: getInputDecoration(field),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTap: () async {
          await selectDatePicker(context, dateFieldController, date);
        },
      );
    } else if (type == 'dropdown') {

      const PickerData2 = '''
[
    [
        "Created",
        "Assigned",
        "Completed"
    ]
]
    ''';
      TextEditingController dropdownController = TextEditingController(
          text: (widget.docToEdit != null
              ? widget.docToEdit.data()[field.key]
              : ''));
      return TextFormField(
        readOnly: true,
        controller: dropdownController,
        decoration: getInputDecoration(field),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTap: () async {

          showPickerArray(context, PickerData2, dropdownController);
        },
      );
    } else if (type == 'checkbox') {
      bool value = ((widget.docToEdit != null &&  widget.docToEdit.data()[field.key].runtimeType == bool)
          ? widget.docToEdit.data()[field.key]
          : false);

      return Tapbox(checked: value, label: field.label);
    }
  }

  showPickerArray(BuildContext context, PickerData, dropdownController) {

      new Picker(
          adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(PickerData), isArray: true),
          hideHeader: true,
          title: new Text("Select status"),
          onConfirm: (Picker picker, List value) {
            print(value.toString());
            print(picker.getSelectedValues());
            if (picker.getSelectedValues()[0] != null) {
              dropdownController.text = picker.getSelectedValues()[0].toString();
            }
          }
      ).showDialog(context);

  }

  String formatTimestamp(DateTime dateTime) {
    var format = new DateFormat('dd/MM/yyyy HH:mm');
    return format.format(dateTime);
  }

  Future<Null> selectDatePicker(BuildContext context,
      TextEditingController dateFieldController, DateTime date) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    if (pickedDate != null && pickedDate != date) {
      dateFieldController.text = pickedDate.toString();
      _selectTime(context, pickedDate, dateFieldController, date);
    }
  }

  Future<Null> _selectTime(BuildContext context, DateTime pickedDate,
      TextEditingController controller, DateTime date) async {
    TimeOfDay selectedTime = TimeOfDay(
        hour: date.hour != null ? date.hour : 00,
        minute: date.minute != null ? date.minute : 00);
    final TimeOfDay pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null) {
      var dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          pickedTime.hour, pickedTime.minute);
      controller.text = formatTimestamp(dateTime);
    }
  }
}

class FormField {
  final String type;
  final double widthFactor;
  final String key;
  String label;

  FormField(this.type, this.widthFactor, this.key, [this.label = 'label']);
}

getInputDecoration(field) {
  const ticketNumber = "N. d'intervention";
  const technicianName = "Nom du technician";
  const ticketDate = "Date d'intervention";
  const address = 'Adress';
  const ville = 'Ville';
  const codePostal = 'Code postal';
  const status = 'Statut';
  const callTime = "Heure d'appel";
  const arrivalTime = "Heure d'arrivé";
  const departureTime = "Heure de depart";
  const building = 'Batiment';
  const floorNo = 'Etage';
  const escalier = 'Escalier';
  const apartment = 'Apartment';
  const locatorName = 'Nom du locator';
  const telephone = 'telephone';
  const commonArea = 'Partie commune';
  const logement = 'Logement';
  const blackOut = 'Panne électrique';
  const waterLeak = "Fuite d'eau";
  const doorBlock = 'Porte bloquée';

  const isOneTechnician = 'Un technician';
  const isTwoTechnician = 'Deux technician';
  const putInSecurity = 'Mise en securité';
  const equipmentVerification = "Verification d'equipments";
  const conductorName = "Nom conducteur de travaux";
  const numberOfGardien = "N. Gardien";
  const nameOfGardien = "Nom/prénom du gardien";
  const reparationPreviewedCmt = "Réparation à prévoir commentaire";
  const waterLeakSearchCmt = "Recherche de fuite commentaire";
  const panneSearchCmt = "Recherche de panne commentaire";
  const reparationCmt = "Reparation commentaire";

  switch (field.key) {
    case 'technicianName':
      {
        return const InputDecoration(labelText: technicianName);
      }
    case 'ticketNumber':
      {
        return const InputDecoration(labelText: ticketNumber);
      }
    case 'ticketDate':
      {
        return const InputDecoration(labelText: ticketDate);
      }
    case 'address':
      {
        return const InputDecoration(labelText: address);
      }
    case 'ville':
      {
        return const InputDecoration(labelText: ville);
      }
    case 'codePostal':
      {
        return const InputDecoration(labelText: codePostal);
      }
    case 'status':
      {
        return const InputDecoration(labelText: status);
      }
    case 'callTime':
      {
        return const InputDecoration(labelText: arrivalTime);
      }
    case 'arrivalTime':
      {
        return const InputDecoration(labelText: arrivalTime);
      }
    case 'departureTime':
      {
        return const InputDecoration(labelText: departureTime);
      }
    case 'building':
      {
        return const InputDecoration(labelText: building);
      }
    case 'floorNo':
      {
        return const InputDecoration(labelText: floorNo);
      }
    case 'escalier':
      {
        return const InputDecoration(labelText: escalier);
      }
    case 'apartment':
      {
        return const InputDecoration(labelText: apartment);
      }
    case 'locatorName':
      {
        return const InputDecoration(labelText: locatorName);
      }
    case 'telephone':
      {
        return const InputDecoration(labelText: telephone);
      }
    case 'commonArea':
      {
        return const InputDecoration(labelText: commonArea);
      }
    case 'logement':
      {
        return const InputDecoration(labelText: logement);
      }
    case 'blackOut':
      {
        return const InputDecoration(labelText: blackOut);
      }
    case 'waterLeak':
      {
        return const InputDecoration(labelText: waterLeak);
      }
    case 'doorBlock':
      {
        return const InputDecoration(labelText: doorBlock);
      }

    case 'isOneTechnician':
      {
        return const InputDecoration(labelText: isOneTechnician);
      }
    case 'isTwoTechnician':
      {
        return const InputDecoration(labelText: isTwoTechnician);
      }
    case 'putInSecurity':
      {
        return const InputDecoration(labelText: putInSecurity);
      }
    case 'putInSecurity':
      {
        return const InputDecoration(labelText: putInSecurity);
      }
    case 'equipmentVerification':
      {
        return const InputDecoration(labelText: equipmentVerification);
      }
      case 'conductorName':
      {
        return const InputDecoration(labelText: conductorName);
      }
      case 'numberOfGardien':
      {
        return const InputDecoration(labelText: numberOfGardien);
      }
      case 'nameOfGardien':
      {
        return const InputDecoration(labelText: nameOfGardien);
      }
      case 'reparationPreviewedCmt':
      {
        return const InputDecoration(labelText: reparationPreviewedCmt);
      }
      case 'waterLeakSearchCmt':
      {
        return const InputDecoration(labelText: waterLeakSearchCmt);
      }
      case 'panneSearchCmt':
      {
        return const InputDecoration(labelText: panneSearchCmt);
      }
      case 'reparationCmt':
      {
        return const InputDecoration(labelText: reparationCmt);
      }

    default:
      {
        return const InputDecoration(labelText: ticketNumber);
      }
  }
}



// TapboxA manages its own state.

//------------------------- TapboxA ----------------------------------

class Tapbox extends StatefulWidget {
  bool checked;
  String label;
  Tapbox({@required this.checked, @required this.label});

  @override
  _TapboxState createState() => _TapboxState();
}

class _TapboxState extends State<Tapbox> {
  _TapboxState();
  @override
  void initState() {
   print(widget);
    super.initState();
  }

  void _handleTap() {
    setState(() {
      this.widget.checked = !this.widget.checked;
    });
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(this.widget.checked);
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(this.widget.label)),
            Checkbox(
              value: this.widget.checked,
              onChanged: (newValue) {
                _handleTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
