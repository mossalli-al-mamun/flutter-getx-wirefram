// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get update => 'تحديث';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get continueText => 'متابعة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'حدث خطأ ما';

  @override
  String get success => 'نجح';

  @override
  String get tryAgain => 'يرجى المحاولة مرة أخرى';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get register => 'تسجيل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get rememberPassword => 'تذكرت كلمة المرور؟';

  @override
  String get confirmPasswordPlaceholder => 'أعد إدخال كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signInWith => 'تسجيل الدخول باستخدام';

  @override
  String get orContinueWith => 'أو المتابعة باستخدام';

  @override
  String get signInWithGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get signInWithApple => 'تسجيل الدخول باستخدام Apple';

  @override
  String get signInWithFacebook => 'تسجيل الدخول باستخدام Facebook';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get invalidCredentials => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get letsLogin => 'لنقم بتسجيل الدخول باستخدام بياناتك';

  @override
  String get letsSignUp => 'لنقم بإنشاء حساب';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين';

  @override
  String get emailPlaceholder => 'اسمك@البريدالإلكتروني.com';

  @override
  String get passwordPlaceholder => 'أدخل كلمة المرور';

  @override
  String resendCodeIn(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds';
  }

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get otpIncorrect => 'رمز التحقق غير صحيح';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get iAgreeToThe => 'أوافق على ';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get account => 'الحساب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNamePlaceholder => 'أدخل اسمك الكامل';

  @override
  String get country => 'الدولة';

  @override
  String get address => 'العنوان';

  @override
  String get apartmentOptional => 'شقة، جناح، إلخ.';

  @override
  String get apartmentOptionalValue => 'شقة، جناح، إلخ (اختياري)';

  @override
  String get state => 'المحافظة/الولاية';

  @override
  String get city => 'المدينة';

  @override
  String get zipCode => 'الرمز البريدي';

  @override
  String get phoneOptional => 'الهاتف (اختياري)';

  @override
  String get phone => 'الهاتف';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get seeMore => 'المزيد';

  @override
  String get noDataFound => 'لم يتم العثور على بيانات';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get welcome => 'مرحباً';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get noRouteFound => 'لم يتم العثور على مسار';

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get areYouSureDetails =>
      'أنت على وشك مغادرة هذه الصفحة. هل أنت متأكد أنك تريد مغادرة هذه الصفحة؟';

  @override
  String get neverMind => 'لا بأس';

  @override
  String get leave => 'مغادرة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get isRequired => 'مطلوب';

  @override
  String get searchHere => 'ابحث هنا...';

  @override
  String emptyData(Object value) {
    return 'بيانات فارغة $value';
  }

  @override
  String get add => 'إضافة';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get file => 'ملف';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get searchResultFor => 'نتائج البحث عن';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get connectivityStatusError => 'تعذر الحصول على حالة الاتصال:';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'غير متصل';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get pleaseCheckYourConnection => 'يرجى التحقق من اتصالك';

  @override
  String get deviceOnline => 'جهازك متصل الآن';

  @override
  String get deviceOffline => 'جهازك غير متصل حالياً';

  @override
  String get theme => 'السمة';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get name => 'الاسم';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get spanish => 'الإسبانية';
}
