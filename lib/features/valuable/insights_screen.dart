import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/valuable/AddInsightScreen.dart';
import '../../core/utils/shared_preference.dart';
import '../../main.dart';
import 'category_model.dart';
import 'insight_controller.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final InsightController controller = Get.put(InsightController());

  String icons = '';
  String id = '';

  void _showReportSheet(String insightId) async {
    final reasons = await controller.getReportReasons();
    if (reasons.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          itemCount: reasons.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final reason = reasons[index];
            return ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(reason.label),
              subtitle: Text(reason.description),
              onTap: () async {
                Navigator.pop(context);
                await controller.reportInsight(
                    insightId, reason.description, context);
                rootScaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text(
                        'We have received your report and will evaluate the insight, meanwhile try to ignore the noise!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInsightScreen(id: id),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.insightsResponse.value;
        if (data == null) {
          // 🔹 Empty State with RefreshIndicator
          return RefreshIndicator(
            onRefresh: controller.refreshInsights,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _emptyStateImage(),
              ],
            ),
          );
        }

        // set default icon & id
        if (icons.isEmpty && data.categories.isNotEmpty) {
          icons = data.categories.first.iconUrl ?? '';
          id = data.categories.first.id ?? '';
        }

        // 🔹 Main Content
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: AppColors.whiteColor,
                surfaceTintColor: AppColors.whiteColor,
                title: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        size: 28, color: AppColors.primaryColor),
                    const SizedBox(width: 6),
                    const Text("Valuable Insights"),
                  ],
                ),
                centerTitle: true,
                elevation: 0,
                pinned: true,
                floating: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    data.locationSummary,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabHeaderDelegate(
                  child: Container(
                    color: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Obx(() {
                      final selected = controller.selectedCategorySlug.value;
                      return SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.categories.length,
                          itemBuilder: (context, index) {
                            final cat = data.categories[index];
                            final isSelected = selected == cat.slug;

                            return GestureDetector(
                              onTap: () {
                                controller.selectCategory(cat.slug);
                                setState(() {
                                  icons = cat.iconUrl ?? '';
                                  id = cat.id ?? '';
                                });
                              },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    cat.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: controller.refreshInsights,
            child: Obx(() {
              final insights = controller.currentInsights;

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (insights.isEmpty) {
                // 🔹 Empty State still refreshable
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 240),
                    _emptyStateImage(),
                  ],
                );
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: insights.length,
                itemBuilder: (context, index) {
                  final item = insights[index];
                  return _buildInsightCard(item);
                },
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _emptyStateImage() {
    return Center(
      child: ClipRRect(
        child: Image.network(
          'https://file-storage-bucket-mumbai.s3.ap-south-1.amazonaws.com/cb765fbc-183b-495a-a74b-3639ec1c9e3f-o%20%281%29.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            width: 40,
            height: 40,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(InsightModel item) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    icons,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 30,
                        height: 30,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.summary,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              children: [
                if (item.statusTag != null)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.statusTag!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      controller.voteOnInsight(item.id, 'cheer', context),
                  child: Icon(Icons.thumb_up_alt_outlined,
                      size: 18,
                      color: (item.userVote!.hasVoted &&
                          item.userVote!.voteType == 'cheer')
                          ? Colors.orange
                          : Colors.grey),
                ),
                const SizedBox(width: 4),
                Text("${item.cheers}"),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () =>
                      controller.voteOnInsight(item.id, 'boo', context),
                  child: Icon(Icons.thumb_down_alt_outlined,
                      size: 18,
                      color: (item.userVote!.hasVoted &&
                          item.userVote!.voteType == 'boo')
                          ? AppColors.primaryColor
                          : Colors.grey),
                ),
                const SizedBox(width: 4),
                Text("${item.boos}"),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showReportSheet(item.id),
                  child: const Icon(Icons.flag_outlined,
                      size: 18, color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _TabHeaderDelegate({required this.child});

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_TabHeaderDelegate oldDelegate) => false;
}
