import 'package:flutter/material.dart';

class SelfWithdrawal extends StatelessWidget {
  const SelfWithdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0 , right: 20.0 , left: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withAlpha(100),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0,),
                const Text(
                  'معرف وكيل الشحن',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('بحث'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Mohamed Yousri'),
                    Text('id'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withAlpha(100),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0,),
                const Text(
                  'قيمه السحب',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('اسحب'),
            ),
          ],
        ),
      ),
    );
  }
}
