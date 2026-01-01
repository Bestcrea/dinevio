import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:customer/app/modules/parcel_ride_details/controllers/parcel_ride_details_controller.dart';
import 'package:customer/app/modules/parcel_ride_details/views/parcel_ride_details_view.dart';
import 'package:customer/app/modules/reason_for_parcel_cancel/views/parcel_reason_for_cancel_view.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/currency_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/parcel_rides_controller.dart';

class ParcelRidesView extends StatelessWidget {
  const ParcelRidesView({super.key});

  /// Safely get substring with length check
  static String _safeSubstring(String? text, int length) {
    if (text == null || text.isEmpty) {
      return 'N/A';
    }
    if (text.length <= length) {
      return text;
    }
    return text.substring(0, length);
  }

  /// Build loading state UI with premium design
  Widget _buildLoadingState(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Consistent spacing: 24
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppThemData.primary500,
                ),
              ),
            ),
            const SizedBox(height: 16), // Consistent spacing: 16
            Text(
              'Loading parcels...'.tr,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: themeChange.isDarkTheme() 
                    ? AppThemData.grey400 
                    : AppThemData.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state UI with premium design
  Widget _buildEmptyState(BuildContext context, int selectedType) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    final String title;
    final String subtitle;
    final IconData icon;
    
    switch (selectedType) {
      case 0:
        title = "No Active Parcels".tr;
        subtitle = "You don't have any active parcel deliveries".tr;
        icon = Icons.inbox_outlined;
        break;
      case 1:
        title = "No Ongoing Parcels".tr;
        subtitle = "You don't have any ongoing parcel deliveries".tr;
        icon = Icons.local_shipping_outlined;
        break;
      case 2:
        title = "No Completed Parcels".tr;
        subtitle = "You don't have any completed parcel deliveries".tr;
        icon = Icons.check_circle_outline;
        break;
      default:
        title = "No Rejected Parcels".tr;
        subtitle = "You don't have any rejected parcel deliveries".tr;
        icon = Icons.cancel_outlined;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Consistent spacing: 24
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: themeChange.isDarkTheme() 
                    ? AppThemData.grey900 
                    : AppThemData.grey50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: themeChange.isDarkTheme() 
                    ? AppThemData.grey600 
                    : AppThemData.grey400,
              ),
            ),
            const SizedBox(height: 24), // Consistent spacing: 24
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700, // Bold for title
                color: themeChange.isDarkTheme() 
                    ? AppThemData.grey25 
                    : AppThemData.grey950,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Consistent spacing: 8
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() 
                      ? AppThemData.grey400 
                      : AppThemData.grey600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
            return GetBuilder<ParcelRidesController>(
        init: ParcelRidesController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "My Rides".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            //   isUnderlineShow: false,
            // ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RoundShapeButton(
                            title: "Active".tr,
                            buttonColor: controller.selectedType.value == 0
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 0
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 0;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "OnGoing".tr,
                            buttonColor: controller.selectedType.value == 1
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 1 ? AppThemData.black : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                            onTap: () {
                              controller.selectedType.value = 1;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "Completed".tr,
                            buttonColor: controller.selectedType.value == 2
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 2
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 2;
                            },
                            size: Size((Responsive.width(100, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "Cancelled".tr,
                            buttonColor: controller.selectedType.value == 3
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 3
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 3;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                RefreshIndicator(
                  onRefresh: () async {
                    if (controller.selectedType.value == 0) {
                      await controller.getData(isActiveDataFetch: true, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 1) {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: true, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 2) {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: true, isRejectedDataFetch: false);
                    } else {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: true);
                    }
                  },
                  child: SizedBox(
                    height: Responsive.height(75, context),
                    child: Obx(
                      () {
                        // Show loading state
                        if (controller.isLoading.value) {
                          return _buildLoadingState(context);
                        }
                        
                        // Determine which list to use based on selected type
                        final bool hasData = controller.selectedType.value == 0
                            ? controller.activeRides.isNotEmpty
                            : controller.selectedType.value == 1
                                ? controller.ongoingRides.isNotEmpty
                                : controller.selectedType.value == 2
                                    ? controller.completedRides.isNotEmpty
                                    : controller.rejectedRides.isNotEmpty;
                        
                        // Get the appropriate list
                        final List<ParcelModel> currentList = controller.selectedType.value == 0
                            ? controller.activeRides
                            : controller.selectedType.value == 1
                                ? controller.ongoingRides
                                : controller.selectedType.value == 2
                                    ? controller.completedRides
                                    : controller.rejectedRides;
                        
                        // Show empty state if no data
                        if (!hasData || currentList.isEmpty) {
                          return _buildEmptyState(context, controller.selectedType.value);
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: currentList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Defensive check: ensure index is valid
                            if (index < 0 || index >= currentList.length) {
                              return const SizedBox.shrink();
                            }
                            
                            RxBool isOpen = false.obs;
                            ParcelModel parcelModel = currentList[index];
                            
                            // Defensive check: ensure parcelModel is not null
                            if (parcelModel.id == null || parcelModel.id!.isEmpty) {
                              return const SizedBox.shrink();
                            }
                                return GestureDetector(
                                  onTap: () {
                                    isOpen.value = !isOpen.value;
                                  },
                                  child: Container(
                                    width: Responsive.width(100, context),
                                    padding: const EdgeInsets.all(16), // Consistent spacing: 16
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Consistent spacing: 16, 8
                                    decoration: BoxDecoration(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey950 : Colors.white,
                                      borderRadius: BorderRadius.circular(18), // BorderRadius ~18
                                      border: Border.all(
                                        width: 1,
                                        color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06), // Subtle shadow (opacity <= 0.08)
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              parcelModel.bookingTime == null ? "" : parcelModel.bookingTime!.toDate().dateMonthYear(),
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(width: 8), // Consistent spacing: 8
                                            Container(
                                              height: 12,
                                              width: 1,
                                              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
                                            ),
                                            const SizedBox(width: 8), // Consistent spacing: 8
                                            Expanded(
                                              child: Text(
                                                parcelModel.bookingTime == null ? "" : parcelModel.bookingTime!.toDate().time(),
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                // InterCityRideDetailsController detailsController = Get.put(InterCityRideDetailsController());
                                                // detailsController.bookingId.value = interCityModel.id ?? '';
                                                // detailsController.interCityModel.value = interCityModel;
                                                // Get.to(const InterCityRideDetailsView());
                                                ParcelRideDetailsController detailsController = Get.put(ParcelRideDetailsController());
                                                detailsController.bookingId.value = parcelModel.id ?? '';
                                                detailsController.parcelModel.value = parcelModel;
                                                Get.to(const ParcelRideDetailsView());
                                              },
                                              child: Icon(
                                                Icons.keyboard_arrow_right_sharp,
                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 12), // Consistent spacing: 12
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12), // Clean rounded corners
                                                child: CachedNetworkImage(
                                                  height: 56, // Slightly smaller for better proportion
                                                  width: 56,
                                                  imageUrl: (Constant.userModel?.profilePic != null && Constant.userModel!.profilePic!.isNotEmpty) ? Constant.userModel!.profilePic! : Constant.profileConstant,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    height: 56,
                                                    width: 56,
                                                    color: AppThemData.grey200,
                                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                                  ),
                                                  errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                                ),
                                              ),
                                              const SizedBox(width: 12), // Consistent spacing: 12
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ID: #${_safeSubstring(parcelModel.id, 5)}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4), // Consistent spacing: 4 (small gap)
                                                    Visibility(
                                                      visible: parcelModel.otp != null && parcelModel.otp!.isNotEmpty,
                                                      child: Text(
                                                        'OTP: ${parcelModel.otp}',
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey600,
                                                          fontSize: 13, // Slightly smaller for secondary info
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   (bookingModel.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                                                    //   style: GoogleFonts.inter(
                                                    //     color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                    //     fontSize: 14,
                                                    //     fontWeight: FontWeight.w400,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16), // Consistent spacing: 16
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    CurrencyFormatter.formatMoneyMADFromString(
                                                      Constant.calculateParcelFinalAmount(parcelModel).toString(),
                                                    ),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 18, // Slightly larger for emphasis
                                                      fontWeight: FontWeight.w700, // Bold for price
                                                      letterSpacing: -0.3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8), // Consistent spacing: 8
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.scale_outlined,
                                                        size: 18, // Consistent icon size
                                                        color: AppThemData.primary500,
                                                      ),
                                                      const SizedBox(width: 6), // Consistent spacing: 6
                                                      Text(
                                                        '${parcelModel.weight ?? 'N/A'}',
                                                        style: GoogleFonts.inter(
                                                          color: AppThemData.primary500,
                                                          fontSize: 14, // Consistent font size
                                                          fontWeight: FontWeight.w600, // Medium weight
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(
                                          () => Visibility(
                                            visible: isOpen.value,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 12), // Consistent spacing: 12
                                                PickDropPointView(pickUpAddress: parcelModel.pickUpLocationAddress ?? '', dropAddress: parcelModel.dropLocationAddress ?? ''),
                                                const SizedBox(height: 16), // Consistent spacing: 16
                                                parcelModel.bookingStatus == BookingStatus.bookingPlaced
                                                    ?   Constant.isParcelBid == false   ?
                                                RoundShapeButton(
                                                  title: "Cancel Ride".tr,
                                                  buttonColor: AppThemData.danger_500p,
                                                  buttonTextColor: AppThemData.white,
                                                  onTap: () {
                                                    Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                  },
                                                  size: Size(Responsive.width(100, context), 52),
                                                )  : Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: RoundShapeButton(
                                                              title: "Cancel Ride".tr,
                                                              buttonColor: AppThemData.danger_500p,
                                                              buttonTextColor: AppThemData.white,
                                                              onTap: () {
                                                                Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                              },
                                                              size: const Size(double.infinity, 48),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: RoundShapeButton(
                                                              title: "View Bid".tr,
                                                              buttonColor: AppThemData.primary500,
                                                              buttonTextColor: AppThemData.black,
                                                              onTap: () {
                                                                ParcelRideDetailsController detailsController = Get.put(ParcelRideDetailsController());
                                                                detailsController.bookingId.value = parcelModel.id ?? '';
                                                                detailsController.parcelModel.value = parcelModel;
                                                                Get.to(const ParcelRideDetailsView());
                                                              },
                                                              size: const Size(double.infinity, 48),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : parcelModel.bookingStatus == BookingStatus.bookingAccepted
                                                        ? RoundShapeButton(
                                                            title: "Cancel Ride".tr,
                                                            buttonColor: AppThemData.danger_500p,
                                                            buttonTextColor: AppThemData.white,
                                                            onTap: () {
                                                              Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                            },
                                                            size: Size(Responsive.width(100, context), 52),
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}
