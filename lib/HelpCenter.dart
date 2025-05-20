import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'What is TDS?',
      'answer':
          'TDS stands for Total Dissolved Solids, which includes all minerals and impurities in the water.',
    },
    {
      'question': 'Why is PH important?',
      'answer':
          'PH level indicates the acidity or alkalinity of water. It should be between 6.5 and 8.5 for drinking water.',
    },
    {
      'question': 'How does EC affect water quality?',
      'answer':
          'Electrical Conductivity (EC) measures how well water can conduct electricity, which relates to the mineral content.',
    },
    {
      'question': 'What is Turbidity?',
      'answer':
          'Turbidity refers to the cloudiness or haziness of water caused by large numbers of particles.',
    },
    {
      'question': 'Can I use this app offline?',
      'answer':
          'Currently, this app requires an internet connection to fetch live and historical data from Firebase.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091534),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Help Center",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: faqList.length,
                separatorBuilder: (context, index) => const Divider(color: Color.fromARGB(255, 164, 162, 162)),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        faqList[index]['question']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Color(0xFF091534),
                        ),
                      ),
                      children: [
                        Text(
                          faqList[index]['answer']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromARGB(255, 2, 39, 103)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Text(
                    "Still need help?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        "support@hydrosense.com",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "+91 9999999999",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
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
