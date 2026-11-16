@echo off
rem Builds tessera.exe on Windows. Needs Rust from https://rustup.rs (it also offers to install the C++ build tools).
where cargo >nul 2>nul
if errorlevel 1 (
  echo Rust is not installed. Get it from https://rustup.rs and run this file again.
  pause
  exit /b 1
)
cargo build --release
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)
echo.
echo Done: %~dp0target\release\tessera.exe
pause
