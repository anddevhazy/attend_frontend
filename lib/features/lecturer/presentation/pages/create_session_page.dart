import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/presentation/bloc/lecturer_cubit.dart';
import 'package:attend/features/location/location_entity.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  CourseEntity? selectedCourse;
  LocationEntity? selectedLocation;

  bool get canStart => selectedCourse != null && selectedLocation != null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LecturerCubit, LecturerState>(
      listener: (context, state) {
        if (state is CoursesFetched) {
          _showCoursePicker(context, state.courses);
        }

        if (state is LocationsFetched) {
          _showLocationPicker(context, state.locations);
        }

        if (state is Successful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );

          context.goNamed(
            Routes.lecturerHomeName,
            queryParameters: {"status": "active"},
          );
        }

        if (state is Failed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Create Session',
            style: AppTextStyles.h2.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
        ),

        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                0,
                AppSpacing.sm,
                120,
              ),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: AppColors.primary.withOpacity(0.06),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Session setup',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Select course, venue and duration',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary.withOpacity(
                                      0.65,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(AppAssets.createSessionHero, height: 62),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      const _DividerLight(),
                      const SizedBox(height: AppSpacing.lg),

                      const _SectionTitle('Course'),
                      const SizedBox(height: AppSpacing.md),

                      _DropdownTile(
                        label: "Select course",
                        value:
                            selectedCourse == null
                                ? null
                                : "${selectedCourse!.courseCode} – ${selectedCourse!.name}",
                        onTap: () {
                          context.read<LecturerCubit>().getCourses();
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      const _SectionTitle('Lecture venue'),
                      const SizedBox(height: AppSpacing.md),

                      _DropdownTile(
                        label: "Where is this class holding?",
                        value: selectedLocation?.name,
                        onTap: () {
                          context.read<LecturerCubit>().getLocations();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed:
                    canStart
                        ? () {
                          final session = SessionEntity(
                            sessionId: "",
                            course: selectedCourse!,
                            location: selectedLocation!,
                            isLive: true,
                            sessionDate: DateTime.now(),
                          );

                          context.read<LecturerCubit>().startSession(session);
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.25),
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  'Start Attendance Session',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCoursePicker(BuildContext context, List<CourseEntity> courses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _BottomSheetPicker<CourseEntity>(
          title: "Select course",
          items: courses,
          selected: selectedCourse,
          labelBuilder: (c) => "${c.courseCode} – ${c.name}",
          onSelected: (course) {
            setState(() => selectedCourse = course);
          },
        );
      },
    );
  }

  void _showLocationPicker(
    BuildContext context,
    List<LocationEntity> locations,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _BottomSheetPicker<LocationEntity>(
          title: "Where is this class holding?",
          items: locations,
          selected: selectedLocation,
          labelBuilder: (l) => l.name ?? "Unknown location",
          onSelected: (location) {
            setState(() => selectedLocation = location);
          },
        );
      },
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _DropdownTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;

    return Material(
      borderRadius: BorderRadius.circular(18),
      color: AppColors.primary.withOpacity(0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasValue ? value! : label,
                  style:
                      hasValue
                          ? AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )
                          : AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.55),
                            fontWeight: FontWeight.w700,
                          ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accent,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetPicker<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  const _BottomSheetPicker({
    required this.title,
    required this.items,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    final isSelected = item == selected;

                    return ListTile(
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            isSelected
                                ? AppColors.accent
                                : AppColors.textPrimary.withOpacity(0.25),
                      ),
                      title: Text(labelBuilder(item)),
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DividerLight extends StatelessWidget {
  const _DividerLight();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.primary.withOpacity(0.06));
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }
}
