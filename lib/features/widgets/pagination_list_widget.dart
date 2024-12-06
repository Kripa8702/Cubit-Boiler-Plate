import 'package:event_ticketing/utils/size_utils.dart';
import 'package:flutter/material.dart';

class PaginationListWidget extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Function() loadNextPage;
  final bool showLoadingIndicator;

  const PaginationListWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.loadNextPage,
    this.showLoadingIndicator = false,
  });

  @override
  State<PaginationListWidget> createState() => _PaginationListWidgetState();
}

class _PaginationListWidgetState extends State<PaginationListWidget> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          controller.offset <= controller.position.maxScrollExtent + 100) {

        widget.loadNextPage();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            separatorBuilder: (context, index) {
              return SizedBox(height: 16.h);
            },
          ),
        ),
        if (widget.showLoadingIndicator) ...[
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50.h,
              width: double.maxFinite,
              child: Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.only(top: 16.h),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.h,
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50.h,
          ),
        ),
      ],
    );
  }
}
