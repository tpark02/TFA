import 'package:flutter/material.dart';

class RecentSearchItem extends StatelessWidget {
  const RecentSearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // your code here
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            // Icon(
            //   Icons.near_me,
            //   color: Color.fromRGBO(0, 140, 255, 1),
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Seoul",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Aug 9 - Aug 10",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "|",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.bed, color: Colors.grey[500]),
                      const SizedBox(width: 10),
                      Text(
                        "1",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.person, color: Colors.grey[500]),
                      const SizedBox(width: 10),
                      Text(
                        "2",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
