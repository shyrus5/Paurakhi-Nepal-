import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paurakhi/src/core/API/Finance%20Query%20History/finance_query_api.dart';
import 'package:paurakhi/src/core/themes/appcolors.dart';
import 'package:paurakhi/src/core/themes/appstyles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'model/financequery_model.dart';

class FinanceQueryHistoryController extends GetxController {
  final RxList<Datum> financeHistoryList = <Datum>[].obs;
  final RxBool isLoading = false.obs;
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchfinanceHistory();
  }

  Future<void> fetchfinanceHistory() async {
    if (!isLoading.value) {
      isLoading.value = true;
      final FinanceHistoryModel? financeHistory =
          await FinanceEnquiryHistory.financeHistory(page);
      if (financeHistory != null && financeHistory.data.isNotEmpty) {
        financeHistoryList.addAll(financeHistory.data);
        page++; // Increment the page for the next API call
      }
      isLoading.value = false;
    }
  }

  Future<void> loadFinanceHistory() async {
    page = 1;
    financeHistoryList.clear();
    if (!isLoading.value) {
      isLoading.value = true;
      final FinanceHistoryModel? financeHistory =
          await FinanceEnquiryHistory.financeHistory(1);
      if (financeHistory != null && financeHistory.data.isNotEmpty) {
        financeHistoryList.addAll(financeHistory.data);
      }
      isLoading.value = false;
    }
  }
}

void financeHistoryScreen(BuildContext context) {
  final FinanceQueryHistoryController controller =
      Get.put(FinanceQueryHistoryController());

  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
    ),
    builder: (BuildContext context) {
      return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                      child: Text("Finance History",
                          style: AppStyles.text22PxBold)),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Obx(
                    () {
                      if (controller.financeHistoryList.isEmpty &&
                          controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (controller.financeHistoryList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              const Icon(
                                Icons.info_rounded,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 30),
                              Text("No history found!",
                                  style: AppStyles.text18PxMedium),
                            ],
                          ),
                        );
                      } else {
                        final bool isLoadMoreVisible =
                            controller.financeHistoryList.length > 9;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    controller.financeHistoryList.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index <
                                      controller.financeHistoryList.length) {
                                    final Datum datum =
                                        controller.financeHistoryList[index];

                                    return historyWidget(datum.purpose,
                                        datum.status, datum.value);
                                  } else if (controller.isLoading.value) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            color: AppColors.primary));
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                            if (isLoadMoreVisible &&
                                !controller.isLoading.value)
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 40,
                                    width: 120,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.find<
                                                FinanceQueryHistoryController>()
                                            .page++;

                                        controller.fetchfinanceHistory();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.textGreen,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.load_more,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.find<FinanceQueryHistoryController>()
                            //         .page++;

                            //     controller.fetchfinanceHistory();
                            //   },
                            //   child: const Padding(
                            //     padding: EdgeInsets.all(16.0),
                            //     child: Text('Load More',
                            //         style: TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.blue)),
                            //   ),
                            // ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ));
    },
  );
}

SizedBox historyWidget(product, status, price) {
  return SizedBox(
    height: 100,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.5,
      child: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: Text("$product", style: AppStyles.text20PxBold),
            trailing: status == "pending"
                ? const Icon(Icons.check_circle_rounded,
                    size: 30, color: Colors.grey)
                : status == "cancel"
                    ? const Icon(Icons.close_rounded,
                        size: 30, color: Colors.red)
                    : status == "approved"
                        ? const Icon(Icons.check_circle_rounded,
                            size: 30, color: Colors.green)
                        : const Icon(Icons.close_rounded,
                            size: 30, color: Colors.red),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),
              Text("Value : $price"),
            ]),
          ),
        ],
      ),
    ),
  );
}
