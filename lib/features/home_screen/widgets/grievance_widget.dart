import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';

import 'package:ysr_project/features/home_screen/response_model/grievance_response_model.dart';
import 'package:ysr_project/features/home_screen/response_model/grievance_status.dart';

class GrievanceWidget extends ConsumerStatefulWidget {
  final Grievance grievance;

  const GrievanceWidget({super.key, required this.grievance});

  @override
  _GrievanceWidgetState createState() => _GrievanceWidgetState();
}

class _GrievanceWidgetState extends ConsumerState<GrievanceWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.grievance;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: g.status == 'Open'
                                  ? Colors.blue
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              g.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              g.grievanceReason,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Grievance ID: ${g.grievanceId}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ],
            ),
          ),

          // Expanded section
          if (_expanded)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow(Icons.person, 'Gender', g.gender),
                  _buildDetailRow(Icons.phone, 'Mobile', g.mobile),
                  _buildDetailRow(Icons.email, 'Email', g.email),
                  _buildDetailRow(
                      Icons.location_on, 'Parliament', g.parliament),
                  _buildDetailRow(Icons.location_city, 'Assembly', g.assembly),
                  _buildDetailRow(
                      Icons.description, 'Description', g.grievanceDescription),
                  _buildDetailRow(Icons.badge, 'ID Proof', g.idProofType),
                  _buildDetailRow(Icons.calendar_today, 'Created',
                      _formatDate(g.createdAt)),
                  const SizedBox(height: 16),

                  // ID Proof Image
                  if (g.idProofPath.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ID Proof:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InstaImageViewer(
                            child: Image.network(
                              g.idProofPath,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator.adaptive(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (g.selfiePath.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selfie:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InstaImageViewer(
                            child: Image.network(
                              g.selfiePath,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator.adaptive(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  FutureBuilder<List<GrievanceStatus>>(
                    future: ref
                        .read(homeFeedRepoProvider)
                        .getGrievanceHistory(g.grievanceId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle the error case
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Handle the case where no data is available
                        return Text('No grievance history available');
                      } else {
                        final data = snapshot.data!;
                        late List<GrievanceStatus> sortedUpdates;
                        if (data.isEmpty) {
                          return SizedBox.shrink();
                        } else if (data.length == 1) {
                          sortedUpdates = [data[0]];
                        } else {
                          sortedUpdates = data;
                          sortedUpdates.sort((a, b) =>
                              DateTime.parse(a.updatedAt.toString()).compareTo(
                                  DateTime.parse(b.updatedAt.toString())));
                        }
                        return Stepper(
                            type: StepperType.vertical,
                            controlsBuilder: (context, _) => SizedBox.shrink(),
                            currentStep: sortedUpdates.length - 1,
                            physics: ScrollPhysics(),
                            steps: [
                              Step(
                                title: Text("open"),
                                subtitle: Text(
                                  "created grievance",
                                  style: TextStyle(fontSize: 12),
                                ),
                                content: SizedBox.shrink(),
                                isActive: true,
                                state: StepState.complete,
                              ),
                              ...List.generate(sortedUpdates.length, (index) {
                                final update = sortedUpdates[index];
                                return Step(
                                  title: Text(update.status),
                                  subtitle: Text(
                                    update.reason,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  content: SizedBox.shrink(),
                                  isActive: true,
                                  state: StepState.complete,
                                );
                              }),
                            ]);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
