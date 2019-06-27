@if not defined _echo @echo off

set currentDir=%~dp0
set WheelFile=nimbusml-1.1.0-cp36-none-win_amd64.whl

if exist %currentDir%build (rmdir /S /Q %currentDir%\0build)
if exist %currentDir%\..\..\..\..\dependencies\Python3.6 (
echo "Python3.6 exists"
) else (
echo "Please run build.cmd under NimbusML with Python3.6's configuration first"
call exit /b
)
echo "#################################"
echo "Downloading Dependencies "
echo "#################################"
set PY=%currentDir%..\..\..\..\dependencies\Python3.6\python.exe
call %PY% -m pip -q install pip==9.0.3
echo "Installing sphinx-docfx-yaml... "
call %PY% -m pip -q install sphinx-docfx-yaml
echo "Installing sphinx... "
call %PY% -m pip -q install sphinx==2.1.1
echo "Installing sphinx_rtd_theme... "
call %PY% -m pip -q install sphinx_rtd_theme
echo "Installing NimbusML... "
call %PY% -m pip -q install %currentDir%..\..\..\..\target\%WheelFile%
echo.

echo.
echo "#################################"
echo "Running sphinx-build "
echo "#################################"
call %PY% -m sphinx -c %currentDir%ci_script %currentDir% %currentDir%_build

echo.
echo "#################################"
echo "Copying files "
echo "#################################"
call mkdir %currentDir%_build\ms_doc_ref\
call xcopy /S /I /Q /Y /F %currentDir%_build\docfx_yaml\* %currentDir%_build\ms_doc_ref\nimbusml\docs-ref-autogen

echo.
echo "#################################"
echo "Running make_md.bat"
echo "Fixing API guide
echo "#################################"
call %PY% -m pip -q install sphinx==1.6.2
call make md
exit /b
call %py% %~dp0ci_script\fix_apiguide.py

call copy /Y %~dp0toc.yml %~dp0_build\ms_doc_ref\nimbusml\toc.yml
call xcopy /Y /S %~dp0_build\md\* %~dp0_build\ms_doc_ref\nimbusml

echo.
echo "#################################"
echo "updating yml......."
echo "#################################"
call %PY% %~dp0ci_script\gen_toc_yml.py -input %~dp0_build\ms_doc_ref\nimbusml\index.md -temp %~dp0_build\ms_doc_ref\nimbusml\toc_ref.yml -output %~dp0_build\ms_doc_ref\nimbusml\toc.yml

echo.
echo "#################################"
echo "updating reference links...."
echo "#################################"
call %PY% %~dp0ci_script\update_all_toc_yml.py

echo.
echo "#################################"
echo "updating ms-scikit.md to modules.md"
echo "#################################"
call move %~dp0_build\ms_doc_ref\nimbusml\modules.md %~dp0_build\ms_doc_ref\nimbusml\ms-scikit.md

echo.
echo "#################################"
echo "Cleaning files"
echo "#################################"
call mkdir %~dp0_build\ms_doc_ref\nimbusml\_images\_static
call xcopy /S /I /Q /Y /F %~dp0ci_script\_static %~dp0_build\ms_doc_ref\nimbusml\_images\_static
call mkdir %~dp0build
call move %~dp0_build\ms_doc_ref %~dp0\build\
call more +29 %~dp0build\ms_doc_ref\nimbusml\index.md >> %~dp0build\ms_doc_ref\nimbusml\overview.md
call del /Q %~dp0build\ms_doc_ref\nimbusml\*log
call del /Q %~dp0build\ms_doc_ref\nimbusml\concepts.md
call del /Q %~dp0build\ms_doc_ref\nimbusml\index.md
call del /Q %~dp0build\ms_doc_ref\nimbusml\toc.yml
call rmdir /Q %~dp0build\ms_doc_ref\nimbusml\_static
:: call rmdir /S /Q %~dp0_build

echo.
echo "#################################"
echo "#########Built Finished##########"
echo "#################################"