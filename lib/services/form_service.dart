import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormService {
  getInfoFields(widget) {
    var infoFieldsList = [
      FormField('string', 0.5, 'ticketNumber'),
      FormField('string', 0.5, 'ticketDate'),
      FormField('string', 0.5, 'address'),
      FormField('string', 0.5, 'ville'),
      FormField('string', 0.5, 'codePostal'),
      FormField('string', 0.5, 'status'),
      FormField('string', 0.5, 'arrivalTime'),
      FormField('string', 0.5, 'departureTime'),
      FormField('string', 0.5, 'building'),
      FormField('string', 0.5, 'floorNo'),
      FormField('string', 0.5, 'escalier'),
      FormField('string', 0.5, 'apartment'),
      FormField('string', 0.5, 'locatorName'),
      FormField('string', 0.5, 'telephone'),
    ];

    return infoFieldsList;
  }

  buildForm(fields) {
    return [];
  }

  List<Widget> getFormFieldsWidgets(fieldsList, widget) {
    List<Widget> formWidgets = [];
    fieldsList.forEach((field) =>
        {formWidgets.add(getFormWidget(field, widget))});
    return formWidgets;
  }

  Widget getFormWidget(field, widget) {
    var fieldKey = field.key;
    return FractionallySizedBox(
      widthFactor: field.widthFactor,
      child: TextFormField(
        controller: TextEditingController(
            text: (widget.docToEdit != null
                ? widget.docToEdit.data()[fieldKey]
                : '')),
        decoration: getInputDecoration(field),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}

class FormField {
  final String fieldType;
  final double widthFactor;
  final String key;

  FormField(this.fieldType, this.widthFactor, this.key);
}

getTextForField(fieldKey) {}

getInputDecoration(field) {
  const ticketNumber = 'Ticket number';
  const ticketDate = 'Ticket date';
  const address = 'Address';
  const ville = 'Ville';
  const codePostal = 'Code postal';
  const status = 'Status';
  const arrivalTime = 'Arrival time';
  const departureTime = 'Departure time';
  const building = 'Building';
  const floorNo = 'Floor number';
  const escalier = 'Escalier';
  const apartment = 'Apartment';
  const locatorName = 'Locator name';
  const telephone = 'telephone';
  switch (field.key) {

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
    default:
      {
        return const InputDecoration(labelText: ticketNumber);
      }
  }
}
