import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/locale_provider.dart';

const Map<String, Map<String, String>> _strings = {
  // App
  'app_title': {'ar': 'شركة رائد الخير', 'en': 'Raed AlKhair', 'ku': 'کۆمپانیای ڕائیدالخێر'},
  'app_subtitle': {
    'ar': 'الوكيل الحصري لشركة DXN العالمية في العراق',
    'en': 'The exclusive distributor of DXN International in Iraq',
    'ku': 'نوێنەری تایبەتی کۆمپانیای جیهانی DXN لە عێراق',
  },

  // Common
  'retry': {'ar': 'إعادة المحاولة', 'en': 'Retry', 'ku': 'دووبارە هەوڵبدەرەوە'},
  'logout': {'ar': 'تسجيل الخروج', 'en': 'Logout', 'ku': 'چوونەدەرەوە'},
  'arabic': {'ar': 'العربية', 'en': 'Arabic', 'ku': 'عەرەبی'},
  'english': {'ar': 'الإنجليزية', 'en': 'English', 'ku': 'ئینگلیزی'},
  'kurdish': {'ar': 'الكردية', 'en': 'Kurdish', 'ku': 'کوردی'},
  'language': {'ar': 'اللغة', 'en': 'Language', 'ku': 'زمان'},
  'no_description': {'ar': 'لا يوجد وصف لهذا المنتج', 'en': 'No description available', 'ku': 'هیچ وەسفێک نییە'},

  // Login
  'membership_no': {'ar': 'رقم العضوية', 'en': 'Membership No.', 'ku': 'ژمارەی ئەندامیەتی'},
  'password': {'ar': 'كلمة السر', 'en': 'Password', 'ku': 'وشەی نهێنی'},
  'login': {'ar': 'تسجيل الدخول', 'en': 'Login', 'ku': 'چوونەژوورەوە'},
  'create_account': {'ar': 'انشاء حساب', 'en': 'Create Account', 'ku': 'دروستکردنی هەژمار'},
  'login_required_fields': {
    'ar': 'الرجاء إدخال رقم العضوية وكلمة السر',
    'en': 'Please enter membership number and password',
    'ku': 'تکایە ژمارەی ئەندامیەتی و وشەی نهێنی بنووسە',
  },
  'login_failed': {'ar': 'فشل تسجيل الدخول', 'en': 'Login failed', 'ku': 'چوونەژوورەوە سەرکەوتوو نەبوو'},

  // Signup
  'signup_title': {'ar': 'إنشاء حساب جديد', 'en': 'Create New Account', 'ku': 'دروستکردنی هەژمارێکی نوێ'},
  'full_name': {'ar': 'الاسم الكامل', 'en': 'Full Name', 'ku': 'ناوی تەواو'},
  'mobile_number': {'ar': 'رقم الموبايل', 'en': 'Mobile Number', 'ku': 'ژمارەی مۆبایل'},
  'address_optional': {'ar': 'العنوان (اختياري)', 'en': 'Address (optional)', 'ku': 'ناونیشان (ئارەزوومەندانە)'},
  'confirm_password': {'ar': 'تأكيد كلمة السر', 'en': 'Confirm Password', 'ku': 'دوپاتکردنەوەی وشەی نهێنی'},
  'sign_up': {'ar': 'انشاء مستخدم جديد', 'en': 'Sign Up', 'ku': 'تۆمارکردن'},
  'select_branch': {'ar': 'اختر الفرع المفضل', 'en': 'Select preferred branch', 'ku': 'لقی دڵخواز هەڵبژێرە'},
  'cant_load_branches': {'ar': 'تعذر جلب الفروع', 'en': "Couldn't load branches", 'ku': 'نەتوانرا لقەکان بهێنرێت'},
  'fill_all_required': {
    'ar': 'الرجاء تعبئة كل الحقول الإلزامية واختيار الفرع',
    'en': 'Please fill all required fields and select a branch',
    'ku': 'تکایە هەموو خانە پێویستەکان پڕبکەرەوە و لق هەڵبژێرە',
  },
  'passwords_no_match': {
    'ar': 'كلمتا السر غير متطابقتين',
    'en': "Passwords don't match",
    'ku': 'وشە نهێنییەکان وەک یەک نین',
  },
  'signup_failed': {'ar': 'فشل إنشاء الحساب', 'en': 'Account creation failed', 'ku': 'دروستکردنی هەژمار سەرکەوتوو نەبوو'},

  // Home / nav
  'tab_home': {'ar': 'الرئيسية', 'en': 'Home', 'ku': 'سەرەکی'},
  'tab_branches': {'ar': 'اختر فرع', 'en': 'Branches', 'ku': 'هەڵبژاردنی لق'},
  'tab_profile': {'ar': 'بروفايل', 'en': 'Profile', 'ku': 'پرۆفایل'},

  // Branches tab
  'no_branches': {'ar': 'لا توجد فروع متاحة', 'en': 'No branches available', 'ku': 'هیچ لقێک بەردەست نییە'},
  'cant_load_branches_long': {'ar': 'تعذّر جلب الفروع', 'en': "Couldn't load branches", 'ku': 'نەتوانرا لقەکان بهێنرێت'},

  // Categories
  'no_categories': {'ar': 'لا توجد فئات لهذا الفرع', 'en': 'No categories for this branch', 'ku': 'هیچ پۆلێک بۆ ئەم لقە نییە'},
  'cant_load_categories': {'ar': 'تعذر جلب الفئات', 'en': "Couldn't load categories", 'ku': 'نەتوانرا پۆلەکان بهێنرێت'},

  // Products
  'no_products': {'ar': 'لا توجد منتجات في هذه الفئة', 'en': 'No products in this category', 'ku': 'هیچ بەرهەمێک لەم پۆلەدا نییە'},
  'cant_load_products': {'ar': 'تعذر جلب المنتجات', 'en': "Couldn't load products", 'ku': 'نەتوانرا بەرهەمەکان بهێنرێت'},
  'delivery_72h': {
    'ar': 'يتم التوصيل عادة خلال 72 ساعة',
    'en': 'Usually delivered within 72 hours',
    'ku': 'بە زۆری لە ماوەی ٧٢ کاتژمێردا دەگەیەنرێت',
  },

  // Order screen
  'member_price': {'ar': 'سعر العضو', 'en': 'Member price', 'ku': 'نرخی ئەندام'},
  'non_member_price': {'ar': 'سعر غير العضو', 'en': 'Non-member price', 'ku': 'نرخی نائەندام'},
  'qty_min_one': {'ar': 'اختر كمية أكبر من صفر', 'en': 'Choose a quantity greater than zero', 'ku': 'بڕێکی گەورەتر لە سفر هەڵبژێرە'},
  'added_to_cart': {'ar': 'تمت الإضافة إلى السلة', 'en': 'Added to cart', 'ku': 'بۆ سەبەتە زیادکرا'},
  'add_failed_login_first': {
    'ar': 'تعذر إضافة المنتج. سجّل الدخول أولاً',
    'en': "Couldn't add product. Please log in first",
    'ku': 'نەتوانرا بەرهەم زیاد بکرێت. سەرەتا بچۆ ژوورەوە',
  },
  'adding': {'ar': 'جارٍ الإضافة…', 'en': 'Adding…', 'ku': 'زیاد دەکرێت…'},
  'buy_open_cart': {'ar': 'شراء (إضافة وفتح السلة)', 'en': 'Buy (add & open cart)', 'ku': 'کڕین (زیاد و کردنەوەی سەبەتە)'},
  'add_to_cart': {'ar': 'إضافة إلى السلة', 'en': 'Add to cart', 'ku': 'زیادکردن بۆ سەبەتە'},
  'open_cart': {'ar': 'فتح السلة', 'en': 'Open cart', 'ku': 'کردنەوەی سەبەتە'},

  // Cart
  'cart': {'ar': 'سلة', 'en': 'Cart', 'ku': 'سەبەتە'},
  'cart_empty': {'ar': 'السلة فارغة', 'en': 'Cart is empty', 'ku': 'سەبەتە بەتاڵە'},
  'subtotal': {'ar': 'مجموع', 'en': 'Subtotal', 'ku': 'کۆ'},
  'clear_cart': {'ar': 'حذف السلة', 'en': 'Clear cart', 'ku': 'سڕینەوەی سەبەتە'},
  'total_pv': {'ar': 'مجموع النقاط', 'en': 'Total PV', 'ku': 'کۆی خاڵەکان'},
  'checkout_member_price': {
    'ar': 'اكمال عملية الشراء بسعر العضو',
    'en': 'Checkout at member price',
    'ku': 'تەواوکردنی کڕین بە نرخی ئەندام',
  },
  'checkout_non_member_price': {
    'ar': 'اكمال عملية الشراء بسعر غير العضو',
    'en': 'Checkout at non-member price',
    'ku': 'تەواوکردنی کڕین بە نرخی نائەندام',
  },

  // Checkout
  'confirm_order': {'ar': 'تأكيد الطلب', 'en': 'Confirm Order', 'ku': 'پشتڕاستکردنەوەی داواکاری'},
  'payment_method': {'ar': 'طريقة الدفع', 'en': 'Payment method', 'ku': 'شێوازی پارەدان'},
  'delivery_fee': {'ar': 'أجور التوصيل', 'en': 'Delivery fee', 'ku': 'کرێی گەیاندن'},
  'send_order': {'ar': 'إرسال الطلب', 'en': 'Send order', 'ku': 'ناردنی داواکاری'},
  'send_failed': {'ar': 'فشل إرسال الطلب', 'en': 'Failed to send order', 'ku': 'ناردنی داواکاری سەرکەوتوو نەبوو'},
  'buyer': {'ar': 'المشتري', 'en': 'Buyer', 'ku': 'کڕیار'},
  'item_count': {'ar': 'عدد الأصناف', 'en': 'Items count', 'ku': 'ژمارەی بەرهەمەکان'},
  'price_for_member': {'ar': 'السعر للعضو', 'en': 'Member price', 'ku': 'نرخ بۆ ئەندام'},
  'price_for_non_member': {'ar': 'السعر لغير العضو', 'en': 'Non-member price', 'ku': 'نرخ بۆ نائەندام'},

  // Success
  'thanks': {'ar': 'شكراً', 'en': 'Thanks', 'ku': 'سوپاس'},
  'thanks_for_order': {'ar': 'شكراً لطلبك', 'en': 'Thanks for your order', 'ku': 'سوپاس بۆ داواکارییەکەت'},
  'your_order_no': {'ar': 'رقم طلبك', 'en': 'Your order #', 'ku': 'ژمارەی داواکارییەکەت'},
  'order_processed_24h': {
    'ar': "سيتم معالجة طلبك في غضون 24 ساعة\nشاكرين لك ثقتك بنا\n'شركة رائد الخير'",
    'en': "Your order will be processed within 24 hours\nThank you for trusting us\n'Raed AlKhair Co.'",
    'ku': "داواکارییەکەت لە ماوەی ٢٤ کاتژمێردا چارەسەر دەکرێت\nسوپاس بۆ متمانەکەت\n'کۆمپانیای ڕائیدالخێر'",
  },
  'continue_to_home': {'ar': 'متابعة إلى الصفحة الرئيسية', 'en': 'Continue to home', 'ku': 'بەردەوامبوون بۆ سەرەکی'},

  // Profile
  'not_logged_in': {
    'ar': 'لم يتم تسجيل الدخول. الرجاء العودة لتسجيل الدخول.',
    'en': 'Not logged in. Please return to login.',
    'ku': 'نەچوویتە ژوورەوە. تکایە بگەڕێرەوە بۆ چوونەژوورەوە.',
  },
  'wallet_south': {'ar': 'رصيد محفظتي الجنوبية', 'en': 'Southern wallet balance', 'ku': 'باڵانسی جزدانی باشوور'},
  'wallet_north': {'ar': 'رصيد محفظتي الشمالية', 'en': 'Northern wallet balance', 'ku': 'باڵانسی جزدانی باکوور'},
  'points': {'ar': 'النقاط', 'en': 'Points', 'ku': 'خاڵەکان'},
  'order_status': {'ar': 'حالة الطلبية', 'en': 'Order status', 'ku': 'دۆخی داواکاری'},
  'invoice_no': {'ar': 'رقم الفاتورة', 'en': 'Invoice No.', 'ku': 'ژمارەی پسوولە'},
  'back_to_home': {'ar': 'الرجوع إلى الصفحة الرئيسية', 'en': 'Back to home', 'ku': 'گەڕانەوە بۆ سەرەکی'},
};

String t(WidgetRef ref, String key) {
  final lang = ref.watch(localeProvider).languageCode;
  return _strings[key]?[lang] ?? _strings[key]?['ar'] ?? key;
}

String tLang(String lang, String key) {
  return _strings[key]?[lang] ?? _strings[key]?['ar'] ?? key;
}
