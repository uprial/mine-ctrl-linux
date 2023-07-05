install:
	python3 -m pip install --upgrade pip
	pip3 install pylint

check:
	python3 -m pylint --disable="missing-docstring,invalid-name,line-too-long,too-few-public-methods,unspecified-encoding" *.py
