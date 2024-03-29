import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/widgets/clickable.dart';

class ListInstructions extends StatefulWidget {
  final TextEditingController instructionsController;
  final List<String> submittedInstructions;

  const ListInstructions({
    super.key,
    required this.instructionsController,
    required this.submittedInstructions,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListInstructionsState createState() => _ListInstructionsState();
}

class _ListInstructionsState extends State<ListInstructions> {
  bool showCheckIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          maxLines: null,
          controller: widget.instructionsController,
          decoration: InputDecoration(
            hintText: 'Add an instruction',
            filled: true,
            suffixIcon: Visibility(
              visible: showCheckIcon,
              child: IconButton(
                icon: const Icon(CupertinoIcons.check_mark_circled_solid,
                    color: ExtraColors.successLight),
                onPressed: () {
                  final value = widget.instructionsController.text.trim();
                  if (value.isNotEmpty) {
                    setState(() {
                      widget.submittedInstructions.add(value);
                      widget.instructionsController.clear();
                      showCheckIcon = false;
                    });
                  }
                },
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              showCheckIcon = value.isNotEmpty;
            });
          },
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 7),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: widget.submittedInstructions.isNotEmpty ? 7 : 0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.submittedInstructions.length,
          itemBuilder: (context, index) {
            final instruction = widget.submittedInstructions[index];
            final instructionNumber = index + 1;
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$instructionNumber. $instruction',
                      style: const TextStyle(
                        color: ExtraColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Clickable(
                    onClick: () {
                      setState(() {
                        widget.submittedInstructions.removeAt(index);
                      });
                    },
                    child: Icon(
                      CupertinoIcons.trash_fill,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
