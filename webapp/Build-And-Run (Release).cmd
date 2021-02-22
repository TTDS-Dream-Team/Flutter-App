call flutter build web --web-renderer canvaskit
xcopy "build\web\" "..\docs" /e /i /h /y
cd ../docs
python -m http.server 8000