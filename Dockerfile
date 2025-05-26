# استخدم Python كصورة أساسية
FROM python:3.10-slim

# إعداد مجلد العمل داخل الحاوية
WORKDIR /app

# نسخ الملفات إلى داخل الحاوية
COPY . .

# تثبيت المتطلبات (لو عندك requirements.txt)
RUN pip install --no-cache-dir -r requirements.txt

# تشغيل التطبيق (لو عندك app.py)
CMD ["python", "app.py"]
