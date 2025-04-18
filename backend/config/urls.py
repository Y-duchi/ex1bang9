from django.contrib import admin
from django.urls import path
from users.views import (
    register,
    check_duplicate_user_id,
    login,
    send_email_verification,
    verify_email_code,
    kakao_login
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', register),
    path('check_user_id/', check_duplicate_user_id),
    path('login/', login),
    path('send_email_verification/', send_email_verification),
    path('verify_email_code/', verify_email_code),
    path('kakao_login/', kakao_login),
]