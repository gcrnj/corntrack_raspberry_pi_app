import 'package:flutter/material.dart';

class EditableNameWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onSubmitted;

  const EditableNameWidget({super.key, required this.text, required this.onSubmitted});

  @override
  State<EditableNameWidget> createState() => _EditableNameWidgetState();
}

class _EditableNameWidgetState extends State<EditableNameWidget> {
  bool _isEditing = false;
  late final TextEditingController _controller =
      TextEditingController(text: widget.text);

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
                  widget.onSubmitted(_controller.value.text);
                  Future.microtask(() {
                    if (mounted) {
                      setState(() {
                        _isEditing = false;
                      });
                    }
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
                onPressed: () {},
                child: Text('Show QR Code', style: TextStyle(fontSize: 10),),
              ),
              IconButton(
                onPressed: () {
                  if(_isEditing) {
                    widget.onSubmitted(_controller.value.text);
                  }
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
