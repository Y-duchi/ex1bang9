from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .serializers import UserRegisterSerializer
from .models import User
from django.db import connection
import hashlib
from django.http import JsonResponse
import random
from django.core.mail import send_mail

@api_view(['POST'])
def kakao_login(request):
    kakao_id = request.data.get('kakao_id')
    nickname = request.data.get('nickname')
    email = request.data.get('email')

    if not kakao_id:
        return Response({'success': False, 'message': '카카오 ID가 없습니다.'}, status=400)

    # 이미 존재하면 로그인 처리
    user, created = User.objects.get_or_create(
        user_id=kakao_id,
        defaults={
            'username': nickname or '',
            'nickname': nickname or '',
            'email': email or '',
            'password_hash': '',  # 소셜 로그인은 비번 필요 없음
            'phone': '',
            'points': 0,
            'certification': False,
            'login_type': 'kakao',
        }
    )

    return Response({'success': True, 'message': '카카오 로그인 완료', 'user_id': user.user_id})


# 회원가입
@api_view(['POST'])
def register(request):
    serializer = UserRegisterSerializer(data=request.data)
    if serializer.is_valid():
        data = serializer.validated_data

        # 아이디 중복 확인
        if User.objects.filter(user_id=data['user_id']).exists():
            return Response({'success': False, 'message': '이미 존재하는 아이디입니다.'}, status=status.HTTP_400_BAD_REQUEST)

        # 비밀번호 해싱
        password_hash = hashlib.sha256(data['password_hash'].encode()).hexdigest()

        # INSERT 쿼리 실행
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO users (user_id, password_hash, username, nickname, phone, email, points, certification, login_type)
                VALUES (%s, %s, %s, %s, %s, %s, 0, FALSE, 'normal')
            """, [
                data['user_id'],
                password_hash,
                data['username'],
                data.get('nickname'),
                data['phone'],
                data['email']
            ])


        return Response({'success': True, 'message': '회원가입 성공!'}, status=status.HTTP_201_CREATED)

    return Response({'success': False, 'message': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

# 아이디 중복 확인
@api_view(['POST'])
def check_duplicate_user_id(request):
    user_id = request.data.get('user_id')


    if not user_id:
        return JsonResponse({'success': False, 'message': '아이디를 입력하세요.'}, json_dumps_params={'ensure_ascii': False})

    if User.objects.filter(user_id=user_id).exists():
        return JsonResponse({'success': False, 'message': '이미 사용 중인 아이디입니다.'}, json_dumps_params={'ensure_ascii': False})
    else:
        return JsonResponse({'success': True, 'message': '사용 가능한 아이디입니다.'}, json_dumps_params={'ensure_ascii': False})

# 이메일 인증번호 전송
email_verification_codes = {} # 메모리 상 임시 저장용
@api_view(['POST'])
def send_email_verification(request):
    email = request.data.get('email')
    if not email:
        return Response({'success': False, 'message': '이메일을 입력하세요.'}, status=status.HTTP_400_BAD_REQUEST)

    code = str(random.randint(100000, 999999))
    email_verification_codes[email] = code

    send_mail(
        '이메일 인증번호',
        f'인증번호는 {code} 입니다.',
        '방꾸석 <ahs660500@gmail.com>', # settings.py EMAIL_HOST_USER 값
        [email],
        fail_silently=False,
    )

    return Response({'success': True, 'message': '인증번호가 이메일로 전송되었습니다.'})

# 이메일 인증번호 확인
@api_view(['POST'])
def verify_email_code(request):
    email = request.data.get('email')
    code = request.data.get('code')

    if not email or not code:
        return Response({'success': False, 'message': '이메일과 인증번호를 입력하세요.'}, status=status.HTTP_400_BAD_REQUEST)

    if email_verification_codes.get(email) == code:
        return Response({'success': True, 'message': '인증되었습니다.'})
    else:
        return Response({'success': False, 'message': '인증번호가 일치하지 않습니다.'}, status=status.HTTP_400_BAD_REQUEST)

# 로그인
@api_view(['POST'])
def login(request):
    user_id = request.data.get('user_id')
    password = request.data.get('password')

    # 비밀번호 해싱
    password_hash = hashlib.sha256(password.encode()).hexdigest()

    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM users WHERE user_id=%s AND password_hash=%s", [user_id, password_hash])
        user = cursor.fetchone()

    if user:
        return Response({'success': True, 'message': '로그인 성공 !'})
    else:
        return Response({'success': False, 'message': '아이디 또는 비밀번호가 틀렸습니다.'})