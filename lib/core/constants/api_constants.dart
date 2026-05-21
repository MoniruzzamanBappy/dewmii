class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://moniruzzamanbappy.github.io/ecommerce-demo-json-api';

  // Auth Demo APIs
  static const String register = '$baseUrl/auth/register.json';
  static const String login = '$baseUrl/auth/login.json';
  static const String logout = '$baseUrl/auth/logout.json';
  static const String refreshToken = '$baseUrl/auth/refresh-token.json';
  static const String forgotPassword = '$baseUrl/auth/forgot-password.json';
  static const String verifyOtp = '$baseUrl/auth/verify-otp.json';
  static const String resetPassword = '$baseUrl/auth/reset-password.json';
  static const String changePassword = '$baseUrl/auth/change-password.json';
  static const String me = '$baseUrl/auth/me.json';

  // Home & Discovery Demo APIs
  static const String home = '$baseUrl/home/index.json';
  static const String banners = '$baseUrl/banners/index.json';
  static const String categories = '$baseUrl/categories/index.json';
  static const String products = '$baseUrl/products/index.json';
  static const String productSearch = '$baseUrl/products/search.json';
  static const String featuredProducts = '$baseUrl/products/featured.json';
  static const String newArrivals = '$baseUrl/products/new-arrivals.json';
  static const String bestSelling = '$baseUrl/products/best-selling.json';

  static String categoryDetails(int id) {
    return '$baseUrl/categories/category-$id.json';
  }

  static String categoryProducts(int id) {
    return '$baseUrl/categories/category-$id-products.json';
  }

  static String productDetails(int id) {
    return '$baseUrl/products/product-$id.json';
  }

  static String productImages(int id) {
    return '$baseUrl/products/product-$id-images.json';
  }

  static String productRelated(int id) {
    return '$baseUrl/products/product-$id-related.json';
  }

  static String productReviews(int id) {
    return '$baseUrl/products/product-$id-reviews.json';
  }

  static String productStock(int id) {
    return '$baseUrl/products/product-$id-stock.json';
  }

  // Cart Demo APIs
  static const String cart = '$baseUrl/cart/index.json';
  static const String cartAddItem = '$baseUrl/cart/add-item.json';
  static const String cartUpdateItem = '$baseUrl/cart/update-item.json';
  static const String cartRemoveItem = '$baseUrl/cart/remove-item.json';
  static const String cartClear = '$baseUrl/cart/clear-cart.json';
  static const String cartApplyCoupon = '$baseUrl/cart/apply-coupon.json';
  static const String cartRemoveCoupon = '$baseUrl/cart/remove-coupon.json';
  static const String cartSummary = '$baseUrl/cart/summary.json';

  // Wishlist Demo APIs
  static const String wishlist = '$baseUrl/wishlist/index.json';
  static const String wishlistAdd = '$baseUrl/wishlist/add.json';
  static const String wishlistRemove = '$baseUrl/wishlist/remove.json';
  static const String wishlistMoveToCart =
      '$baseUrl/wishlist/move-to-cart.json';

  // Checkout Demo APIs
  static const String checkout = '$baseUrl/checkout/index.json';
  static const String checkoutValidate = '$baseUrl/checkout/validate.json';
  static const String shippingMethods = '$baseUrl/shipping-methods/index.json';
  static const String paymentMethods = '$baseUrl/payment-methods/index.json';
  static const String orderPreview = '$baseUrl/orders/preview.json';
  static const String placeOrder = '$baseUrl/orders/place-order.json';
  static const String paymentInitiate = '$baseUrl/payments/initiate.json';
  static const String paymentVerify = '$baseUrl/payments/verify.json';
  static const String paymentWebhook = '$baseUrl/payments/webhook.json';

  // Address Demo APIs
  static const String addresses = '$baseUrl/addresses/index.json';
  static const String addressAdd = '$baseUrl/addresses/add.json';
  static const String addressUpdate = '$baseUrl/addresses/update.json';
  static const String addressDelete = '$baseUrl/addresses/delete.json';
  static const String addressSetDefault = '$baseUrl/addresses/set-default.json';

  static String addressDetails(int id) {
    return '$baseUrl/addresses/address-$id.json';
  }

  // Order Demo APIs
  static const String orders = '$baseUrl/orders/index.json';
  static const String orderCancel = '$baseUrl/orders/cancel.json';
  static const String orderReturnRequest =
      '$baseUrl/orders/return-request.json';
  static const String orderRefundRequest =
      '$baseUrl/orders/refund-request.json';
  static const String orderInvoice = '$baseUrl/orders/invoice.json';

  static String orderDetails(int id) {
    return '$baseUrl/orders/order-$id.json';
  }

  static String orderTracking(int id) {
    return '$baseUrl/orders/order-$id-tracking.json';
  }

  // Profile & Account Demo APIs
  static const String userProfile = '$baseUrl/users/profile.json';
  static const String updateProfile = '$baseUrl/users/update-profile.json';
  static const String uploadAvatar = '$baseUrl/users/avatar.json';
  static const String userChangePassword =
      '$baseUrl/users/change-password.json';
  static const String notificationSettings =
      '$baseUrl/users/notification-settings.json';
  static const String updateNotificationSettings =
      '$baseUrl/users/update-notification-settings.json';
  static const String deleteAccount = '$baseUrl/users/delete-account.json';

  // Notification Demo APIs
  static const String notifications = '$baseUrl/notifications/index.json';
  static const String notificationMarkRead =
      '$baseUrl/notifications/mark-read.json';
  static const String notificationReadAll =
      '$baseUrl/notifications/read-all.json';
  static const String notificationDelete = '$baseUrl/notifications/delete.json';

  static String notificationDetails(int id) {
    return '$baseUrl/notifications/notification-$id.json';
  }

  // Support Demo APIs
  static const String faqs = '$baseUrl/support/faqs.json';
  static const String helpArticles = '$baseUrl/support/help-articles.json';
  static const String contact = '$baseUrl/support/contact.json';
  static const String supportTickets = '$baseUrl/support/tickets/index.json';
  static const String supportTicketCreate =
      '$baseUrl/support/tickets/create.json';
  static const String supportTicketReply =
      '$baseUrl/support/tickets/reply.json';

  static String supportTicketDetails(int id) {
    return '$baseUrl/support/tickets/ticket-$id.json';
  }

  // Admin Demo APIs
  static const String adminLogin = '$baseUrl/admin/auth/login.json';
  static const String adminDashboard = '$baseUrl/admin/dashboard.json';
  static const String adminSalesAnalytics =
      '$baseUrl/admin/analytics/sales.json';
  static const String adminProductAnalytics =
      '$baseUrl/admin/analytics/products.json';
  static const String adminCustomerAnalytics =
      '$baseUrl/admin/analytics/customers.json';

  // Admin Product Management Demo APIs
  static const String adminProducts = '$baseUrl/admin/products/index.json';
  static const String adminProductCreate =
      '$baseUrl/admin/products/create.json';
  static const String adminProductUpdate =
      '$baseUrl/admin/products/update.json';
  static const String adminProductDelete =
      '$baseUrl/admin/products/delete.json';
  static const String adminProductUploadImages =
      '$baseUrl/admin/products/upload-images.json';
  static const String adminProductDeleteImage =
      '$baseUrl/admin/products/delete-image.json';
  static const String adminProductUpdateStock =
      '$baseUrl/admin/products/update-stock.json';

  static String adminProductDetails(int id) {
    return '$baseUrl/admin/products/product-$id.json';
  }

  // Admin Category Management Demo APIs
  static const String adminCategories = '$baseUrl/admin/categories/index.json';
  static const String adminCategoryCreate =
      '$baseUrl/admin/categories/create.json';
  static const String adminCategoryUpdate =
      '$baseUrl/admin/categories/update.json';
  static const String adminCategoryDelete =
      '$baseUrl/admin/categories/delete.json';

  // Admin Order Management Demo APIs
  static const String adminOrders = '$baseUrl/admin/orders/index.json';
  static const String adminOrderUpdateStatus =
      '$baseUrl/admin/orders/update-status.json';
  static const String adminOrderUpdatePaymentStatus =
      '$baseUrl/admin/orders/update-payment-status.json';
  static const String adminOrderUpdateTracking =
      '$baseUrl/admin/orders/update-tracking.json';

  static String adminOrderDetails(int id) {
    return '$baseUrl/admin/orders/order-$id.json';
  }

  // Admin User Management Demo APIs
  static const String adminUsers = '$baseUrl/admin/users/index.json';
  static const String adminUserUpdateStatus =
      '$baseUrl/admin/users/update-status.json';
  static const String adminUserUpdateRole =
      '$baseUrl/admin/users/update-role.json';

  static String adminUserDetails(int id) {
    return '$baseUrl/admin/users/user-$id.json';
  }
}
