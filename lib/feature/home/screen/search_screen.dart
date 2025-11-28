import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HomeController controller = Get.find<HomeController>();
  late TextEditingController queryController;
  List<Map<String, dynamic>> allServices = [];
  List<Map<String, dynamic>> filtered = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    queryController = TextEditingController(text: widget.initialQuery ?? '');
    selectedCategory = widget.initialCategory;
    _buildAllServices();
    _applyFilter();
  }

  void _buildAllServices() {
    allServices = [];
    controller.categoryServices.forEach((category, services) {
      for (var s in services) {
        final entry = Map<String, dynamic>.from(s);
        entry['category'] = category;
        allServices.add(entry);
      }
    });
  }

  void _applyFilter() {
    final q = queryController.text.trim().toLowerCase();

    filtered = allServices.where((s) {
      final name = (s['name'] ?? '').toString().toLowerCase();
      final prof = (s['professional'] ?? '').toString().toLowerCase();
      final cat = (s['category'] ?? '').toString().toLowerCase();
      if (q.isEmpty && (selectedCategory != null && selectedCategory!.isNotEmpty)) {
        return cat == selectedCategory!.toLowerCase();
      }
      if (q.isEmpty) return true;
      return name.contains(q) || prof.contains(q) || cat.contains(q);
    }).toList();

    // Scoring and sorting: prefer category matches and exact/startsWith name matches
    filtered.sort((a, b) {
      final qLower = q;
      int score(Map<String, dynamic> s) {
        int sc = 0;
        final name = (s['name'] ?? '').toString().toLowerCase();
        final prof = (s['professional'] ?? '').toString().toLowerCase();
        final cat = (s['category'] ?? '').toString().toLowerCase();
        if (selectedCategory != null && selectedCategory!.isNotEmpty && cat == selectedCategory!.toLowerCase()) sc += 50;
        if (qLower.isNotEmpty) {
          if (name == qLower) sc += 40;
          else if (name.startsWith(qLower)) sc += 20;
          else if (name.contains(qLower)) sc += 8;
          if (prof.contains(qLower)) sc += 4;
          if (cat.contains(qLower)) sc += 6;
        }
        // fallback: higher rating preferred
        sc += ((s['rating'] ?? 0) as num).toInt();
        return sc;
      }

      return score(b).compareTo(score(a));
    });

    setState(() {});
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff252525)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff252525),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Icon(Icons.search, color: Color(0xff9E9E9E)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search for plumber, electrician...',
                        hintStyle: GoogleFonts.roboto(fontSize: 14.sp, color: Color(0xff9E9E9E)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (_) => _applyFilter(),
                    ),
                  ),
                  if ((selectedCategory ?? '').isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Color(0xffFFEBEB),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          selectedCategory ?? '',
                          style: GoogleFonts.roboto(color: Color(0xffCC0000), fontSize: 12.sp),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // Optionally show category chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.categories.map((c) {
                  final name = c['name'] ?? '';
                  final isSelected = selectedCategory == name;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(name, style: GoogleFonts.roboto(fontSize: 12.sp)),
                      selected: isSelected,
                      onSelected: (v) {
                        setState(() {
                          selectedCategory = v ? name : null;
                          _applyFilter();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No results', style: GoogleFonts.roboto(color: Color(0xff9E9E9E))))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final s = filtered[index];
                        return GestureDetector(
                          onTap: () {
                            final pid = s['professionalId'] as int?;
                            if (pid != null) {
                              Get.to(() => ProfessionalDetailsScreen(professionalId: pid));
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: s['image'] != null
                                      ? Image.asset(
                                          s['image'],
                                          width: 64.w,
                                          height: 64.h,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(width: 64.w, height: 64.h, color: Color(0xffF5F5F5)),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s['name'] ?? '', style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          Expanded(child: Text(s['professional'] ?? '', style: GoogleFonts.roboto(fontSize: 12.sp, color: Color(0xff757575)))),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Color(0xffFFB800), size: 14.sp),
                                          SizedBox(width: 6.w),
                                          Text('${s['rating'] ?? ''} (${s['reviews'] ?? 0} Reviews)', style: GoogleFonts.roboto(fontSize: 12.sp, color: Color(0xff757575))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
