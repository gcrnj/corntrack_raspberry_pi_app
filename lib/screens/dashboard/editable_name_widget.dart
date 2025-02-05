import 'package:flutter/material.dart';

class EditableNameWidget extends StatefulWidget {
  const EditableNameWidget({super.key});

  @override
  State<EditableNameWidget> createState() => _EditableNameWidgetState();
}

class _EditableNameWidgetState extends State<EditableNameWidget> {
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController(text: 'Main System');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Name'),
        _isEditing
            ? TextField(
                controller: _controller,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                autofocus: true,
                onSubmitted: (value) {
                  setState(() {
                    _isEditing = false;
                  });
                },
              )
            : Text(
                _controller.text,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: [
              FilledButton(
                onPressed: () {

                },
                child: Text('Show QR Code'),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
