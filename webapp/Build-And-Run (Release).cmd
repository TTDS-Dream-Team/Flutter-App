call flutter build web --web-renderer html --release
xcopy "build\web\" "..\docs" /e /i /h /y
cd ../docs
python -m http.server 8000