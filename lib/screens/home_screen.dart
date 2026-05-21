import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Медицинский центр "Здоровье"'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Баннер
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade600, Colors.blue.shade300],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Ваше здоровье — наша забота',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Современные технологии. Опытные врачи.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // О нас
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'О медицинском центре',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Наш медицинский центр предоставляет широкий спектр медицинских услуг. Мы работаем с 2010 года и за это время помогли более 50 000 пациентов.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '✅ Лицензия на медицинскую деятельность\n'
                        '✅ Современное оборудование\n'
                        '✅ Опытные врачи высшей категории\n'
                        '✅ Удобное расположение\n'
                        '✅ Онлайн-запись на приём',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.8),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Наши преимущества
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Наши преимущества',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildAdvantageCard(
                          icon: Icons.schedule,
                          title: 'Удобное время',
                          description: 'Работаем с 8:00 до 20:00 без выходных',
                        ),
                        const SizedBox(width: 16),
                        _buildAdvantageCard(
                          icon: Icons.verified,
                          title: 'Лицензия',
                          description: 'Все услуги лицензированы',
                        ),
                        const SizedBox(width: 16),
                        _buildAdvantageCard(
                          icon: Icons.local_hospital,
                          title: 'Современное оборудование',
                          description: 'Экспертный класс точности',
                        ),
                        const SizedBox(width: 16),
                        _buildAdvantageCard(
                          icon: Icons.people_alt,
                          title: 'Опытные врачи',
                          description: 'Стаж от 10 лет',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Контакты
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Контакты',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: const Text('Адрес'),
                    subtitle: const Text('г. Москва, ул. Медицинская, д. 15'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: const Text('Телефон'),
                    subtitle: const Text('+7 (495) 123-45-67'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blue),
                    title: const Text('Email'),
                    subtitle: const Text('info@medcenter.ru'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blue),
                    title: const Text('Режим работы'),
                    subtitle: const Text('Ежедневно с 8:00 до 20:00'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}