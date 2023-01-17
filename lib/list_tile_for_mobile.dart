import 'package:flutter/material.dart';
import 'package:password_generator/password_model.dart';
import 'package:provider/provider.dart';

class ListTileForMobile extends StatelessWidget {
  const ListTileForMobile({
    super.key,
    required this.minValue,
    required this.maxValue,
  });
  final int minValue;
  final int maxValue;

  Iterable<int> range(int start, int end) {
    return Iterable<int>.generate(end - start + 1).map((e) => e + start);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('長さ'),
          Text(context.watch<PasswordModel>().length.toString()),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (builderContext) {
            return SimpleDialog(
              children: range(minValue, maxValue)
                  .map(
                    (value) => SimpleDialogOption(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value.toString()),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(builderContext, value);
                        context.read<PasswordModel>().setLength(value);
                      },
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}
