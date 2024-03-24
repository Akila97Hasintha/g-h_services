import 'package:flutter/material.dart';

class RowContainer extends StatefulWidget {
  final int selectedContainerIndex; // New property to store the selected index
  final Function(int) onContainerSelected; // Callback function for container selection

  const RowContainer({
    Key? key,
    required this.selectedContainerIndex,
    required this.onContainerSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RowContainerState();
}

class _RowContainerState extends State<RowContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Container 1
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Call the callback function to update the selected index
              widget.onContainerSelected(0);
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                border: Border.all(
                  color: widget.selectedContainerIndex == 0 ? Colors.blue : const Color.fromARGB(255, 114, 113, 113),
                  width: 1.5,
                ),
                color: widget.selectedContainerIndex == 0 ? Colors.blue : Colors.white,
              ),
              child: Center(
                child: Text("IN", style: TextStyle(color: widget.selectedContainerIndex == 0 ? Colors.white : Colors.blue, fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ),
        // Container 2
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Call the callback function to update the selected index
              widget.onContainerSelected(1);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.selectedContainerIndex == 1 ? Colors.blue : const Color.fromARGB(255, 114, 113, 113),
                  width: 1.5,
                ),
                color: widget.selectedContainerIndex == 1 ? Colors.blue : Colors.white,
              ),
              child: Center(
                child: Text(
                  "OUT",
                  style: TextStyle(
                    color: widget.selectedContainerIndex == 1 ? Colors.white : Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Container 3
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Call the callback function to update the selected index
              widget.onContainerSelected(2);
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                border: Border.all(
                  color: widget.selectedContainerIndex == 2 ? Colors.blue : const Color.fromARGB(255, 114, 113, 113),
                  width: 1.5,
                ),
                color: widget.selectedContainerIndex == 2 ? Colors.blue : Colors.white,
              ),
              child: Center(
                child: Text(
                  "OTHER",
                  style: TextStyle(
                    color: widget.selectedContainerIndex == 2 ? Colors.white : Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
