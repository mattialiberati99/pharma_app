import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../providers/user_provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _nameController = TextEditingController();
  final _mailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = currentUser.value.name ?? 'Tac User';
    _mailController.text = currentUser.value.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informazioni Personali",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            label: Text("Nome"),
            enabled: false,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          controller: _mailController,
          decoration: InputDecoration(
            label: Text("Email"),
            enabled: false,
          ),
        )
      ],
    );
  }
}
