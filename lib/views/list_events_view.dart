import 'package:flutter/material.dart';
import 'package:meetup/views/widgets/app_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';

class ListEventsView extends StatefulWidget {
  const ListEventsView({super.key});

  @override
  State<ListEventsView> createState() => _ListEventsViewState();
}

class _ListEventsViewState extends State<ListEventsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    });
  }

  Future<void> _refreshEvents() async {
    await Provider.of<EventViewModel>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear evento',
            onPressed: () {
              Navigator.pushNamed(context, '/choose-event-creation');
            },
          ),
        ],
      ),
      drawer: const AppDrawerWidget(),
      body:
          eventViewModel.isLoading && eventViewModel.events.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refreshEvents,
                child:
                    eventViewModel.events.isEmpty
                        ? ListView(
                          children: [
                            SizedBox(
                              height: 400,
                              child: Center(
                                child: Text('No hay eventos disponibles.'),
                              ),
                            ),
                          ],
                        )
                        : ListView.builder(
                          itemCount: eventViewModel.events.length,
                          itemBuilder: (context, index) {
                            final event = eventViewModel.events[index];
                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                title: Text(event.name),
                                subtitle: Text(
                                  '${event.category} - ${event.location}',
                                ),
                                trailing: Text(
                                  event.startTime.toLocal().toString().split(
                                    ' ',
                                  )[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  // Aquí puedes navegar a un detalle de evento si deseas
                                },
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
